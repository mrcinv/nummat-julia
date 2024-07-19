using Vaja09
using Test

# interval
@testset "Interval" begin
  I = Interval(1, 3)
  @test vsebuje(2, I) == true
  @test vsebuje(3, I) == true
  @test vsebuje(1, I) == true
  @test vsebuje(0, I) == false
  @test vsebuje(4, I) == false
end
# interval

# Box2d
@testset "Pravokotnik Box2d" begin
  b = Box2d(Interval(1, 3), Interval(2, 4))
  @test vsebuje((2, 3), b) == true
  @test vsebuje((3, 4), b) == true
  @test vsebuje((3, 5), b) == false
  @test vsebuje((5, 5), b) == false
  @test vsebuje((-1, 3), b) == false
  @test vsebuje((2, -3), b) == false
end

@testset "Diskretiziraj" begin
  b = Box2d(Interval(1, 3), Interval(2, 4))
  x, y = diskretiziraj(b, 5, 6)
  @test length(x) == 5
  @test length(y) == 6
  @test x[1] == 1
  @test x[end] == 3
  @test y[1] == 2
  @test y[end] == 4
end
# Box2d