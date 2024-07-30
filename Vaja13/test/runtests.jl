using Vaja13
using Test


@testset "Preslikava" begin
  x = [-1, 0, 1]
  t = [Vaja13.preslikaj((-1, 1), (4, 8), xi) for xi in x]
  @test t ≈ [4, 6, 8]
end

@testset "Čebiševe točke" begin
  x = Vaja13.cebiseve_tocke(5)
  @test minimum(x) > -1
  @test maximum(x) < 1
  @test sum(x) ≈ 0
  x = Vaja13.cebiseve_tocke(3, (2, 3))
  @test sum(x) / 3 ≈ 2.5
  @test maximum(x) < 3
  @test minimum(x) > 2
end

@testset "Čebiševa vrsta" begin
  T = CebisevaVrsta([4, 3, 2, 1])
  T(0.5) ≈ 4 + 3cos(0.5) + 2cos(2 * 0.5) + cos(3 * 0.5)
  T(0.1) ≈ 4 + 3cos(0.1) + 2cos(2 * 0.1) + cos(3 * 0.1)
  T(1) ≈ 4 + 3cos(1) + 2cos(2) + cos(3)
end

@testset "Approksimiraj" begin
  T = aproksimiraj(x -> 4x^3 - 3x, (-1, 1), 4)
  @test T.koef ≈ [0, 0, 0, 1, 0]
  T = aproksimiraj(x -> 4(2x - 1)^3 - 3(2x - 1), (0, 1), 4)
  @test T.koef ≈ [0, 0, 0, 1, 0]
  T = aproksimiraj(sin, (0, 2pi), 10)
  t = range(0, 2pi, 7)
  @test isapprox(T.(t), sin.(t); atol=1e-3)
end