using Vaja14
using Vaja13
using Test

# naslednji
@testset "Naslednji indeks" begin
  index = [1, 1, 1]
  Vaja14.naslednji!(index, 3)
  @test index == [2, 1, 1]
  index = [3, 1, 1]
  Vaja14.naslednji!(index, 3)
  @test index == [1, 2, 1]
  index = [3, 3, 3]
  Vaja14.naslednji!(index, 3)
  @test index == [1, 1, 1]
end
# naslednji

# simpson
@testset "Simpsonovo sestavljeno pravilo" begin
  k = Vaja14.simpson(1.0, 3.0, 2)
  @test (k.interval.min, k.interval.max) == (1.0, 3.0)
  @test k.x == [1.0, 1.5, 2.0, 2.5, 3.0]
  @test isapprox(k.u, [1, 4, 2, 4, 1] * 1 / 6)
end
# simpson

# preslikaj
@testset "Preslikaj kvadraturo" begin
  k = Kvadratura([1.0, 2.0, 3.0], [1.0, 2.0, 1.0], Interval(0.0, 4.0))
  k1 = Vaja14.preslikaj(k, Interval(-1.0, 1.0))
  @test k1.x ≈ [-0.5, 0, 0.5]
  @test k1.u ≈ [0.5, 1, 0.5]
end
# preslikaj

# integriraj
@testset "Integriraj večkratni integral" begin
  kvad = Kvadratura([0.0, 1.0], [0.5, 0.5], Interval(0.0, 1.0)) # trapezna
  int = VeckratniIntegral{Float64,Float64}(x -> x[1] - x[2],
    [Interval(0.0, 2.0), Interval(-1.0, 2.0)])
  @test integriraj(int, kvad) ≈ 3.0
end
# integriraj
