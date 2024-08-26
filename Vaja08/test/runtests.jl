using Vaja08
using Test
using LinearAlgebra

# inviter
@testset "Inverzna iteracija" begin
  Q = [2 2 1; 1 -2 2; -2 1 2]
  A = Q * diagm([2.0, 3.0, 4.0]) / Q
  F = factorize(A)
  v, lambda = inviter(b -> F \ b, [1, 1, 1])
  @test isapprox(lambda, 2)
  cosinus = dot(v, Q[:, 1]) / norm(v) / norm(Q[:, 1])
  @test isapprox(abs(cosinus), 1)
end
# inviter

# inviterqr
@testset "Inverzna iteracija QR" begin
  Q = [2 2 1; 1 -2 2; -2 1 2]
  A = Q * diagm([2.0, 3.0, 4.0]) / Q
  F = factorize(A)
  v, lambda = inviterqr(b -> F \ b, [1 1; 1 1; 1 1])
  @test isapprox(lambda, [2, 3])
  cosinus = dot(v[:, 1], Q[:, 1]) / norm(v[:, 1]) / norm(Q[:, 1])
  @test isapprox(abs(cosinus), 1)
end
# inviterqr

# graf eps
@testset "Graf sosednosti" begin
  oblak = [1 2 3; 1 2 3]
  A = graf_eps(oblak, 2)
  @test isapprox(A, [0 1 0; 1 0 1; 0 1 0])
end
# graf eps

