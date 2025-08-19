"""
Interface to Speasy.jl for accessing space physics data from various data providers.
"""

function speasy_load(dataset, vars, t0, t1; provider = :cda)
    ids = map(x -> "$(provider)/$(dataset)/$(x)", vars)
    data = Speasy.get_data(NamedTuple, ids, t0, t1)
    return map(DimArray, data)
end