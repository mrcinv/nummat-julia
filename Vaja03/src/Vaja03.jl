module Vaja03
# Tridiagonalna
"""
  Tridiag(sd, d, zd)

Sestavi tri diagonalno matriko iz prve pod diagonale `sd`, glavne diagonale `d`
in prve nad diagonale `zd`. Rezultat je tipa `Tridiag`, ki omogoča učinkovito
reševanje tri diagonalnega sistema linearnih enačb. Dolžina vektorjev `sd` in
`zd` mora biti za ena manj kot dolžina vektorja `d`. 
"""
struct Tridiag
  sd::Vector # spodnja pod diagonala
  d::Vector # glavna diagonala
  zd::Vector # zgornja nad diagonala
  function Tridiag(sd, d, zd)
    if (length(sd) != length(d) - 1) || (length(zd) != length(d) - 1)
      error("Napačne dimenzije diagonal.")
    end
    new(sd, d, zd)
  end
end
export Tridiag
# Tridiagonalna

# size
# Vgrajene funkcije moramo naložiti, če jim želimo dodati nove metode. 
import Base: size, getindex, setindex!, *, \
"""
    size(T::Tridiag)

Vrni dimenzije tridiagonalne matrike `T`.
"""
size(T::Tridiag) = (length(T.d), length(T.d))

# size
# getindex
"""
   elt = T[i, j]

Vrni element v `i`-ti vrstici in `j`-tem stolpcu tridiagonalne matrike `T`
"""
function getindex(T::Tridiag, i, j)
  n, _m = size(T)
  if (i < 1) || (i > n) || (j < 1) || (j > n)
    throw(BoundsError(T, (i, j)))
  end
  if i == j - 1
    return T.zd[i]
  elseif i == j
    return T.d[i]
  elseif i == j + 1
    return T.sd[j]
  else
    return zero(T.d[1])
  end
end
# getindex
# množenje
"""
    y = T*x

Izračunaj produkt tridiagonalne matrike `T` z vektorjem `x`.
"""
function *(T::Tridiag, x::Vector)
  n = length(T.d)
  if (n != length(x))
    error("Dimenzije se ne ujemajo!")
  end
  y = zero(x)
  y[1] = T[1, 1] * x[1] + T[1, 2] * x[2]
  for i = 2:n-1
    y[i] = T[i, i-1] * x[i-1] + T[i, i] * x[i] + T[i, i+1] * x[i+1]
  end
  y[n] = T[n, n-1] * x[n-1] + T[n, n] * x[n]
  return y
end
# množenje

# setindex
"""
  T[i, j] = x

Nastavi element `T[i, j]` na vrednost `x`.
"""
function setindex!(T::Tridiag, x, i, j)
  n, _m = size(T)
  if (i < 1) || (i > n) || (j < 1) || (j > n)
    throw(BoundsError(T, (i, j)))
  end
  if i == j - 1
    T.zd[i] = x
  elseif i == j
    T.d[i] = x
  elseif i == j + 1
    T.sd[j] = x
  else
    error("Elementa [$i, $j] ni mogoče spremeniti")
  end
end
# setindex

# deljenje
"""
    x = T\\b

Izračunaj rešitev sistema `Tx = b`, kjer je `T` tridiagonalna matrika in `b`
vektor desnih strani.
"""
function \(T::Tridiag, b::Vector)
  n, _m = size(T)
  # ob eleminaciji se spremeni le glavna diagonala
  T = Tridiag(T.sd, copy(T.d), T.zd)
  b = copy(b)
  # eliminacija
  for i = 2:n
    l = T[i, i-1] / T[i-1, i-1]
    T[i, i] = T[i, i] - l * T[i-1, i]
    b[i] = b[i] - l * b[i-1]
  end
  # obratno vstavljanje
  b[n] = b[n] / T[n, n]
  for i = (n-1):-1:1
    b[i] = (b[i] - T[i, i+1] * b[i+1]) / T[i, i]
  end
  return b
end
# deljenje

end # module Vaja03
