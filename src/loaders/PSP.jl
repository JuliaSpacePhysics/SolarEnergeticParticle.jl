"""
Parker Solar Probe (PSP) data loader.

Supports instruments:
- ISOIS: Integrated Science Investigation of the Sun
"""

"""
    psp_load(dataset, [vars], t0, t1)
    psp_load(dataset, t0, t1)

Load Parker Solar Probe solar energetic particle data from `t0` to `t1`.
"""
function psp_load(dataset, vars, t0, t1; kw...)
    speasy_load(dataset, vars, t0, t1; kw...)
end

function psp_load(dataset, t0, t1; verbose = false)
    params = Speasy.list_parameters(:cda, dataset)
    verbose && @info "Found $(length(params)) parameters for $dataset: $(params)"
    DATASET_VARS = Dict(
        "PSP_ISOIS-EPIHI_L2-HET-RATES60" => ["A_H_Flux", "B_H_Flux", "A_Electrons_Rate", "B_Electrons_Rate", "Quality_Flag"],
        # "PSP_ISOIS-EPILO_L2-PE" => ["Epoch", "EPILO-PE"]
    )
    default_params = get(DATASET_VARS, dataset, params)
    verbose && @info "Using default parameters $default_params for $dataset"
    return psp_load(dataset, default_params, t0, t1)
end

function _get_energy_channels(instrument)
end

function _get_psp_units(instrument::String)
    return Dict(
        "datetime" => "UTC",
        # Default units for particle flux measurements
        "flux" => "1/(cm^2 s sr MeV)",
        "counts" => "counts/s"
    )
end