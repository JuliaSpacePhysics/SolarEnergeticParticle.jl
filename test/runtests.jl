using SolarEnergeticParticle
using TestItemRunner
using Test

@run_package_tests

@testitem "General Checks" begin
    using Aqua
    Aqua.test_all(SolarEnergeticParticle)
end

@testitem "Data Loading" begin
    tmin = "2021/10/09T00"
    tmax = "2021/10/09T01"

    @testset "PSP Data Loading" begin
        @test !isempty(get_data("PSP_ISOIS-EPIHI_L2-HET-RATES60", tmin, tmax))
        @test_broken !isempty(get_data("PSP_ISOIS-EPILO_L2-PE", tmin, tmax))
    end

    # Wind 3DP
    @test !isempty(get_data("WI_SFSP_3DP", tmin, tmax))
    # STEREO-A HET
    @test !isempty(get_data("STA_L1_HET", tmin, tmax))
    # Solar Orbiter EPD-EPT
    @test !isempty(get_data("SOLO_L2_EPD-EPT-NORTH-RATES", tmin, tmax))
    

    for mission in (:PSP, :SOHO, :WI, :STB, :STA, :SOLO)
        @test length(get_datasets(mission)) > 0
    end
end

@testitem "SOHO Data Loading" begin
    tmin = "2021/10/28T06"
    tmax = "2021/10/28T07"

    @test !isempty(get_data("SOHO_ERNE-HED_L2-1MIN", tmin, tmax))
    @test !isempty(get_data("SOHO_COSTEP-EPHIN_L3I-1MIN", tmin, tmax))
    @test !isempty(get_data("SOHO_ERNE-LED_L2-1MIN", tmin, tmax))
    @test !isempty(get_data("SOHO_CELIAS-PM_5MIN", tmin, tmax))
end