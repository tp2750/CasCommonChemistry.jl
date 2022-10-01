# CasCommonChemistry.jl

<!---
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://tp2750.github.io/CasCommonChemistry.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://tp2750.github.io/CasCommonChemistry.jl/dev/)
-->
[![Build Status](https://github.com/tp2750/CasCommonChemistry.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/tp2750/CasCommonChemistry.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/tp2750/CasCommonChemistry.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/tp2750/CasCommonChemistry.jl)

This package provides an interface the the [CAS Common Chemistry](https://commonchemistry.cas.org/) registry of chemical compounds.

# Installation

This package is currently not registered, so it needs to be installed from this repo:

```
using Pkg
pkg"add https://github.com/tpapp/MarkdownTables.jl"
```

# Usage

The main exported function is called `cas`. 
It takes a query string and returns a dataframe of matching records.

A wild-card query can return quite a lot of records, so by default only the first 10 are fetched.
The fetch more (or less), use the `fetch` keyword argument. Setting `fetch = :all` fetches all results. 
Use with care.

The number of found records are printed, so in an interactive session it is each to set fetch to a reasonable value.
To get the number of matched records programmatically, the `cas_search` function is exported.
This returns a Dict, where the value of the key "count" gives the number of found records.


```julia
julia> using CasCommonChemistry

julia> cas("water")
# [ Info: Found 1 results from query 'water'. Fetching 1..1
# 1×15 DataFrame
#  Row │ hasMolfile  rn         name    inchi              replacedRns                        smile   experimentalProperties             ⋯
#      │ Bool        String     String  String             Vector{Any}                        String  Vector{Any}                        ⋯
# ─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
#    1 │       true  7732-18-5  Water   InChI=1S/H2O/h1H2  Any["558440-22-5", "558440-53-2"…  O       Any[Dict{String, Any}("name"=>"B…  ⋯

julia> cas("water*")
# [ Info: Found 94 results from query 'water*'. Fetching 1..10
# 10×15 DataFrame
#  Row │ hasMolfile  rn           name                               inchi                              replacedRns                      ⋯
#      │ Bool        String       String                             String                             Vector{Any}                      ⋯
# ─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
#    1 │       true  118175-19-2  Calcium, [ethanedioato(2-)-κ<em>…  InChI=1S/C2H2O4.Ca.H2O/c3-1(4)2(…  Any[]                            ⋯
#    2 │       true  129-17-9     Acid Blue 1                        InChI=1S/C27H32N2O6S2.Na/c1-5-28…  Any["64366-33-2", "66554-69-6",
#    3 │      false  1330-39-8    Cuprate(3-), [29<em>H</em>,31<em…                                     Any["208667-82-7"]
#    4 │      false  1344-09-8    Sodium silicate                                                       Any["8031-41-2", "11105-00-3", "
#    5 │       true  13670-17-2   Tritiated water                    InChI=1S/H2O/h1H2/i/hT             Any[]                            ⋯
#    6 │       true  139322-38-6  Water, hexamer                     InChI=1S/H2O/h1H2                  Any[]
#    7 │       true  139322-39-7  Water, octamer                     InChI=1S/H2O/h1H2                  Any[]
#    8 │       true  142473-50-5  Water-<em>d</em><sub>2</sub>, tr…  InChI=1S/H2O/h1H2/i/hD2            Any[]
#    9 │       true  142473-62-9  Water, decamer                     InChI=1S/H2O/h1H2                  Any[]                            ⋯
#   10 │       true  142473-63-0  Water, pentadecamer                InChI=1S/H2O/h1H2                  Any[]

julia> cas("water*", fetch = 3)
# [ Info: Found 94 results from query 'water*'. Fetching 1..3
# 3×15 DataFrame
#  Row │ hasMolfile  rn           name                               inchi                              replacedRns                      ⋯
#      │ Bool        String       String                             String                             Vector{Any}                      ⋯
# ─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
#    1 │       true  118175-19-2  Calcium, [ethanedioato(2-)-κ<em>…  InChI=1S/C2H2O4.Ca.H2O/c3-1(4)2(…  Any[]                            ⋯
#    2 │       true  129-17-9     Acid Blue 1                        InChI=1S/C27H32N2O6S2.Na/c1-5-28…  Any["64366-33-2", "66554-69-6",
#    3 │      false  1330-39-8    Cuprate(3-), [29<em>H</em>,31<em…                                     Any["208667-82-7"]

                                              
julia> cas_search("water*")
# Dict{String, Any} with 2 entries:
#   "count"   => 94
#   "results" => Any[Dict{String, Any}("rn"=>"118175-19-2", "name"=>"Calcium, [ethanedioato(2-)-κ<em>O</em><sup>1</sup>,κ<em>O</em><sup>2…
```

# API

This package uses the Cas Common Chemistry API, which is described here: https://commonchemistry.cas.org/api-overview

