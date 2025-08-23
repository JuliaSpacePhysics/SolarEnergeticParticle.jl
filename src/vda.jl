using Statistics
using Unitful
using Unitful: c, mp, me
using Unitful: Energy

const AU = 1.495978707e11u"m"

beta(E, m) = sqrt(1 - (1 / (1 + E / (m * c^2)))^2)

particle_mass(p) = if p == :proton
    mp
elseif p == :electron
    me
end

"""
    vda(times, energies::AbstractArray{<:Energy}; particle = :proton, mass = nothing)
    vda(fluxes, background_timerange; onset = (;), kw...)

Perform Velocity Dispersion Analysis (VDA) to determine solar particle release time ``t₀`` and path length ``s`` using onset `times` across different `energies`.

# Principle

VDA is based on the fact that solar energetic particles of different energies travel at different speeds from the Sun to the observer. Higher energy particles arrive earlier than lower energy particles if they are released simultaneously from the source.

The relationship between onset time ``t`` and inverse velocity ``β⁻¹`` follows:

```math
t = t₀ + \\frac{s}{c} · β⁻¹
```

where: ``t`` is the observed onset time, ``β = v/c = \\sqrt{1 - (\\frac{1}{1 + E/mc^2})^2}``.

Linear regression of onset times versus β⁻¹ yields the release time (intercept) and path length (slope × c).

# Arguments
- `onsets`: Onset times for different energy channels
- `energies`: Particle energies (MeV) corresponding to onset times
- `min_points=2`: Minimum number of onset points required for analysis  

# Returns
A named tuple with:
- `release_time`: Estimated particle release time at source
- `path_length_au`: Path length in AU  

See also: [`find_onset`](@ref)
"""
function vda(times, energies::AbstractArray{<:Energy}; particle = :proton, mass = nothing)
    # Remove invalid onset times
    valid_mask = @. !ismissing(times) && !isnothing(times)
    valid_onsets = times[valid_mask]
    valid_energies = energies[valid_mask]

    n_points = length(valid_onsets)
    n_points < 2 && error("Need at least 2 valid onset points")

    # Physical constants
    mass = @something mass particle_mass(particle)
    inverse_betas = 1 ./ beta.(valid_energies, mass)

    # Convert onset times to timestamps (seconds since epoch)
    timestamps = datetime2unix.(valid_onsets)

    # Linear regression: t = t₀ + (s/c) * β⁻¹
    # where t₀ is release time, s/c is slope related to path length
    # Use statistical linear regression with error estimation
    X = [ones(n_points) inverse_betas]  # Design matrix [1, β⁻¹]
    intercept, slope = X \ timestamps

    # Physical interpretation
    release_time = unix2datetime(intercept)
    path_length_au = NoUnits(slope * u"s" * c / AU)   # Path length in AU

    return (;
        release_time, path_length_au,
        energies = valid_energies, inverse_betas,
        onset_times = valid_onsets, slope, intercept,
    )
end


function vda_stat(inverse_betas, times, slope, intercept)
    n_points = length(inverse_betas)
    X = [ones(n_points) inverse_betas]
    # Calculate residuals and covariance matrix
    timestamps = datetime2unix.(times)
    y_pred = X * [intercept, slope]
    residuals = timestamps - y_pred
    mse = sum(residuals .^ 2) / (n_points - 2)  # Mean squared error
    cov_matrix = mse * inv(X' * X)            # Covariance matrix
    intercept_error = sqrt(cov_matrix[1, 1])
    slope_error = sqrt(cov_matrix[2, 2])

    # Calculate goodness of fit (R²)
    y_mean = mean(timestamps)
    ss_tot = sum((timestamps .- y_mean) .^ 2)      # Total sum of squares
    ss_res = sum((timestamps .- (intercept .+ slope .* inverse_betas)) .^ 2)  # Residual sum
    r_squared = 1 - ss_res / ss_tot
    return (;
        r_squared,
        slope_error,
        intercept_error,
    )
end

vda_stat(result) = vda_stat(values(result)[4:end]...)

function vda(fluxes, background_range; onset = (;), kw...)
    energies = parent(fluxes.metadata["DEPEND_1"])
    N = size(fluxes, 2)
    times = map(1:N) do channel
        F = select_channel(fluxes, channel)
        find_onset(F, background_range; onset...)[1]
    end
    return vda(times, energies; kw...)
end
