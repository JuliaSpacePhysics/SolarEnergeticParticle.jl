```@meta
CurrentModule = SolarEnergeticParticle
```

# SolarEnergeticParticle

A Julia package for loading and analyzing Solar Energetic Particle (SEP) data from multiple space missions.

## Tutorials

- [Onset Analysis](onset.md) - CUSUM-based onset detection
- [Velocity Dispersion Analysis (VDA)](vda.md) - Determine particle release times and path lengths

## Mission support

In theory, any dataset available in CDAWeb is supported. The following missions are tested and verified.

- [Parker Solar Probe (PSP)](missions/PSP.md)
- [SOHO](missions/SOHO.md) 
- [STEREO](missions/STEREO.md)
- [Wind](missions/Wind.md)

```@index
```

## API Reference

```@autodocs
Modules = [SolarEnergeticParticle]
```