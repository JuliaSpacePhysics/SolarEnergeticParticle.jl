"""
    selectcol(A, idxs)
    selectcol(A, predicate)

Select columns from array `A` using indices `idxs` or a predicate function.

# Examples
```julia
selectcol(data, [2, 4])
selectcol(data, isodd)
```
"""
function selectcol(A, idxs)
    selected_data = @view A.data[:, idxs]

    # Update metadata keys that reference column indices
    new_metadata = copy(A.metadata)
    "LABL_PTR_1" in keys(new_metadata) && begin
        new_metadata["LABL_PTR_1"] = new_metadata["LABL_PTR_1"][idxs]
    end
    "DEPEND_1" in keys(new_metadata) && begin\
        ax1 = new_metadata["DEPEND_1"]
        "LABL_PTR_1" in keys(ax1.metadata) && begin
            ax1_metadata = copy(ax1.metadata)
            ax1_metadata["LABL_PTR_1"] = ax1_metadata["LABL_PTR_1"][idxs]
            @reset ax1.metadata = ax1_metadata
        end
        new_metadata["DEPEND_1"] = ax1[idxs]
    end
    @reset A.data = selected_data
    @reset A.metadata = new_metadata
    return A
end

selectcol(A, idx::Integer) = selectcol(A, [idx])

function selectcol(A, predicate::Function)
    col_indices = 1:size(A, 2)
    mask = predicate.(col_indices)
    return selectcol(A, mask)
end

function sep_summary(data)
    for col in eachcol(data)
        if all(isnan, col)
            println("Column is all NaN")
        end
    end
end