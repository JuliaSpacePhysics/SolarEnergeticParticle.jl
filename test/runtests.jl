using SolarEnergeticParticle
using TestItemRunner
using Test

@run_package_tests

@testitem "General Checks" begin
    using Aqua
    Aqua.test_all(SolarEnergeticParticle)
end