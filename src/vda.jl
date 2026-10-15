const C = 299_792_458.0      # m/s
const AU = 1.495978707e11    # m
const MASS = (; proton = 938.27208816, electron = 0.51099895000)  # MeV/c²

# Speed over c of a particle with kinetic energy `E` and rest energy `m` (MeV).
beta(E, m) = sqrt(1 - (1 / (1 + E / m))^2)

"""
    vda(onsets, energies; particle = :proton, mass = MASS[particle])
    vda([f = CUSUM()], x, (t0, t1); energies, dim, particle, mass, N)

Least-squares fit of

```math
t = t_0 + \\frac{s}{c} β^{-1}, \\quad β = \\sqrt{1 - \\left(\\frac{1}{1 + E / mc^2}\\right)^2}
```

with `slope` ``s/c`` (s) and `intercept` ``t_0`` (Unix s).
"""
function vda(onsets::AbstractVector, energies::AbstractVector; particle = :proton, mass = MASS[particle])
    length(onsets) == length(energies) || throw(DimensionMismatch("$(length(onsets)) onsets but $(length(energies)) energies"))
    valid = findall(!isnothing, onsets)
    length(valid) < 2 && throw(ArgumentError("VDA needs at least 2 onsets, got $(length(valid))"))
    onsets, energies = DateTime.(onsets[valid]), energies[valid]
    inverse_betas = 1 ./ beta.(energies, mass)
    X = [ones(length(valid)) inverse_betas]
    y = datetime2unix.(onsets)
    coef = X \ y
    intercept, slope = coef
    residuals = y - X * coef
    dof = length(y) - 2
    se = dof > 0 ? sqrt.(sum(abs2, residuals) / dof * diag(inv(X' * X))) : [NaN, NaN]
    return (;
        release_time = unix2datetime(intercept), path_length = slope * C / AU,
        release_time_error = se[1], path_length_error = se[2] * C / AU,
        r2 = 1 - sum(abs2, residuals) / sum(abs2, y .- mean(y)),
        onsets, energies, inverse_betas, slope, intercept,
    )
end

function vda(f, x, bg; energies = nothing, dim = nothing, particle = :proton, mass = MASS[particle], kw...)
    d = TimeseriesUtilities.resolve_dim(x, dim)
    ndims(x) == 2 || throw(ArgumentError("VDA needs channels × time, got $(ndims(x)) dimensions"))
    onsets = map(o -> o.time, find_onset(f, x, bg; dim = d, kw...))
    return vda(onsets, @something(energies, _energies(getdim(x, 3 - d))); mass)
end

vda(x, bg; kw...) = vda(CUSUM(), x, bg; kw...)

const MEV_PER = Dict("eV" => 1.0e-6, "keV" => 1.0e-3, "MeV" => 1.0, "GeV" => 1.0e3)

function _energies(E)
    E isa AbstractVector{<:Real} || throw(ArgumentError("channel energies must be a vector; pass `energies` (MeV)"))
    u = units(E)
    scale = get(MEV_PER, u, nothing)
    isnothing(scale) && throw(ArgumentError("unknown channel energy units $(repr(u)); pass `energies` (MeV)"))
    return scale .* unwrap(E)
end
