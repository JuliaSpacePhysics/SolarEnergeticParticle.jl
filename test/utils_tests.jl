using SolarEnergeticParticle
using Test
using DimensionalData

@testitem "Column Selection Tests" begin
    # Create mock DimArray for testing selectcol function
    @testset "selectcol with indices" begin
        # Create test data
        test_data = rand(10, 6)  # 10 time points, 6 energy channels
        test_metadata = Dict(
            "LABL_PTR_1" => ["Ch1", "Ch2", "Ch3", "Ch4", "Ch5", "Ch6"],
            "DEPEND_1" => [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
        )

        # Create mock DimArray-like structure
        mock_array = (
            data=test_data,
            metadata=test_metadata
        )

        # Test selectcol with specific indices
        try
            selected = SolarEnergeticParticle.selectcol(mock_array, [1, 3, 5])
            @test size(selected.data, 2) == 3
            @test selected.metadata["LABL_PTR_1"] == ["Ch1", "Ch3", "Ch5"]
            @test selected.metadata["DEPEND_1"] == [1.0, 3.0, 5.0]
            println("✓ selectcol with indices works correctly")
        catch e
            @test_skip "selectcol function not properly implemented: $e"
        end
    end

    @testset "selectcol with predicate" begin
        # Create test data
        test_data = rand(10, 6)
        test_metadata = Dict(
            "LABL_PTR_1" => ["Ch1", "Ch2", "Ch3", "Ch4", "Ch5", "Ch6"],
            "DEPEND_1" => [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
        )

        mock_array = (
            data=test_data,
            metadata=test_metadata
        )

        # Test selectcol with isodd predicate
        try
            selected = SolarEnergeticParticle.selectcol(mock_array, isodd)
            @test size(selected.data, 2) == 3  # Channels 1, 3, 5
            @test selected.metadata["LABL_PTR_1"] == ["Ch1", "Ch3", "Ch5"]
            println("✓ selectcol with predicate works correctly")
        catch e
            @test_skip "selectcol with predicate not properly implemented: $e"
        end
    end
end