# Velocity Dispersion Analysis (VDA)

Velocity Dispersion Analysis is a technique for determining solar particle release times and propagation characteristics by analyzing the energy-dependent arrival times of solar energetic particles (SEPs).

## Physical Principle

## Setup

```@example vda
using SolarEnergeticParticle
using Dates
using SpacePhysicsMakie, CairoMakie
using TimeseriesUtilities
```

## Load Multi-Energy SEP Data

First, let's load SEP data:

```@example vda
# Load SOHO ERNE data for VDA analysis
tmin = DateTime(2021, 10, 28, 14)
tmax = DateTime(2021, 10, 29)
background_range = (DateTime(2021, 10, 28, 14), DateTime(2021, 10, 28, 15))

data = get_data("SOLO_L2_EPD-HET-SUN-RATES", tmin, tmax)
```

```@example vda
Electron_Flux = tmean(data.Electron_Flux, Minute(3))
H_Flux = tmean(data.H_Flux, Minute(3))
faxs = tplot([Electron_Flux, select_channel(H_Flux, 1:4:36)])
ylims!(faxs.axes[1], 5e-2, 2e3)
ylims!(faxs.axes[2], 1e-2, 1e2)
faxs
```

## Multi-Channel Onset Detection

Detect onsets across multiple energy channels using sigma onset detection:

```@example vda
vda_proton = vda(tmean(data.H_Flux, Minute(5)), background_range; onset = (N=3, method=:sigma))

println("VDA Results:")
println("Release time: $(vda_proton.release_time)")
println("Path length: $(round(vda_proton.path_length_au, digits=2)) AU")
```

## VDA Visualization

```@example vda
function plot_vda_analysis!(ax, vda_result)
    onsets = vda_result.onset_times
    energies = vda_result.energies

    release_time = vda_result.release_time

    # Plot data points
    scatter!(ax, vda_result.inverse_betas, onsets; label="Observed Onsets")

    # Plot linear fit
    fit_times = [unix2datetime(vda_result.intercept + vda_result.slope * inv_beta)
                 for inv_beta in vda_result.inverse_betas]
    lines!(ax, vda_result.inverse_betas, fit_times; linewidth=3, label="Linear Fit (Path Length: $(round(vda_result.path_length_au, digits=2)) AU)")
    # Add release time line
    hlines!(ax, Dates.value(release_time), linestyle=:dash, label="Release Time $release_time")
end

function plot_vda_analysis_error_bands!(ax, vda_result)
    upper_fit = [unix2datetime(vda_result.intercept + 2*vda_result.intercept_error +
                              vda_result.slope * inv_beta) for inv_beta in vda_result.inverse_betas]
    lower_fit = [unix2datetime(vda_result.intercept - 2*vda_result.intercept_error +
                              vda_result.slope * inv_beta) for inv_beta in vda_result.inverse_betas]
    band!(ax, vda_result.inverse_betas, lower_fit, upper_fit, color=(:red, 0.2), label="95% Confidence")
end

# Create the VDA plot
fig = Figure(size=(800, 600))
ax = Axis(fig[1, 1],
            xlabel="Inverse Beta (β⁻¹)",
            ylabel="Onset Time",
            title="SOHO ERNE SEP Event - October 28, 2021")
plot_vda_analysis!(ax, vda_proton)

fig
```

### Different Particle Species

```@example vda
vda_electron = vda(tmean(data.Electron_Flux, Minute(1)), background_range; onset = (N=10, ), particle = :electron)

println("Electron VDA:")
println("Release time: $(vda_electron.release_time)")
println("Path length: $(round(vda_electron.path_length_au, digits=2)) AU")

plot_vda_analysis!(ax, vda_electron)
axislegend(; position=:lt)

fig
```
