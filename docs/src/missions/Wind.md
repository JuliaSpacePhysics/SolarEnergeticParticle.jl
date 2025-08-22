# Wind

## Overview

The Wind data loader provides access to energetic particle data from the 3DP (3-Dimensional Plasma and Energetic Particle Investigation) instrument aboard the Wind spacecraft.

### References

- Wind Mission: [Wind Spacecraft](https://wind.nasa.gov/)
- 3DP Instrument: [3-Dimensional Plasma and Energetic Particle Investigation](https://wind.nasa.gov/3dp.php)
- Data Access: Via [CDAWeb](https://cdaweb.gsfc.nasa.gov/) through `Speasy.jl`

## Supported Instruments

### 3DP (3-Dimensional Plasma and Energetic Particle Investigation)

#### Electron Datasets

- **SFSP**: Suprathermal electron omnidirectional fluxes (27-520 keV)
- **SFPD**: Suprathermal electron energy-angle distributions (27-520 keV)
- **ELSP**: Low energy electron omnidirectional (7-300 keV)
- **ELPD**: Low energy electron energy-angle (7-300 keV)
- **EHSP**: High energy electron omnidirectional (100-3200 keV)
- **EHPD**: High energy electron energy-angle (100-3200 keV)

#### Proton Datasets

- **SOSP**: Suprathermal proton omnidirectional fluxes (70 keV - 6.8 MeV)
- **SOPD**: Suprathermal proton energy-angle distributions (70 keV - 6.8 MeV)
- **PLSP**: Low energy proton omnidirectional (30 keV - 2 MeV)
- **PLPD**: Low energy proton energy-angle (30 keV - 2 MeV)
- **PHSP**: High energy proton omnidirectional (1-30 MeV)
- **PHPD**: High energy proton energy-angle (1-30 MeV)

## Basic Usage

List available Wind datasets:

```@example wind
using SolarEnergeticParticle

datasets = get_datasets(:WI, "3DP")
```

Load Wind 3DP data:

```@example wind
# Suprathermal electron data
dataset = "WI_SFSP_3DP"
tmin = "2021/10/28T06"
tmax = "2021/10/29T12"
data = get_data(dataset, tmin, tmax; verbose=true)
```

```@example wind
using SpacePhysicsMakie, CairoMakie

tvars2plot = replace!(data.FLUX, 0 => eps())
f = tplot(tvars2plot; plottype=Stairs)
ylims!.(f.axes, 5e-6, 8e-2)
f
```
