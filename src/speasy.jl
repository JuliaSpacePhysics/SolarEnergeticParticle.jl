"""
Interface to Speasy.jl for accessing space physics data from various data providers.
"""

# Speasy keeps DEPEND_1 as the axis variable name; downstream code (`vda`, `select_channel`) expects the axis values.
function dimarrayify(x)
    if length(x.dims) >= 2 && x.dims[2] isa Speasy.VariableAxis
        ax = parent(x.dims[2]) * Unitful.unit(x.dims[2])
        axdims = ndims(ax) == 1 ? (DimensionalData.Y(),) : (DimensionalData.Ti(), DimensionalData.Y())
        x.metadata["DEPEND_1"] = DimArray(ax, axdims)
    end
    return DimArray(x)
end
dimarrayify(::Nothing) = nothing

function speasy_load(dataset, vars, t0, t1; provider = :cda, kw...)
    vars = vars isa Union{String, Symbol} ? [vars] : vars
    ids = map(x -> "$(provider)/$(dataset)/$(x)", vars)
    data = Speasy.get_data(NamedTuple, ids, t0, t1; kw...)
    return map(dimarrayify, data)
end
