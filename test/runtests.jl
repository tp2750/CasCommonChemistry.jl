using CasCommonChemistry
using Test

@testset "CasCommonChemistry.jl" begin
    @test cas_search("water")["count"] == 1
    @test cas("water").rn == ["7732-18-5"]
end
