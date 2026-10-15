# Wind

## Overview

Energetic particle data come from the 3DP (3-Dimensional Plasma and Energetic Particle Investigation) instrument aboard the Wind spacecraft.

### References

- Wind Mission: [Wind Spacecraft](https://wind.nasa.gov/)
- 3DP Instrument: [3-Dimensional Plasma and Energetic Particle Investigation](https://wind.nasa.gov/3dp.php)
- Data Access: [CDAWeb](https://cdaweb.gsfc.nasa.gov/) through [CDAWeb.jl](https://github.com/JuliaSpacePhysics/CDAWeb.jl)

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

```@example wind
using CDAWeb
get_datasets("WI", "3DP")
```

Wind 3DP files lack the ISTP time attributes, so `direct = true` fetches them through CDAWeb's subsetting service:

```@example wind
sfsp = CDAWeb.Dataset("WI_SFSP_3DP"; direct = true)
flux = sfsp["FLUX"]("2021-10-28T06", "2021-10-29T12")
```

```@example wind
using SpacePhysicsMakie, CairoMakie

tplot(flux)
```
