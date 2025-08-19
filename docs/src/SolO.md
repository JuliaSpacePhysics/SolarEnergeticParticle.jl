# Solar Orbiter (SolO)

```@example solo
using SolarEnergeticParticle: get_data, get_datasets, selectcol

get_datasets(:SOLO, :EPD, :EPT)
```

```@example solo
dataset = "SOLO_L2_EPD-EPT-SUN-RATES"
tmin = "20201210T23"
tmax = "20201211T12"
data_sun = get_data(dataset, tmin, tmax; verbose=true)
```


```@example solo
using SpacePhysicsMakie, CairoMakie

data_asun = get_data("SOLO_L2_EPD-EPT-ASUN-RATES", tmin, tmax)
data_north = get_data("SOLO_L2_EPD-EPT-NORTH-RATES", tmin, tmax)
data_south = get_data("SOLO_L2_EPD-EPT-SOUTH-RATES", tmin, tmax)

begin
    tvars2plot = map([data_sun.Electron_Flux, data_asun.Electron_Flux, data_north.Electron_Flux, data_south.Electron_Flux]) do x
        replace!(selectcol(x, 1:4:20), 0 => eps())
    end
    f = tplot(tvars2plot; plottype=Stairs)
    ylims!.(f.axes, 5e1, 5e5)
    f
end
```

Plot the 6th energy channel of electron flux for different views

```@example solo
using SpacePhysicsMakie, CairoMakie

begin
    tvars2plot = map([data_sun.Electron_Flux, data_asun.Electron_Flux, data_north.Electron_Flux, data_south.Electron_Flux]) do x
        replace!(selectcol(x, 6), 0 => eps())
    end
    for i in 1:4
        tvars2plot[i].metadata[:labels] = ["Sun", "Anti-Sun", "North", "South"][i]
    end
    f = tplot((tvars2plot,))
    ylims!(5e1, 5e5)
    f
end
```


