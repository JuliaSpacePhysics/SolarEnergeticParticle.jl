using SolarEnergeticParticle
using Documenter

DocMeta.setdocmeta!(SolarEnergeticParticle, :DocTestSetup, :(using SolarEnergeticParticle); recursive=true)

makedocs(;
    modules=[SolarEnergeticParticle],
    authors="Beforerr <zzj956959688@gmail.com> and contributors",
    sitename="SolarEnergeticParticle.jl",
    format=Documenter.HTML(;
        canonical="https://Beforerr.github.io/SolarEnergeticParticle.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Beforerr/SolarEnergeticParticle.jl",
    devbranch="main",
)
