using Test, Vaja16

@testset "Hermitova baza" begin
  @test Vaja16.h00.([0, 1]) ≈ [1, 0]
  @test Vaja16.h01.([0, 1]) ≈ [0, 1]
  @test Vaja16.h10.([0, 1]) ≈ [0, 0]
  @test Vaja16.h11.([0, 1]) ≈ [0, 0]

end
@testset "Hermitov zlepek" begin
  @test Vaja16.hermiteint(2, [0, 1], [0, 1], [0, 3]) ≈ 8
  # p(x) = x^3; p'(x) = 3x^2 
  @test Vaja16.hermiteint(2, [1, 3], [1, 27], [3, 27]) ≈ 8
end


@testset "Vrednost" begin
  f(t) = [t^3, t^2]
  df(t) = [3t.^2, 2t]
  t = [0., 1., 2.]
  zp = ZacetniProblem((t, x, p) -> df(t), [0.0, 0], [0.0, 2.0], nothing)
  res = ResitevNDE(zp, f.(t), t)
  @test res(0.) ≈ f(0)
  @test res(1.) ≈ f(1)
  @test res(2.) ≈ f(2)
end
