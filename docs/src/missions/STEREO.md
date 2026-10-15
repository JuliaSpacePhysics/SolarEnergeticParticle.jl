# Solar TErrestrial RElations Observatory (STEREO)

## Overview

Energetic particle data come from the twin STEREO-A (Ahead) and STEREO-B (Behind) spacecraft.

### References

- STEREO Mission: [Solar TErrestrial RElations Observatory](https://stereo.gsfc.nasa.gov/)
- Data Access: [CDAWeb](https://cdaweb.gsfc.nasa.gov/) through [CDAWeb.jl](https://github.com/JuliaSpacePhysics/CDAWeb.jl)

## Supported Instruments

### HET (High Energy Telescope)
- Energy range: 13.6-100 MeV/nucleon
- Species: Protons, Helium, and heavier ions

### LET (Low Energy Telescope)
- Energy range: 1.8-12 MeV/nucleon
- Species: Protons, He4, He3, and heavier ions

### SEPT (Solar Electron and Proton Telescope)
- Electron energy range: 45-425 keV
- Proton energy range: 84-6500 keV
- Multiple viewing directions

## Basic Usage

```@example stereo
using CDAWeb
get_datasets("STEREO", "HET")
```

STEREO-A HET electron fluxes:

```@example stereo
e = cda"STA_L1_HET/Electron_Flux"("2021-10-28T06", "2021-10-29T12")
```

```@example stereo
using SpacePhysicsMakie, CairoMakie

tplot(e)
```
