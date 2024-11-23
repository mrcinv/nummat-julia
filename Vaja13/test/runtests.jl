using Vaja13
using Test


# preslikava
@testset "Preslikava" begin
  x = [-1, 0, 1]
  t = [preslikaj(xi, Interval(-1, 1), Interval(4, 8)) for xi in x]
  @test t ≈ [4, 6, 8]
end

@testset "Preslikava kvadrature" begin
  kvad = Kvadratura([1.0, 2.0, 3.0], [1.0, 2.0, 3.0], Interval(0.0, 4.0))
  kvad2 = preslikaj(kvad, Interval(-3.0, -1.0))
  @test kvad2.x ≈ [-2.5, -2, -1.5]
  @test kvad2.u ≈ [0.5, 1.0, 1.5]
  @test kvad2.int.min ≈ -3
  @test kvad2.int.max ≈ -1
end
# preslikava

# kvadratura
@testset "Kvadratura" begin
  # Simpsonova kvadratura
  kvad = Kvadratura([0.0, 1.0, 2.0], [1, 4, 1] * (1 / 3), Interval(0.0, 2.0))
  # Simpsonovo pravilo je točno za polinome stopnje 2
  @test integriraj(x -> x^2, kvad) ≈ 8 / 3
end

# kvadratura

# trapezna
@testset "Trapezna metoda" begin
  kvad = trapezna(Interval(1.0, 3.0), 4)
  @test kvad.x ≈ [1, 1.5, 2, 2.5, 3]
end
# trapezna
@testset "Čebiševe točke" begin
  x = Vaja13.cebiseve_tocke(5)
  @test minimum(x) > -1
  @test maximum(x) < 1
  @test sum(x) ≈ 0
  x = Vaja13.cebiseve_tocke(3, Interval(2.0, 3.0))
  @test sum(x) / 3 ≈ 2.5
  @test maximum(x) < 3
  @test minimum(x) > 2
end

@testset "Čebiševa vrsta" begin
  T = CebisevaVrsta([4.0, 3.0, 2.0, 1.0])
  T(0.5) ≈ 4 + 3cos(0.5) + 2cos(2 * 0.5) + cos(3 * 0.5)
  T(0.1) ≈ 4 + 3cos(0.1) + 2cos(2 * 0.1) + cos(3 * 0.1)
  T(1) ≈ 4 + 3cos(1) + 2cos(2) + cos(3)
end

@testset "Approksimiraj" begin
  T = aproksimiraj(CebisevaVrsta, x -> 4x^3 - 3x, Interval(-1.0, 1.0), 4)
  @test T.koef ≈ [0, 0, 0, 1, 0]
  T = aproksimiraj(CebisevaVrsta,
    x -> 4(2x - 1)^3 - 3(2x - 1), Interval(0.0, 1.0), 4)
  @test T.koef ≈ [0, 0, 0, 1, 0]
  T = aproksimiraj(CebisevaVrsta, sin, Interval(0.0, 2pi), 10)
  t = range(0, 2pi, 7)
  @test isapprox(T.(t), sin.(t); atol=1e-3)
end