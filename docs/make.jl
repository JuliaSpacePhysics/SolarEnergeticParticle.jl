using SolarEnergeticParticle
using Documenter

list_pages(dir) = map(f -> "$dir/$f", readdir(joinpath(@__DIR__, "src", dir)))

makedocs(;
    modules = [SolarEnergeticParticle],
    sitename = "SolarEnergeticParticle.jl",
    format = Documenter.HTML(;
        canonical = "https://JuliaSpacePhysics.github.io/SolarEnergeticParticle.jl",
    ),
    pages = [
        "Home" => "index.md",
        "Missions" => list_pages("missions"),
        "Onset Analysis" => "onset_analysis.md",
    ],
)

deploydocs(;
    repo = "github.com/JuliaSpacePhysics/SolarEnergeticParticle.jl",
    push_preview = true
)
