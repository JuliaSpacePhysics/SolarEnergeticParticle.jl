"""
    CUSUM(; n = 2, k = nothing, h = nothing)

Poisson-CUSUM warnings of intensity `I` over background `bg` with mean `μ` and standard deviation `σ`.
The CUSUM function of the standardized intensity ``I_z = (I - μ) / σ`` is

```math
S_i = \\max(0, I_{z,i} - k + S_{i-1}), \\quad S_1 = 0
```

and each ``S_i > h`` is a warning.

- ``k = n / (\\ln(μ + nσ) - \\ln μ)`` unless given, rounded to the nearest integer when ``k > 1``.
- ``h = 1`` when ``k ≤ 1``, else ``2`` (Huttunen-Heikinmaa et al. 2005), unless given.
"""
Base.@kwdef struct CUSUM{N, K, H}
    n::N = 2
    k::K = nothing
    h::H = nothing
end

function (m::CUSUM)(bg, I)
    μ, σ = mean(bg), std(bg)
    warnings = fill!(similar(I, Bool), false)
    isfinite(σ) && σ > 0 || return warnings
    k, h = _cusum_parameters(m, μ, σ)
    a, b = inv(σ), μ / σ + k  # Iz - k = a I - b
    S = 0.0
    for i in (firstindex(I) + 1):lastindex(I)
        S = max(0.0, S + muladd(I[i], a, -b))
        warnings[i] = S > h
    end
    return warnings
end

function _cusum_parameters(m, μ, σ)
    k = @something m.k begin
        μ > 0 || throw(ArgumentError("the default CUSUM `k` needs a positive background mean, got μ = $μ; pass `k` or use `NSigma()`"))
        m.n / (log(μ + m.n * σ) - log(μ))
    end
    k = k > 1 ? round(k) : float(k)
    return k, @something(m.h, k <= 1 ? 1 : 2)
end

"""
    NSigma(; n = 2)

Warnings where intensity `I` exceeds the background mean plus `n` standard deviations.
"""
Base.@kwdef struct NSigma{N}
    n::N = 2
end

(m::NSigma)(bg, I) = I .> mean(bg) + m.n * std(bg)

"""
    find_onset([f = CUSUM()], x, (t0, t1); N = Minute(30), dim = nothing)
"""
function find_onset(f, x, bg; N = Minute(30), dim = nothing)
    d = TimeseriesUtilities.resolve_dim(x, dim)
    t = times(x, d)
    t0, t1 = _time.(bg)
    ibg = searchsortedfirst(t, t0):searchsortedlast(t, t1)
    isempty(ibg) && throw(ArgumentError("no samples in the background interval $(repr(bg))"))
    rest = (last(ibg) + 1):lastindex(t)
    length(rest) < 2 && throw(ArgumentError("onset search needs at least 2 samples after the background interval, got $(length(rest))"))
    t_rest = view(t, rest)
    N = _samples(N, t_rest)
    return tstat(unwrap(x); dim = d) do I
        b = filter(!isnan, view(I, ibg))
        valid = findall(!isnan, view(I, rest))
        time = length(valid) < 2 ? nothing : _onset_time(f(b, I[rest[valid]]), view(t_rest, valid), N)
        (; time, N, bg_mean = mean(b), bg_std = std(b))
    end
end

find_onset(x, bg; kw...) = find_onset(CUSUM(), x, bg; kw...)

# As SEPpy's `onset_determination`, the first sample only anchors the onset: runs start at the second.
function _onset_time(warnings, t, N)
    n = 0
    for i in (firstindex(warnings) + 1):lastindex(warnings)
        n = warnings[i] ? n + 1 : 0
        n == N && return t[i - N]
    end
    return nothing
end

_samples(N::Integer, t) = N
_samples(N::Period, t) = max(1, round(Int, N / cadence(t)))

_time(t::AbstractString) = DateTime(t)
_time(t) = t
