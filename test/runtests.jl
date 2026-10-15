using TestItemRunner

@run_package_tests

@testitem "Aqua" begin
    using Aqua
    Aqua.test_all(SolarEnergeticParticle)
end

@testsnippet Steps begin
    using Dates
    using TimeseriesUtilities: Timed
    t = DateTime(2021) .+ Minute.(0:99)
    # background 10 ± 1, rising to 30 from sample `i`
    steps(i) = [j < i ? 10.0 + (-1)^j : 30.0 for j in eachindex(t)]
    step(i) = Timed(steps(i), t)
    bg = (t[1], t[40])
end

@testitem "find_onset" setup = [Steps] begin
    # the onset is the sample before the first of N warnings
    @test find_onset(step(61), bg; N = 3).time == t[60]
    @test find_onset(NSigma(), step(61), bg; N = 3).time == t[60]
    @test find_onset(step(61), bg; N = Minute(3)).time == t[60]
    @test find_onset((b, I) -> I .> 20, step(61), bg; N = 3).time == t[60]
    @test find_onset(step(61), ("2021-01-01T00:00", "2021-01-01T00:39"); N = 3).time == t[60]
    # NaN samples are gaps: skipped within the run, and never the onset
    I = steps(61); I[[60, 62]] .= NaN
    @test find_onset(Timed(I, t), bg; N = 3).time == t[59]
    @test find_onset(NSigma(), Timed(I, t), bg; N = 3).time == t[59]
    @test isnothing(find_onset(step(200), bg; N = 3).time)

    x = Timed(permutedims([steps(61) steps(71)]), t; dim = 2)
    @test [o.time for o in find_onset(x, bg; N = 3)] == [t[60], t[70]]
    # zero background deviation gives no CUSUM threshold: no onset for that channel, unlike an unusable interval
    @test isnothing(find_onset(Timed(fill(1.0, 100), t), bg).time)
    @test_throws ArgumentError find_onset(Timed(steps(61) .- 10, t), bg)
    @test find_onset(CUSUM(k = 3), Timed(steps(61) .- 10, t), bg; N = 3).time == t[60]
    @test_throws ArgumentError find_onset(step(61), (t[1] - Day(1), t[1] - Hour(1)))
    @test_throws ArgumentError find_onset(step(61), (t[1], t[end - 1]))
end

@testitem "CUSUM parameters" setup = [Steps] begin
    using SolarEnergeticParticle: _cusum_parameters
    @test _cusum_parameters(CUSUM(), 10.0, 1.0) === (11.0, 2)  # k = 2 / ln(1.2), rounded
    k, h = _cusum_parameters(CUSUM(), 1.0, 10.0)
    @test k ≈ 2 / log(21) && h == 1
    @test find_onset(step(61), bg).N == 30  # 30 one-minute samples
end

@testitem "vda" begin
    using Dates
    using SolarEnergeticParticle: AU, C, MASS, beta
    using SpaceDataModel: DataVariable
    t0, L = DateTime(2021, 10, 28, 15, 10), 1.2
    E = [10.0, 20.0, 40.0, 80.0]
    arrival(E; mass = MASS.proton) = t0 + Millisecond(round(Int, 1000 * L * AU / (C * beta(E, mass))))
    r = vda([arrival.(E); nothing], [E; 160.0])
    @test_throws DimensionMismatch vda(arrival.(E), [E; 160.0])
    @test abs(r.release_time - t0) < Second(1)
    @test r.path_length ≈ L rtol = 1.0e-4
    @test r.energies == E && r.r2 ≈ 1
    @test r.release_time_error < 1
    e = vda(arrival.(E[1:2] ./ 100; mass = MASS.electron), E[1:2] ./ 100; particle = :electron)
    @test isapprox(e.path_length, L; rtol = 1.0e-3) && isnan(e.path_length_error)

    # from time series: onsets per channel, energies from the channel coordinate in keV
    t = t0 .+ Minute.(-60:300)
    flux = permutedims(reduce(hcat, [[ti <= arrival(e) ? 1.0 + 0.1 * (-1)^i : 100.0 for (i, ti) in enumerate(t)] for e in E]))
    energies = DataVariable(1000 .* E; metadata = Dict("CATDESC" => "proton energy", "UNITS" => "keV"))
    x = DataVariable(flux; time = 2 => t, dims = (1 => energies,))
    r = vda(x, (t[1], t[50]); N = 3)
    @test r.energies ≈ E
    @test r.onsets == [t[findlast(<=(arrival(e)), t)] for e in E]
    @test_throws ArgumentError vda(DataVariable(flux; time = 2 => t, dims = (1 => 1:4,)), (t[1], t[50]))
end
