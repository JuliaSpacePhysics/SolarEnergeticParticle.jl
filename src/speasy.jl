"""
Interface to Speasy.jl for accessing space physics data from various data providers.
"""

function dimarrayify(x)
    "DEPEND_1" in keys(x.metadata) && begin
        x.metadata["DEPEND_1"] = DimArray(x.metadata["DEPEND_1"])
    end
    return DimArray(x)
end

function speasy_load(dataset, vars, t0, t1; provider = :cda, kw...)
    vars = vars isa Union{String, Symbol} ? [vars] : vars
    ids = map(x -> "$(provider)/$(dataset)/$(x)", vars)
    data = Speasy.get_data(NamedTuple, ids, t0, t1; kw...)
    return map(dimarrayify, data)
end
