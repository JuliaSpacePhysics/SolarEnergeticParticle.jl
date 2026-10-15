# Solar and Heliospheric Observatory (SOHO)

## Overview

Energetic particle data come from multiple instruments aboard the Solar and Heliospheric Observatory spacecraft.

### References

- SOHO Mission: [Solar and Heliospheric Observatory](https://soho.esac.esa.int/)
- Data Access: [CDAWeb](https://cdaweb.gsfc.nasa.gov/) through [CDAWeb.jl](https://github.com/JuliaSpacePhysics/CDAWeb.jl)

## Supported Instruments

### CELIAS (Charge, Element, and Isotope Analysis System)

- **SEM**: Solar Extreme-ultraviolet Monitor
- Energy range: 0.08-2.0 MeV (protons), 0.32-8.0 MeV/nucleon (He4), 0.64-16.0 MeV/nucleon (CNO)

### COSTEP-EPHIN (Comprehensive Suprathermal and Energetic Particle Analyzer)

- **EPHIN**: Electron Proton Helium Instrument
- Energy range: 4.3-53.0 MeV (protons), 4.3-53.0 MeV/nucleon (helium), 0.25-3.0 MeV (electrons)

### ERNE (Energetic and Relativistic Nuclei and Electron experiment)

- **LED**: Low Energy Detector (1.3-13.0 MeV)
- **HED**: High Energy Detector (13.0-100.0 MeV)

## Basic Usage

```@example soho
using CDAWeb
get_datasets("SOHO", "ERNE")
```

ERNE High Energy Detector helium and proton fluxes:

```@example soho
hed = cda"SOHO_ERNE-HED_L2-1MIN"
tmin, tmax = "2021-10-28T06", "2021-10-29T12"
AH, PH = hed["AH"](tmin, tmax), hed["PH"](tmin, tmax)
```

```@example soho
using SpacePhysicsMakie, CairoMakie
using SpaceDataModel: DataVariable

# indexing a file variable gives a plain array; a `DataVariable` keeps times and coordinates
f = Figure()
linesplot(f[1, 1], replace(DataVariable(AH)[1:3:end, :], 0 => NaN))  # zeros cannot show on log axes
linesplot(f[2, 1], replace(DataVariable(PH)[1:3:end, :], 0 => NaN))
f
```
