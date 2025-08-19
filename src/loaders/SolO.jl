"""
Solar Orbiter (SOLO) data loader.

Supports instruments:
- EPD: Energetic Particle Detector
"""

"""
    solo_load(dataset, [vars], t0, t1)
    solo_load(dataset, t0, t1)

Load Solar Orbiter solar energetic particle data from `t0` to `t1`.
"""
function solo_load(dataset, vars, t0, t1; kw...)
    speasy_load(dataset, vars, t0, t1; kw...)
end

function solo_load(dataset, t0, t1; verbose = false)
    params = Speasy.list_parameters(:cda, dataset)
    verbose && @info "Found $(length(params)) parameters for $dataset: $(params)"
    DATASET_VARS = Dict()
    default_params = get(DATASET_VARS, dataset, params)
    verbose && @info "Using default parameters $default_params for $dataset"
    return solo_load(dataset, default_params, t0, t1)
end

function _get_solo_energy_channels(instrument::String)
end

function _get_solo_units(instrument::String)
    return Dict(
        "datetime" => "UTC",
        "flux" => "1/(cm^2 s sr MeV)",
        "counts" => "counts/s"
    )
end