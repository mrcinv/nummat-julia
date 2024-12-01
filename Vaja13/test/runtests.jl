using Vaja13
using Test

# Trapez
@testset "Sestavljeno trapezno pravilo" begin
  i = Integral(x -> 2x + 1, Interval(1.0, 3.0))
  @test integriraj(i, Trapez(4)) ≈ 10
end
# Trapez

# simpson
@testset "Sestavljeno Simpsonovo pravilo" begin
  # Simpsonva metoda je točna za polinome 3. stopnje
  integral = Integral(x -> x^3 + x^2, Interval(-1.0, 3.0))
  # nedoločeni integral je x^4/4 + x^3/3
  I(x) = x^4 / 4 + x^3 / 3
  @test integriraj(integral, Simpson(3)) ≈ I(3) - I(-1)
end
# simpson

# kvadratura
@testset "Splošna kvadratura" begin
  # Gauss-Legendreova kvadratura na dveh točkah
  k = Kvadratura(1 / sqrt(3) * [-1, 1], [1.0, 1.0], Interval(-1.0, 1.0))
  # formula je točna za kubične polinome
  integral = Integral(x -> x^3 - x^2, Interval(-1.0, 3.0))
  I(x) = x^4 / 4 - x^3 / 3
  @test integriraj(integral, k) ≈ I(3) - I(-1)
end
# kvadratura

# gl
@testset "Gauss-Legendreove kvadrature" begin
  k = glkvad(3)
  @test length(k.x) == 3
  # formula je točna za polinome do vključno stopnje 5
  for n=1:5
    integral = Integral(x -> x^n, Interval(0., 1.))
    @test integriraj(integral, k) ≈ 1/(n+1)
  end
end
# gl

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
