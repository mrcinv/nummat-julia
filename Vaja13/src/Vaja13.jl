module Vaja13

using FastGaussQuadrature

"""
Podatkovna struktura za interval `[min, max]`.
"""
struct Interval{T}
  min::T
  max::T
end

"""Izračunaj predznačeno dolžino intervala."""
dolzina(int::Interval) = int.max - int.min

"""
Podatkovna struktura, ki vsebuje uteži, vozlišča in interval 
kvadrature za izračun približka določenega integrala na danem 
intervalu.
# Primer
```jl
# trapezna formula na intervalu [0, 1]
trapez = Kvadratura([0, 1], [0.5, 0.5], Interval(0, 1))
```
"""
struct Kvadratura{T}
  x::Vector{T} # vozlišča
  u::Vector{T} # uteži
  int::Interval{T}
end

# preslikaj
"""
  t = preslikaj(x, int1, int2)

Z linearno preslikavo preslikaj vrednost `x` z intervala `int1` na 
interval `int2`."""
function preslikaj(x, int1::Interval, int2::Interval)
  return dolzina(int2) / dolzina(int1) * (x - int1.min) + int2.min
end

"""
  kvad2 = preslikaj(kvad1::Kvadratura, int::Interval)
  
Preslikaj dano kvadraturo `kvad1` na drug interval `int`.
"""
function preslikaj(kvad::Kvadratura, int::Interval)
  preslikava(x) = preslikaj(x, kvad.int, int)
  t = preslikava.(kvad.x)
  u = dolzina(int) / dolzina(kvad.int) * kvad.u
  return Kvadratura(t, u, int)
end
# preslikaj

"""
  I = integral(fun, kvadratura)

Izračunaj približek za določeni integral funkcije `fun` s kvadraturno formulo 
`kvadratura` na intervalu, ki ga določa kvadratura.
"""
function integriraj(fun, kvad::Kvadratura)
  ux = zip(kvad.u, kvad.x)
  (u, x), i = iterate(ux)
  I = u * fun(x)
  naslednji = iterate(ux, i)
  while naslednji !== nothing
    (u, x), i = naslednji
    I += u * fun(x)
    naslednji = iterate(ux, i)
  end
  return I
end

function trapezna(interval::Interval, n)
  x = collect(range(interval.min, interval.max, n + 1))
  h = x[2] - x[1]
  u = h * vcat([0.5], ones(n - 1), [0.5])
  return Kvadratura(x, u, interval)
end

trapezna(interval::Interval) = trapezna(interval, 1)

function simpson(interval::Interval, n)
  x = collect(range(interval.min, interval.max, 2n + 1))
  h = x[2] - x[1]
  u = vcat([1, 4], repeat([2, 4], n - 1), [1])
  u *= (h / 3)
  return Kvadratura(x, u, interval)
end

simpson(interval::Interval) = simpson(interval, 1)


struct AdaptivnaKvadratura{T}
  kvad::Kvadratura{T}
  atol::T
  red::Int
end

function razpolovi(interval::Interval)
  c = (interval.min + interval.max) / 2
  return Interval(interval.min, c), Interval(c, interval.max)
end

function razpolovi(kvad::Kvadratura)
  levi, desni = razpolovi(kvad.int)
  return preslikaj(kvad, levi), preslikaj(kvad, desni)
end

function integriraj(fun, akvad::AdaptivnaKvadratura)
  kvad = akvad.kvad
  atol = akvad.atol
  red = akvad.red
  I0 = integriraj(fun, kvad)
  leva_kvad, desna_kvad = razpolovi(kvad)
  leviI = integriraj(fun, leva_kvad)
  desniI = integriraj(fun, desna_kvad)
  napaka = leviI + desniI - I0
  k = 2^red - 1
  if abs(napaka) < k * atol
    return leviI + desniI + napaka / k, [leva_kvad.int.min, leva_kvad.int.max,
      desna_kvad.int.max]
  else
    I1, x1 = integriraj(fun,
      AdaptivnaKvadratura(leva_kvad, atol / 2, red))
    I2, x2 = integriraj(fun,
      AdaptivnaKvadratura(desna_kvad, atol / 2, red))
    return I1 + I2, vcat(x1, x2[2:end])
  end
end

function razdeli(interval::Interval)
  a, b = interval.min, interval.max
  c = (a + b) / 2
  return Interval(a, c), Interval(c, b)
end

cebiseve_tocke(n) = [cos((2k + 1)pi / (2n)) for k in 0:n-1]

function cebiseve_tocke(n, int::Interval)
  x = cebiseve_tocke(n)
  preslikava(x) = preslikaj(x, Interval(-1.0, 1.0), int)
  return preslikava.(x)
end

struct CebisevaVrsta{T1,T2}
  koef::T1
  interval::Interval{T2}
end

CebisevaVrsta(koef) = CebisevaVrsta(koef, Interval(-1.0, 1.0))

import Base.length

length(T::CebisevaVrsta) = length(T.koef)

function vrednost(x, T::CebisevaVrsta)
  n = length(T)
  x = preslikaj(x, T.interval, Interval(-1.0, 1.0))
  y = T.koef[1]
  if n == 1
    return y
  end
  y += T.koef[2] * x
  if n == 2
    return y
  end
  T0 = 1
  T1 = x
  for i = 3:n
    T2 = 2 * x * T1 - T0
    y += T.koef[i] * T2
    T0, T1 = T1, T2
  end
  return y
end

(T::CebisevaVrsta)(x) = vrednost(x, T)

"""
  T = aproksimiraj(CebisevaVrsta, fun, int::Interval, n::Int)

Aproksimiraj funkcijo `fun` na intervalu `int` s prvimi `n` členi
Čebiševe vrste. 
"""
function aproksimiraj(::Type{<:CebisevaVrsta}, fun, int::Interval, n::Int)
  koef = zeros(n + 1)
  t = cebiseve_tocke(n + 1)
  f = [fun(preslikaj(ti, Interval(-1.0, 1.0), int)) for ti in t]
  T0 = ones(n + 1)
  koef[1] = sum(f) / (n + 1)
  if n == 1
    return CebisevaVrsta(koef, int)
  end
  T1 = t
  koef[2] = 2 * sum(f .* T1) / (n + 1)
  for i = 3:n+1
    T2 = 2 * t .* T1 - T0
    koef[i] = 2 * sum(f .* T2) / (n + 1)
    T0, T1 = T1, T2
  end
  return CebisevaVrsta(koef, int)
end

export Interval, integriraj, preslikaj, trapezna, simpson
export Kvadratura, integral, CebisevaVrsta, aproksimiraj, AdaptivnaKvadratura

end # module Vaja13
