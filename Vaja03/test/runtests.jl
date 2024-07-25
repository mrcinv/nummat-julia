# glava
using Vaja03
using Test

@testset "Velikost" begin
  T = Tridiag([1, 2], [3, 4, 5], [6, 7])
  @test size(T) == (3, 3)
end
# glava

# getindex
@testset "Dostop do elementov" begin
  T = Tridiag([1, 2], [3, 4, 5], [6, 7])
  # diagonala
  @test T[1, 1] == 3
  @test T[2, 2] == 4
  @test T[3, 3] == 5
  # spodaj
  @test T[2, 1] == 1
  @test T[3, 2] == 2
  @test T[3, 1] == 0
  # zgoraj
  @test T[1, 2] == 6
  @test T[2, 3] == 7
  @test T[1, 3] == 0
  # izven obsega
  @test_throws BoundsError T[1, 4]
end
# getindex

# setindex
@testset "Nastavljanje elementov" begin
  T = Tridiag([1, 1], [1, 1, 1], [1, 1])
  T[2, 2] = 2
  T[2, 3] = 3
  T[2, 1] = 4
  @test T[1, 1] == 1
  @test T[2, 2] == 2
  @test T[2, 3] == 3
  @test T[2, 1] == 4
  # izven obsega
  @test_throws ErrorException T[1, 3] = 2
end
# setindex

# množenje
@testset "Množenje z vektorjem" begin
  T = Tridiag([1, 2], [3, 4, 5], [6, 7])
  A = [3 6 0; 1 4 7; 0 2 5]
  x = [1, 2, 3]
  @test T * x == A * x
end
# množenje

# deljenje
@testset "Reševanje sistema" begin
  # deljenje ima težave z vnosi tipa `Integer`, zato dodamo decimalne pike,
  # da vrednosti uporabi kot `Float64`.
  T = Tridiag([1.0, 1], [2.0, 2, 2], [1.0, 1])
  x = [1.0, 2, 3]
  b = T * x
  @test T \ b ≈ x

  T = Tridiag(-0.5 * ones(4), ones(5), -0.5 * ones(4))
  x = T \ ones(5)
  @test x ≈ [5, 8, 9, 8, 5]
end
# deljenje

