module SolarEnergeticParticle

@doc let path = joinpath(dirname(@__DIR__), "README.md")
    include_dependency(path)
    read(path, String)
end SolarEnergeticParticle

using Dates
using LinearAlgebra: diag
using Statistics: mean, std
import TimeseriesUtilities
using TimeseriesUtilities: cadence, times, tstat, unwrap
using SpaceDataModel: getdim, units

export find_onset, vda, CUSUM, NSigma

include("onset.jl")
include("vda.jl")

end
