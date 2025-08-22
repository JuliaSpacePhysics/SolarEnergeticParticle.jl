using TimeseriesUtilities: times, resolution

targmax(I) = times(I)[argmax(I)]

"""
    find_peak(I)

Find the peak time and value of a time series `I`.
"""
function find_peak(I)
    peak_idx = argmax(I)
    return (; time = times(I)[peak_idx], value = I[peak_idx])
end

"""
    cusum_onset_detection(I, μ, σ; h = nothing, k = nothing, n = 2, N = nothing)
    cusum_onset_detection(I, times, μ, σ; kw...)

Detect onset time using Poisson-CUSUM (Cumulative Sum) algorithm, where ``I`` is the (intensity) time series, and ``μ`` and ``σ`` are the mean and standard deviation of the background, `k` is the control parameter.

The CUSUM function ``S`` for each timestamp for the standardized intensity ``I_z = \\frac{I-μ}{σ}`` was then calculated as follows: 

```math
S[i] = \\max(0, I_z[i] - k + S[i-1])
```

where ``S[0] = 0``. When ``S`` exceeded the hastiness threshold ``h``, a warning signal was given. After `N` consecutive warning signals, an event was found and the first timestamp of these consecutive warning signals is identified as the onset time. 

Note that:
- ``μ`` and ``σ`` are used to calculate the control parameter ``k = \\frac{n}{\\ln(μ + n σ) - \\ln(μ)}`` when `k` is not specified.
- ``n`` is a coefficient that was usually set to 2 and the control parameter ``k`` was rounded to the nearest integer value when ``k>1``. 
- The hastiness threshold ``h`` was set to 1 when ``k <= 1`` and ``h = 2`` otherwise (followed the practice introduced by Huttunen-Heikinmaa et al. 2005). 
- `N` are suggested to correspond to 30 minutes of threshold-exceeding intensity.
"""
function cusum_onset_detection(I, times, μ, σ; h = nothing, k = nothing, n = 2, N = nothing)
    # Calculate control parameter k
    k_raw = something(k, n / (log(μ + n * σ) - log(μ)))
    k = k_raw > 1 ? round(Int, k_raw) : k_raw
    # Set hastiness threshold h
    h = something(h, ifelse(k <= 1, 1, 2))
    N = @something N round(Int, Minute(30) / resolution(times))
    onset_idx = _cusum_onset_detection(I, μ, σ, k, h, N)

    time = isnothing(onset_idx) ? nothing : times[onset_idx]
    return (; time, k, h, N)
end

cusum_onset_detection(I, μ, σ; kw...) = cusum_onset_detection(I, times(I), μ, σ; kw...)

function _cusum_onset_detection(I, μ, σ, k, h, N)
    S = 0
    N_alert = 0
    for i in 2:length(I)
        I_z = (I[i] - μ) / σ
        S = max(0, I_z - k + S)
        N_alert = ifelse(S > h, N_alert + 1, 0)
        N_alert == N && return i - N
    end
    return nothing
end

"""
    sigma_onset_detection(I, μ, σ; n = 2, N = nothing)
    sigma_onset_detection(I, times, μ, σ; n = 2, N = nothing)

Detect onset time using n-sigma threshold method when intensity `I` exceeds `μ + n*σ` for `N` consecutive points.

# Returns
Named tuple with `time` and `N`.
"""
function sigma_onset_detection(I, times, μ, σ; n = 2, N = nothing)
    N = @something N round(Int, Minute(30) / resolution(times))
    onset_idx = _sigma_onset_detection(I, μ + n * σ, N)
    time = isnothing(onset_idx) ? nothing : times[onset_idx]
    return (; time, N)
end

sigma_onset_detection(I, μ, σ; kw...) = sigma_onset_detection(I, times(I), μ, σ; kw...)

function _sigma_onset_detection(I, I_threshold, N)
    N_alert = 0
    for i in 2:length(I)
        N_alert = ifelse(I[i] > I_threshold, N_alert + 1, 0)
        N_alert == N && return i - N
    end
    return nothing
end

"""
    find_onset(I, bg_timerange; method = :cusum, kwargs...)

Perform onset determination analysis on time series `I` using background statistics from `bg_timerange`.

# Arguments
- `method`: Detection method (`:cusum` or `:sigma`, default: `:cusum`)
- `kwargs...`: Additional parameters passed to the detection method

# Returns
Named tuple with `onset_time`, `bg_timerange`, `bg_mean`, and `bg_std`.

See also: [`cusum_onset_detection`](@ref), [`sigma_onset_detection`](@ref)
"""
function find_onset(I::AbstractVector, bg_timerange; method = :cusum, kwargs...)
    # Calculate background statistics
    bg_data = tview(I, bg_timerange)
    bg_mean = tmean(bg_data)
    bg_std = tstd(bg_data)

    # Detect onset using CUSUM
    I_rest = tview(I, bg_timerange[end], times(I)[end]) # performance boost (only check rest of the data)
    f = method == :cusum ? cusum_onset_detection : sigma_onset_detection
    bg_std == 0 && method == :cusum && @warn "Background standard deviation is zero, CUSUM onset detection is not applicable. Please use sigma onset detection instead"
    onset_time, = f(I_rest, bg_mean, bg_std; kwargs...)

    return (; onset_time, bg_timerange, bg_mean, bg_std)
end
