@testitem "Column Selection Tests" begin
    # Create mock DimArray for testing select_channel function
    using DimensionalData

    # Create test data
    ch_ergs_1 = rand(Y(1:6))
    ch_ergs_2 = rand(Ti(1:10), Y(1:6))

    for channel_energies in (ch_ergs_1, ch_ergs_2), idxs in ([1, 3, 5], isodd)

        metadata = Dict(
            "LABL_PTR_1" => ["Ch1", "Ch2", "Ch3", "Ch4", "Ch5", "Ch6"],
            "DEPEND_1" => channel_energies
        )
        data = rand(Ti(1:10), Y(1:6); metadata)

        # Test select_channel with specific indices
        selected = @test_nowarn select_channel(data, idxs)
        @test size(selected.data, 2) == 3
        @test selected.metadata["LABL_PTR_1"] == ["Ch1", "Ch3", "Ch5"]
        selected_ch_ergs = selected.metadata["DEPEND_1"]
        @test size(selected_ch_ergs, dimnum(selected_ch_ergs, Y)) == 3
        @test selected_ch_ergs == channel_energies[Y([1, 3, 5])]
    end
end
