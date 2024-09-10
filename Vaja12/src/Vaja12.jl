module Vaja12
# hermiteint
# bazne funkcije na [0, 1]
h00(t) = 1 + t^2 * (-3 + 2 * t)
h01(t) = t^2 * (3 - 2 * t)
h10(t) = t * (1 + t * (-2 + t))
h11(t) = t^2 * (-1 + t)

"""
    hermiteint(x, xint, y, dy)

Izračunaj vrednost Hermitovega kubičnega polinoma p v točki `x`, ki interpolira
podatke `p(xint[1]) == y[1]`, `p(xint[2]) == y[2]` in 
`p'(xint[1]) == dy[1]`, `p'(xint[2]) == dy[2]`.
"""
function hermiteint(x, xint, y, dy)
  dx = xint[2] - xint[1]
  t = (x - xint[1]) / dx
  return y[1] * h00(t) + y[2] * h01(t) + dx * (dy[1] * h10(t) + dy[2] * h11(t))
end
# hermiteint

# HermitovZlepek
"""
Podatkovna struktura, ki hrani podatke za Hermitov kubični zlepek 
v interpolacijskih točkah `x` z danimi vrednostmi `y` in vrednostmi
odvoda `dy`.
"""
struct HermitovZlepek
  x
  y
  dy
end
# HermitovZlepek
# vrednost
"""
    y = vrednost(x, Z)

Izračunaj vrednost Hermitovega kubičnega zlepka `Z` v dani točki `x`.
"""
function vrednost(x, Z::HermitovZlepek)
  i = searchsortedfirst(Z.x, x)
  if (x == first(Z.x))
    return first(Z.y)
  end
  if (i > lastindex(Z.x)) || (i == firstindex(Z.x))
    throw(BoundsError(Z, x))
  end
  return hermiteint(x, Z.x[i-1:i], Z.y[i-1:i], Z.dy[i-1:i])
end

(Z::HermitovZlepek)(x) = vrednost(x, Z)
# vrednost
export hermiteint, HermitovZlepek, vrednost


end # module Vaja12
