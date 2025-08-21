module SolarEnergeticParticle
using Accessors: @reset
using Speasy
using Dates
using DimensionalData: DimArray

export get_data, get_datasets

include("types.jl")
include("utils.jl")
include("speasy_interface.jl")

get_mission(dataset) = first(eachsplit(dataset, "_"))

spec2stack!(x::AbstractMatrix) = x.metadata["DISPLAY_TYPE"] = "stack_plot"

function get_data(dataset, vars, t0, t1; kw...)
    mission = get_mission(dataset)
    speasy = mission in ("WI", "STA", "STB") ? (; method="API") : (;)
    data = speasy_load(dataset, vars, t0, t1; speasy..., kw...)
    foreach(spec2stack!, data)
    return data
end

function get_data(dataset, t0, t1; verbose=false, kw...)
    vars = get_dataset_default_vars(dataset; verbose)
    return get_data(dataset, vars, t0, t1; kw...)
end

function get_datasets(mission, args...; kw...)
    Speasy.list_datasets(:cda, mission, args...; kw...)
end

function get_dataset_default_vars(dataset; verbose=false)
    params = Speasy.list_parameters(:cda, dataset)
    verbose && @info "Found $(length(params)) parameters for $dataset: $(params)"
    DATASET_VARS = Dict(
        "PSP_ISOIS-EPIHI_L2-HET-RATES60" => ["A_H_Flux", "B_H_Flux", "A_Electrons_Rate", "B_Electrons_Rate", "Quality_Flag"],
    )
    default_params = get(DATASET_VARS, dataset, params)
    verbose && @info "Using default parameters $default_params for $dataset"
    return default_params
end

end