# SolarEnergeticParticle.jl

[![Documentation](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaSpacePhysics.github.io/SolarEnergeticParticle.jl/dev/)

[![Build Status](https://github.com/JuliaSpacePhysics/SolarEnergeticParticle.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaSpacePhysics/SolarEnergeticParticle.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JuliaSpacePhysics/SolarEnergeticParticle.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaSpacePhysics/SolarEnergeticParticle.jl)

A Julia package for loading and analyzing Solar Energetic Particle (SEP) data from multiple space missions.

## Supported Missions and Instruments

### Parker Solar Probe (PSP)

- **ISOIS**: Integrated Science Investigation of the Sun

### Solar Orbiter

- **EPD**: Energetic Particle Detector

### SOHO (Solar and Heliospheric Observatory)

- **CELIAS**: Charge, Element, and Isotope Analysis System
- **COSTEP-EPHIN**: Comprehensive Suprathermal and Energetic Particle Analyzer
- **ERNE**: Energetic and Relativistic Nuclei and Electron experiment

### STEREO (Solar TErrestrial RElations Observatory)

- **HET**: High Energy Telescope
- **LET**: Low Energy Telescope
- **SEPT**: Solar Electron and Proton Telescope

### Wind

- **3DP**: 3-Dimensional Plasma and Energetic Particle Investigation

## Installation

```julia
using Pkg
Pkg.add("SolarEnergeticParticle")
```

## Quick Start

```julia
using SolarEnergeticParticle

# Load PSP ISOIS data
dataset = "PSP_ISOIS-EPIHI_L2-HET-RATES60"
tmin = "2021/10/9"
tmax = "2021/10/10"
data = get_data(dataset, tmin, tmax; verbose=true)

# Load SOHO ERNE data
soho_data = get_data("SOHO_ERNE-HED_L2-1MIN", "2021/04/16", "2021/04/20")

# Load STEREO-A HET data
stereo_data = get_data("STA_L1_HET", "2021/04/16", "2021/04/20")

# Load Wind 3DP data
wind_data = get_data("WI_SFSP_3DP", "2021/04/16", "2021/04/20")
```

## Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

## Elsewhere

- [SEPpy](https://github.com/serpentine-h2020/SEPpy)
- [SERPENTINE](https://github.com/serpentine-h2020/serpentine)
