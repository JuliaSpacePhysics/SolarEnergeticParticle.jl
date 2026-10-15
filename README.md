# SolarEnergeticParticle.jl

Solar Energetic Particle (SEP) event analysis: onset determination and velocity dispersion analysis.

## Quick Start

Work on any time series (see [TimeseriesUtilities](https://github.com/JuliaSpacePhysics/TimeseriesUtilities.jl)'s data model), e.g. data from [CDAWeb.jl](https://github.com/JuliaSpacePhysics/CDAWeb.jl) for most SEP instruments:

```julia
using Pkg; Pkg.add("SolarEnergeticParticle")
using SolarEnergeticParticle, CDAWeb, Dates

PH = cda"SOHO_ERNE-HED_L2-1MIN/PH"("2021-10-28T06", "2021-10-29")  # proton flux, channels × time
bg = (DateTime("2021-10-28T10"), DateTime("2021-10-28T12"))         # background interval

find_onset(view(PH, 4, :), bg)         # (; time, N, bg_mean, bg_std) of channel 4
find_onset(NSigma(n = 3), PH, bg)      # one per channel
r = vda(PH, bg)                        # release time and path length from the channel onsets
r.release_time, r.path_length
```

## API

- `find_onset([f = CUSUM()], x, (t0, t1); N = Minute(30), dim)`: onset of each channel of `x` after `t1`, judged against the background `[t0, t1]`: the sample before the first `N` consecutive warnings. `N` is a sample count or a duration (`Minute(30)` is 30 samples at 1-minute cadence). Returns `(; time, N, bg_mean, bg_std)` for a vector, else an array of them; `time` is `nothing` without onset. Throws if `[t0, t1]` has no samples or fewer than 2 follow it.
  - `f(bg, I)` returns which samples of `I` warn (a `Bool` vector), given the background samples `bg`. NaN samples are excluded from both; they neither extend nor break a run. A warning on the first sample of `I` is ignored.
  - `CUSUM(; n = 2, k, h)`: Poisson-CUSUM. No onset (`time = nothing`) when the background has no spread (e.g. all-zero counts; `NSigma` still works there) or fewer than 2 samples.
  - `NSigma(; n = 2)`: samples above `μ + n σ` of the background.
- `vda(onsets, energies; particle = :proton, mass)`: velocity dispersion analysis, fitting `t = t₀ + (s/c) β⁻¹` to onset times at kinetic energies in MeV; `mass` (MeV/c²) overrides `particle` (`:proton`, `:electron`). `nothing` onsets are skipped.
- `vda([f = CUSUM()], x, (t0, t1); energies, dim, particle, mass, N)`: from the channel onsets `find_onset(f, x, (t0, t1); dim, N)` of `x`. `energies` defaults to the channel coordinate, converted to MeV from its `UNITS` (eV, keV, MeV, GeV).
  - Returns `(; release_time, path_length, release_time_error, path_length_error, r2, onsets, energies, inverse_betas, slope, intercept)`: path length in AU, standard errors (`NaN` with two onsets), the release time error in seconds.

## References

- Palmroos, C., Gieseler, J., Dresing, N., et al. (2022). Solar energetic particle time series analysis with Python. _Front. Astron. Space Sci._ 9. [doi:10.3389/fspas.2022.1073578](https://doi.org/10.3389/fspas.2022.1073578)
- Huttunen-Heikinmaa, K., Valtonen, E., & Laitinen, T. (2005). Proton and helium release times in SEP events observed with SOHO/ERNE. _A&A_ 442, 673. [doi:10.1051/0004-6361:20042620](https://doi.org/10.1051/0004-6361:20042620)

## Elsewhere

- [SEPpy](https://github.com/serpentine-h2020/SEPpy), [SERPENTINE](https://github.com/serpentine-h2020/serpentine) (Python)
- [VDA](https://github.com/spearhead-he/VDA) (Python)
