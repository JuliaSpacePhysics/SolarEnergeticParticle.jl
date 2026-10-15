```@meta
CurrentModule = SolarEnergeticParticle
```

```@docs
SolarEnergeticParticle
```

## Tutorials

- [Onset Analysis](onset.md): CUSUM and n-sigma onset determination
- [Velocity Dispersion Analysis (VDA)](vda.md): particle release times and path lengths

## Missions

Any CDAWeb dataset loads with [CDAWeb.jl](https://github.com/JuliaSpacePhysics/CDAWeb.jl); these pages show SEP instruments of

- [Parker Solar Probe (PSP)](missions/PSP.md)
- [Solar Orbiter (SolO)](missions/SolO.md)
- [SOHO](missions/SOHO.md)
- [STEREO](missions/STEREO.md)
- [Wind](missions/Wind.md)

## API Reference

```@docs
find_onset
vda
CUSUM
NSigma
```
