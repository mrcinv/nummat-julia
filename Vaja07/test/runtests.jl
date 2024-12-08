using Vaja07
using Test
using LinearAlgebra

@testset "Potenčna" begin
  A = [0.5 0.5 0; 0.25 0.25 0.5; 0.1 0.8 0.1]
  x0 = [1, 1, 1]
  x, it = potenčna(A, x0)
  @test x ≈ x0 / norm(x0, Inf)
  @test it == 1
  x0 = [1, 2, 1]
  x, it = potenčna(A, x0)
  @test x / x[1] ≈ [1, 1, 1]
  @test it > 10
end

@testset "Indeks (i, j) -> k" begin
  @test Vaja07.ij_v_k(1, 1, 3) == 1
  @test Vaja07.ij_v_k(2, 1, 3) == 2
  @test Vaja07.ij_v_k(3, 1, 3) == 3
  @test Vaja07.ij_v_k(1, 2, 3) == 4
  @test Vaja07.ij_v_k(2, 2, 3) == 5
  @test Vaja07.ij_v_k(3, 2, 3) == 6
end

@testset "Indeks k -> (i, j)" begin
  @test Vaja07.k_v_ij(1, 3) == (1, 1)
  @test Vaja07.k_v_ij(2, 3) == (2, 1)
  @test Vaja07.k_v_ij(3, 3) == (3, 1)
  @test Vaja07.k_v_ij(4, 3) == (1, 2)
  @test Vaja07.k_v_ij(5, 3) == (2, 2)
  @test Vaja07.k_v_ij(6, 3) == (3, 2)
end