using Vaja08
using Test
using LinearAlgebra

@testset "Inverzna iteracija" begin
  Q = [2 2 1; 1 -2 2; -2 1 2]
  A = Q * diagm([2.0, 3.0, 4.0]) / Q
  F = factorize(A)
  v, lambda = inviter(b -> F\b, [1, 1, 1])
  @test isapprox(lambda, 2)
  cosinus = dot(v, Q[:,1])/norm(v)/norm(Q[:,1])
  @test isapprox(abs(cosinus), 1)
end
