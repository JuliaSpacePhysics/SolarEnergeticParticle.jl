# STEREO (Solar TErrestrial RElations Observatory)

## Overview

The STEREO data loader provides access to energetic particle data from the twin STEREO-A (Ahead) and STEREO-B (Behind) spacecraft.

### References

- STEREO Mission: [Solar TErrestrial RElations Observatory](https://stereo.gsfc.nasa.gov/)
- Data Access: Via [CDAWeb](https://cdaweb.gsfc.nasa.gov/) through `Speasy.jl`

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

List available STEREO datasets:

```@example stereo
using SolarEnergeticParticle

stb_datasets = get_datasets(:STB)
```

Load STEREO data:

```@example stereo
# STEREO-A HET data
dataset = "STA_L1_HET"
tmin = "2021/10/28T06"
tmax = "2021/10/29T12"
data = get_data(dataset, "Electron_Flux", tmin, tmax);
```


```@example stereo
using SpacePhysicsMakie, CairoMakie

tvars2plot = replace!(data.Electron_Flux, 0 => eps())
f = tplot(tvars2plot; plottype=Stairs)
ylims!.(f.axes, 5e-2, 2e2)
f
```