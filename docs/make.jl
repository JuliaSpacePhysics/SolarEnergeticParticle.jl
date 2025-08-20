using SolarEnergeticParticle
using Documenter

DocMeta.setdocmeta!(SolarEnergeticParticle, :DocTestSetup, :(using SolarEnergeticParticle); recursive=true)

makedocs(;
    modules=[SolarEnergeticParticle],
    sitename="SolarEnergeticParticle.jl",
    format=Documenter.HTML(;
        canonical="https://Beforerr.github.io/SolarEnergeticParticle.jl",
        edit_link="main",
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Beforerr/SolarEnergeticParticle.jl",
    push_preview = true
)
