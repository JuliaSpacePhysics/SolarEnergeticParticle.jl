module SolarEnergeticParticle
using Accessors: @reset
using Speasy
using Dates
using DimensionalData: DimArray

export get_data

include("types.jl")
include("utils.jl")
include("speasy_interface.jl") 
include("loaders/PSP.jl")
include("loaders/SolO.jl")

get_mission(dataset) = first(eachsplit(dataset, "_"))

spec2stack!(x::AbstractMatrix) = x.metadata["DISPLAY_TYPE"] = "stack_plot"

function get_data(dataset, args...; kw...)
    mission = get_mission(dataset)
    data = if mission == "PSP"
        psp_load(dataset, args...; kw...)
    elseif mission == "SOLO"
        solo_load(dataset, args...; kw...)
    else
        throw(ArgumentError("Unknown mission: $mission"))
    end
    foreach(spec2stack!, data)
    return data
end

function get_datasets(mission, args...; kw...)
    if mission in (:PSP, :SOLO)
        Speasy.list_datasets(:cda, mission, args...; kw...)
    else
        throw(ArgumentError("Unknown mission: $mission"))
    end
end

end