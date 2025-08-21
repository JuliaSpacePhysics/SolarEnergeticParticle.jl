# SOHO (Solar and Heliospheric Observatory)

## Overview

The SOHO data loader provides access to energetic particle data from multiple instruments aboard the Solar and Heliospheric Observatory spacecraft.

### References

- SOHO Mission: [Solar and Heliospheric Observatory](https://soho.esac.esa.int/)
- Data Access: Via [CDAWeb](https://cdaweb.gsfc.nasa.gov/) through `Speasy.jl`

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

List available SOHO datasets:

```@example soho
using SolarEnergeticParticle
using SolarEnergeticParticle: selectcol

datasets = get_datasets(:SOHO)
```

Load SOHO data:

```@example soho
# ERNE High Energy Detector data
dataset = "SOHO_ERNE-HED_L2-1MIN"
tmin = "2021/10/28T06"
tmax = "2021/10/29T12"
data = get_data(dataset, tmin, tmax; verbose=true)
```

## Advanced Usage

```@example soho
using SpacePhysicsMakie, CairoMakie

begin
    tvars2plot = map([data.AH, data.PH]) do x
        replace!(selectcol(x, 1:3:10), 0 => eps())
    end
    f = tplot(tvars2plot; plottype=Stairs)
    ylims!.(f.axes, 5e-5, 8e-1)
    f
end
```