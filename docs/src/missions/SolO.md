# Solar Orbiter (SolO)

Energetic Particle Detector (EPD) data through [CDAWeb.jl](https://github.com/JuliaSpacePhysics/CDAWeb.jl).

```@example solo
using CDAWeb
get_datasets("SOLO", "EPD", "EPT")
```

EPT electron fluxes in its four viewing directions:

```@example solo
tmin, tmax = "2020-12-10T23", "2020-12-11T12"
views = ("SUN", "ASUN", "NORTH", "SOUTH")
fluxes = [CDAWeb.Dataset("SOLO_L2_EPD-EPT-$(v)-RATES")["Electron_Flux"](tmin, tmax) for v in views]
first(fluxes)
```

```@example solo
using SpacePhysicsMakie, CairoMakie
using SpaceDataModel: DataVariable

# indexing a file variable gives a plain array; a `DataVariable` keeps times and coordinates
f = Figure()
for (i, x) in enumerate(fluxes)
    linesplot(f[i, 1], replace(DataVariable(x)[1:4:20, :], 0 => NaN))  # zeros cannot show on log axes
end
f
```

Channel 6 from every direction:

```@example solo
f = Figure()
ax = Axis(f[1, 1]; yscale = log10)
for (v, x) in zip(views, fluxes)
    linesplot!(ax, replace(DataVariable(x)[6, :], 0 => NaN); label = v)
end
axislegend(ax)
f
```
