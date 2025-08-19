"""
    DatasetInfo

Structure containing metadata about a loaded dataset.

# Fields
- `energy_channels::Dict{String, Vector{Float64}}`: Energy channel information
- `units::Dict{String, String}`: Units for each data column
- `instrument::String`: Instrument name
- `spacecraft::String`: Spacecraft name
- `data_level::String`: Data processing level (e.g., "L2")
- `time_resolution::String`: Temporal resolution of the data
"""
struct DatasetInfo
    energy_channels::Dict{String, Vector{Float64}}
    units::Dict{String, String}
    instrument::String
    spacecraft::String
    data_level::String
    time_resolution::String
end