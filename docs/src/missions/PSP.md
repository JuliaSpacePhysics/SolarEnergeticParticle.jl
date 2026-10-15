# Parker Solar Probe (PSP)

## Overview

Energetic particle data come from the **Integrated Science Investigation of the Sun (ISOIS)** instrument suite aboard the Parker Solar Probe spacecraft.

### References

- PSP Mission: [Parker Solar Probe](https://parkersolarprobe.jhuapl.edu/)
- ISOIS Instrument: [Integrated Science Investigation of the Sun](https://sprg.ssl.berkeley.edu/~jiangwei/isois/)
- Data Access: [CDAWeb](https://cdaweb.gsfc.nasa.gov/) through [CDAWeb.jl](https://github.com/JuliaSpacePhysics/CDAWeb.jl)

## Basic Usage

List PSP ISOIS datasets:

```@example psp
using CDAWeb
get_datasets("PSP", "ISOIS")
```

Load EPI-Hi HET proton fluxes and electron rates of the A side:

```@example psp
het = cda"PSP_ISOIS-EPIHI_L2-HET-RATES60"
tmin, tmax = "2021-10-09", "2021-10-10"
H = het["A_H_Flux"](tmin, tmax)
e = het["A_Electrons_Rate"](tmin, tmax)
```

Channel energies and labels ride on the channel dimension:

```@example psp
getdim(H, 1)
```

## Time Series

```@example psp
using SpacePhysicsMakie, CairoMakie
tplot([e, H])
```

Every other channel, averaged over 10 minutes:

```@example psp
using TimeseriesUtilities, Dates
using SpaceDataModel: DataVariable

# indexing a file variable gives a plain array; a `DataVariable` keeps times and coordinates
# zeros cannot show on log axes
f = Figure()
linesplot(f[1, 1], replace(tmean(DataVariable(e)[1:2:end, :], Minute(10)), 0 => NaN))
linesplot(f[2, 1], replace(tmean(DataVariable(H)[1:2:end, :], Minute(10)), 0 => NaN))
f
```
