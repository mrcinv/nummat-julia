using Vaja12
using Test

# hermiteint
@testset "Hermitov polinom" begin
  # kubični polinom se bo vedno ujemal s Hermitovim polinomom
  p3(x) = x^3 - x
  dp3(x) = 3x^2 - 1
  xint = [0, 2]
  h(x) = hermiteint(x, xint, p3.(xint), dp3.(xint))
  @test isapprox(p3(0), h(0))
  @test isapprox(p3(0.5), h(0.5))
  @test isapprox(p3(1.5), h(1.5))
end
# hermiteint
# zlepek
@testset "Hermitov zlepek" begin
  p3(x) = x^3 - 2x^2 + 1
  dp3(x) = 3x^2 - 4x
  x = [-1, 0.5, 3.5, 4]
  z = HermitovZlepek(x, p3.(x), dp3.(x))
  @test_throws BoundsError z(-2)
  for xi in x
    @test isapprox(z(xi), p3(xi))
  end
  @test isapprox(z(-0.2), p3(-0.2))
  @test isapprox(z(1.1), p3(1.1))
  @test isapprox(z(3.7), p3(3.7))
  @test_throws BoundsError z(5.1)
end
# zlepek
