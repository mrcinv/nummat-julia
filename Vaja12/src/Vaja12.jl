module Vaja12
# NewtonovPolinom
"""
    NewtonovPolinom(a, x)

Vrni [newtonov interpolacijski polinom](https://en.wikipedia.org/wiki/Newton_polynomial)
oblike `a[1]+a[2](x-x[1])+a[3](x-x[1])(x-x[2])+...`
s koeficienti `a` in vozlišči `x`.

# Primer

Poglejmo si polinom ``1+x+x(x-1)``, ki je definiran s koeficienti `[1, 1, 1]` in z vozlišči
``x_0 = 0`` in ``x_1 = 1``

```jldoctest
julia> p = NewtonovPolinom([1, 1, 1], [0, 1])
NewtonovPolinom([1, 1, 1], [0, 1])
```
"""
struct NewtonovPolinom
  a # koeficienti
  x # vozlišča
end
"""
    vrednost(p::NewtonovPolinom, x)

Izračuna vrednot newtonovega polinoma `p` v `x` s Hornerjevo methodo.

# Primer

```jldoctest
julia> p = NewtonovPolinom([0, 0, 1], [0, 1]);

julia> vrednost(p, 2)
2
```
"""
function vrednost(p::NewtonovPolinom, x)
  n = length(p.x)
  v = p.a[n+1]
  for i = n:-1:1
    v = p.a[i] + (x - p.x[i]) * v
  end
  return v
end

(p::NewtonovPolinom)(x) = vrednost(p, x)
# NewtonovPolinom

# interpoliraj
using LinearAlgebra
"""
    p = interpoliraj(NewtonovPolinom, x, f)

Izračunaj koeficiente Newtonovega interpolacijskega polinoma, ki interpolira
podatke `y(x[k])=f[k]`. Če se katere vrednosti `x` večkrat ponovijo, potem
metoda predvideva, da so v `f` poleg vrednosti, podani tudi odvodi.

# Primer

Polinom ``x^2-1`` interpolira podatke `x=[0,1,2]` in `y=[-1, 0, 3]` lahko v
Newtonovi obliki zapišemo kot ``1 + x + x(x-1)``

```jldoctest
julia> p = interpoliraj(NewtonovPolinom, [0, 1, 2], [-1, 0, 3])
NewtonovPolinom([-1.0, 1.0, 1.0], [0, 1])
```

Če imamo več istih vrednosti abscise `x`, moramo v `f` podati vrednosti funkcije
in odvodov. Na primer polinom ``p(x) = x^4 = x + 3x(x-1) + 3x(x-1)^2 + x(x-1)^3``
ima v ``x=1`` vrednosti ``p(1)=1, p'(1)=4, p''(1)=12``

```jldoctest
julia> p = interpoliraj(NewtonovPolinom, [0,1,1,1,2], [0,1,4,12,16])
NewtonovPolinom([0.0, 1.0, 3.0, 3.0, 1.0], [0, 1, 1, 1])

julia> x = (1,2,3,4,5); p.(x) .- x.^4
(0.0, 0.0, 0.0, 0.0, 0.0)
```
"""
function interpoliraj(P::Type{<:NewtonovPolinom}, x, f)
  n = length(x) - 1
  m = length(f) - 1
  @assert n == m
  a = zeros(n + 1, n + 1)
  a[:, 1] = f;
  fakulteta = 1
  for j = 2:n + 1
    fakulteta *= j - 1
    for i = j:n + 1
      if x[i] != x[i-j+1]
	      a[i,j] = (a[i,j-1] - a[i-1,j-1])/(x[i] - x[i-j+1]);
      else
        a[i,j] = a[i,j-1]/fakulteta
        a[i,j-1] = a[i-1,j-1]
      end
   	end
  end
  return NewtonovPolinom(diag(a), x[1:end-1])
end
# interpoliraj

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
export hermiteint, HermitovZlepek, vrednost, NewtonovPolinom, interpoliraj

end # module Vaja12
