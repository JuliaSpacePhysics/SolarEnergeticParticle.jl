# Parker Solar Probe (PSP)

## Overview

The PSP data loader provides access to energetic particle data from the **Integrated Science Investigation of the Sun (ISOIS)** instrument suite aboard the Parker Solar Probe spacecraft.

### References

- PSP Mission: [Parker Solar Probe](https://parkersolarprobe.jhuapl.edu/)
- ISOIS Instrument: [Integrated Science Investigation of the Sun](https://sprg.ssl.berkeley.edu/~jiangwei/isois/)
- Data Access: Via [CDAWeb](https://cdaweb.gsfc.nasa.gov/) through `Speasy.jl`

## Basic Usage

List available datasets for PSP ISOIS

```julia
using SolarEnergeticParticle: get_data, get_datasets

datasets = get_datasets(:PSP, :ISOIS)
```

Get EPIHI data for a solar particle event

```julia
dataset = "PSP_ISOIS-EPIHI_L2-HET-RATES60"
tmin = "2021/10/9"
tmax = "2021/10/10"
data = get_data(dataset, tmin, tmax; verbose=true)

# Or only get specific variables
data = get_data(dataset, ("A_H_Flux", "B_H_Flux"), tmin, tmax)
```

```julia
# Print energy channel information
foreach(println, data.A_H_Flux.metadata["LABL_PTR_1"])
```

## Advanced Usage

### Time Series Analysis

Here we plot the proton fluxes and electron rates of A side every 2 channels averaged over 10 minutes.

```julia
using SpacePhysicsMakie, CairoMakie
using TimeseriesUtilities, Dates
using SolarEnergeticParticle: selectcol

begin
    tvars2plot = map([data.A_Electrons_Rate, data.A_H_Flux]) do x
        replace!(tmean(selectcol(x, isodd), Minute(10)), 0 => eps())
    end
    f = tplot(tvars2plot; plottype=Stairs)
    ylims!(f.axes[1], 1e-3, 1e0)
    ylims!(f.axes[2], 1e-3, 1e1)
    f
end
```

## Example: Solar Particle Event Analysis

```julia
using SolarEnergeticParticle, CairoMakie, Statistics

function analyze_sep_event(start_date, end_date)
    # Load PSP EPIHI data
    result = psp_load("PSP_ISOIS-EPIHI_L2-HET-RATES60", 
                      start_date, end_date)
    
    # Calculate background levels (first 20% of data)
    n_background = div(nrow(result.data), 5)
    background_flux = mean(skipmissing(result.data.flux_channel_1[1:n_background]))
    
    # Find enhancement periods (flux > 3x background)
    enhanced = result.data.flux_channel_1 .> 3 * background_flux
    
    # Create figure
    fig = Figure(resolution = (1000, 700))
    ax = Axis(fig[1, 1],
              xlabel = "Time (UTC)",
              ylabel = "Proton Flux (1/cm²/s/sr/MeV)",
              title = "PSP Solar Particle Event Analysis",
              yscale = log10)
    
    # Plot main data
    lines!(ax, result.data.datetime, result.data.flux_channel_1,
           label = "0.5-1.0 MeV protons", linewidth = 2, color = :blue)
    
    # Add background lines
    hlines!(ax, [background_flux], label = "Background", 
            linestyle = :dash, color = :gray, linewidth = 2)
    hlines!(ax, [3*background_flux], label = "3x Background", 
            linestyle = :dot, color = :red, linewidth = 2)
    
    # Highlight enhancement periods
    enhanced_times = result.data.datetime[enhanced]
    if !isempty(enhanced_times)
        scatter!(ax, enhanced_times, result.data.flux_channel_1[enhanced],
                label = "Enhanced periods", markersize = 8, 
                color = (:red, 0.7))
    end
    
    axislegend(ax, position = :rt)
    fig
end

# Analyze April 2021 event
fig = analyze_sep_event("2021/04/28", "2021/05/02")
display(fig)
```

## Notes

- **Units**: Particle flux in units of 1/(cm²⋅s⋅sr⋅MeV)