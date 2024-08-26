module Vaja09

# newton
using LinearAlgebra

function newton(f, jf, x0; maxit=100, atol=1e-8)
  for i = 1:maxit
    x = x0 - jf(x0) \ f(x0)
    if norm(x - x0, Inf) < atol
      return x, i
    end
    x0 = x
  end
  throw("Metoda ne konvergira po $maxit korakih!")
end
# newton

# box2d
struct Interval
  min
  max
end

vsebuje(x, i::Interval) = x >= i.min && x <= i.max

struct Box2d
  int_x
  int_y
end

vsebuje(x, b::Box2d) = vsebuje(x[1], b.int_x) && vsebuje(x[2], b.int_y)

diskretiziraj(i::Interval, n) = range(i.min, i.max, n)
diskretiziraj(b::Box2d, m, n) = (
  diskretiziraj(b.int_x, m), diskretiziraj(b.int_y, n))

# box2d
# konvergenca
"""
    x, y, Z = konvergenca((a, b, c, d), metoda, n=50, m=50; maxit=50, tol=1e-3)

Izračunaj h katerim vrednostim konvergira metoda `metoda`, če uporabimo različne
začetne približke na pravokotniku `[a, b]x[c, d]`.

# Primer
Konvergenčno območje za Newtonovo metodo za kompleksno enačbo ``z^3=1``

```jldoctest
julia> F((x, y)) = [x^3-3x*y^2; 3x^2*y-y^3];
julia> JF((x, y)) = [3x^2-3y^2 -6x*y; 6x*y 3x^2-3y^2]
julia> metoda(x0) = newton(F, JF, x0; maxit=10; tol=1e-3);

julia> x, y, Z = konvergenca((-2,2,-2,2), metoda; n=5, m=5); Z
5×5 Array{Float64,2}:
 1.0  1.0  2.0  3.0  3.0
 1.0  1.0  2.0  3.0  3.0
 1.0  1.0  0.0  3.0  3.0
 2.0  2.0  2.0  2.0  2.0
 2.0  2.0  2.0  2.0  2.0
```
"""
function konvergenca(obmocje::Box2d, metoda, m=50, n=50; atol=1e-3)
  Z = zeros(m, n)
  koraki = zeros(m, n)
  x, y = diskretiziraj(obmocje, n, m)
  nicle = []
  for i = 1:n, j = 1:m
    z = [x[i], y[j]]
    it = 0
    try
      z, it = metoda(z)
    catch
      continue
    end
    k = findfirst([norm(z - z0, Inf) < 2atol for z0 in nicle])
    if isnothing(k) && vsebuje(z, obmocje)
      push!(nicle, z)
      k = length(nicle)
    end
    Z[j, i] = k # vrednost elementa je enka indeksu ničle
    koraki[j, i] = it # številu korakov metode
  end
  return x, y, Z, nicle, koraki
end
# konvergenca


export newton, konvergenca, Interval, Box2d, vsebuje, diskretiziraj
end # module Vaja09
