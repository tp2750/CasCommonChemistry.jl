using CasCommonChemistry
using Documenter

DocMeta.setdocmeta!(CasCommonChemistry, :DocTestSetup, :(using CasCommonChemistry); recursive=true)

makedocs(;
    modules=[CasCommonChemistry],
    authors="Thomas Poulsen",
    repo="https://github.com/tp2750/CasCommonChemistry.jl/blob/{commit}{path}#{line}",
    sitename="CasCommonChemistry.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://tp2750.github.io/CasCommonChemistry.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/tp2750/CasCommonChemistry.jl",
    devbranch="main",
)
