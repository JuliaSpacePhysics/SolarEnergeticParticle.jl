# Onset Analysis

```@example onset
using SolarEnergeticParticle
using CDAWeb, Dates, TimeseriesUtilities
using SpaceDataModel: DataVariable
using SpacePhysicsMakie, CairoMakie
```

Proton fluxes of [SOHO](missions/SOHO.md) ERNE-HED in the 28 October 2021 event, with a background interval before it:

```@example onset
tmin, tmax = DateTime(2021, 10, 28), DateTime(2021, 10, 29)
bg = (DateTime(2021, 10, 28, 10), DateTime(2021, 10, 28, 12))

PH = cda"SOHO_ERNE-HED_L2-1MIN/PH"(tmin, tmax)
tplot(PH)
```

## Onset and peak

[`find_onset`](@ref) computes the background mean and standard deviation over `bg` and searches for the onset after it; TimeseriesUtilities' `targmax` gives the peak time.

```@example onset
I = DataVariable(PH)[4, :]  # channel 4; indexing a file variable gives a plain array
onset = find_onset(I, bg)
```

```@example onset
peak = targmax(I)
```

The n-sigma method:

```@example onset
find_onset(NSigma(), I, bg)
```

Every channel at once:

```@example onset
[o.time for o in find_onset(PH, bg)]
```

## Visualization

```@example onset
f = Figure()
ax = Axis(f[1, 1]; yscale = log10)
linesplot!(ax, I)
tvspan!(ax, bg...; color = (:gray, 0.2), label = "Background")
hlines!(ax, onset.bg_mean; linestyle = :dash, color = :cyan, label = "Background mean")
hlines!(ax, onset.bg_mean + 2onset.bg_std; linestyle = :dot, color = :cyan, label = "Mean + 2σ")
tlines!(ax, DateTime(onset.time); color = :red, label = "Onset $(round(DateTime(onset.time), Second))")
tlines!(ax, DateTime(peak); color = :orange, label = "Peak $(round(DateTime(peak), Second))")
ylims!(ax, 1e-4, 5e-1)
axislegend(ax; position = :lt)
f
```

## References

- [onset_determination.ipynb - serpentine](https://github.com/serpentine-h2020/serpentine/blob/main/notebooks/sep_analysis_tools/onset_determination.ipynb)
- Palmroos, C., Gieseler, J., Dresing N., et al. (2022). Solar energetic particle time series analysis with Python. _Front. Astronomy Space Sci._ 9. [doi:10.3389/fspas.2022.1073578](https://doi.org/10.3389/fspas.2022.1073578)
