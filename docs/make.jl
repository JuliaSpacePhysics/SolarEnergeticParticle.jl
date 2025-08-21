using SolarEnergeticParticle
using Documenter

makedocs(;
    modules=[SolarEnergeticParticle],
    sitename="SolarEnergeticParticle.jl",
    format=Documenter.HTML(;
        canonical="https://JuliaSpacePhysics.github.io/SolarEnergeticParticle.jl",
    ),
    pages=[
        "Home" => "index.md",
        "Solar Orbiter" => "SolO.md",
        "Parker Solar Probe" => "PSP.md",
        "Solar and Heliospheric Observatory" => "SOHO.md",
        "Solar TErrestrial RElations Observatory" => "STEREO.md",
        "Wind" => "Wind.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaSpacePhysics/SolarEnergeticParticle.jl",
    push_preview = true
)
