"""
    select_channel(data, indices)
    select_channel(data, predicate)

Select specific channels (columns) from data while preserving metadata structure, including labels. 

# Examples
```julia
# Select specific energy channels
I_low = select_channel(data.PH, 1:3)        # First 3 channels
I_mid = select_channel(data.PH, [4, 6, 8])  # Specific channels
I_high = select_channel(data.PH, 10:15)     # High energy range

# Select using predicates
I_odd = select_channel(data.PH, isodd)      # Odd-numbered channels
I_subset = select_channel(data.PH, x -> x > 5)  # Channels above 5

# Single channel for onset analysis
I_channel = select_channel(data.PH, 4)      # Channel 4 only
```
"""
function select_channel(A, idxs)
    B = selectdim(A, ndims(A), idxs)
    return @set B.metadata = _select_channel(A.metadata, idxs)
end

function select_channel(A, predicate::Function)
    col_indices = 1:size(A, 2)
    mask = predicate.(col_indices)
    return select_channel(A, mask)
end

_select_channel(metadata, idxs) = metadata

function _select_channel(metadata::AbstractDict, idxs)
    new_metadata = copy(metadata)
    "LABL_PTR_1" in keys(new_metadata) && begin
        new_metadata["LABL_PTR_1"] = new_metadata["LABL_PTR_1"][idxs]
    end
    "DEPEND_1" in keys(new_metadata) && begin
        ax1 = new_metadata["DEPEND_1"]
        _idxs = idxs isa Number ? [idxs] : idxs # avoid just selecting a single channel for metadata as it will be a scalar
        new_metadata["DEPEND_1"] = select_channel(ax1, _idxs)
    end
    return new_metadata
end

function sep_summary(data)
    for col in eachcol(data)
        if all(isnan, col)
            println("Column is all NaN")
        end
    end
    return
end
