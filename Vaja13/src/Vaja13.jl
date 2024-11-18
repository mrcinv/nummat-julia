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
Podatkovna struktura za določeni integral funkcije `fun` na danem intervalu. 
"""
struct DoloceniIntegral{T1,T2}
  fun
  interval::Interval{T1}
end

"""
Abstrakten podatkovni tip, ki predstavlja kvadraturno formulo za 
numerično računanje določenega integrala.
"""
abstract type AbstraktnaKvadratura{T} end

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
struct Kvadratura{T} <: AbstraktnaKvadratura{T}
  x::Vector{T} # vozlišča
  u::Vector{T} # uteži
  interval::Interval{T}
end

"""
  t = preslikaj(x, int1, int2)

Z linearno preslikavo preslikaj vrednost `x` z intervala `int1` na 
interval `int2`."""
function preslikaj(x::T, int1::Interval{T}, int2::Interval{T}) where {T}
  return dolzina(int2) / dolzina(int1) * (x - int1.min) + int2.min
end

"""
  I = integriraj(integral, kvadratura)

Izračunaj približek za določeni integral `integral` s kvadraturno formulo 
`kvadratura`.
"""
function integriraj(
  int::DoloceniIntegral{T,TI}, kvad::Kvadratura{T}) where {T,TI}
  I = zero(TI)
  for i in eachindex(kvad.x)
    t = preslikaj(kvad.x[i], kvad.interval, int.interval)
    f = int.fun(t)::TI
    I += f * kvad.u[i]
  end
  return dolzina(int.interval) / dolzina(kvad.interval) * I
end



integrator(kvad::AbstraktnaKvadratura{T}) where {T} =
  integral::DoloceniIntegral{T} -> integriraj(integral, kvad)



const enaskoren2pi = 1 / sqrt(2pi)
function phi(x::Float64, kvad::AbstraktnaKvadratura{Float64})
  f(t) = exp(-t^2 / 2)
  int = DoloceniIntegral{Float64,Float64}(f, Interval(0.0, x))
  return 0.5 + enaskoren2pi * integriraj(int, kvad)
end

function erfc(x::Float64, kvad::AbstraktnaKvadratura{Float64})
  t = 1 / x
  f(u) = exp(-1 / u^2) / u^2
  int = DoloceniIntegral{Float64,Float64}(f, Interval(0.0, t))
  integriraj(int, kvad)
end

struct KvadraturniPar{T} <: AbstraktnaKvadratura{T}
  k0::AbstraktnaKvadratura{T} # kvadratura nižjega reda
  k1::AbstraktnaKvadratura{T} # kvadratura višjega reda
end

function oceninapako(integral::DoloceniIntegral, k::KvadraturniPar)
  I0 = integriraj(integral, k.k0)
  I1 = integriraj(integral, k.k1)
  return I1, I1 - I0
end

struct AdaptivnaKvadratura{T} <: AbstraktnaKvadratura{T}
  kvad::AbstraktnaKvadratura{T} # kvadratura z oceno napake
  rtol::Float64 # relativna toleranca
end

function razdeli(interval::Interval)
  a, b = interval.min, interval.max
  c = (a + b) / 2
  return Interval(a, c), Interval(c, b)
end

function razdeli(int::DoloceniIntegral{T,TI}) where {T,TI}
  interval1, interval2 = razdeli(int.interval)
  return DoloceniIntegral{T,TI}(int.fun, interval1),
  DoloceniIntegral{T,TI}(int.fun, interval2)
end

function oceninapako(
  integral::DoloceniIntegral{T,TI}, adkvad::AdaptivnaKvadratura{T}) where {T,TI}
  I, napaka = oceninapako(integral, adkvad.kvad)
  if abs(napaka) <= adkvad.rtol * abs(I)
    return I, napaka
  end
  int1, int2 = razdeli(integral)
  I1, napaka1 = oceninapako(int1, adkvad)
  I2, napaka2 = oceninapako(int2, adkvad)
  return I1 + I2, napaka1 + napaka2
end

function integriraj(integral::DoloceniIntegral, k::AdaptivnaKvadratura)
  I, _... = oceninapako(integral, k.kvad)
  return I
end

cebiseve_tocke(n) = [cos((2k + 1)pi / (2n)) for k in 0:n-1]

function cebiseve_tocke(n, (a, b))
  x = cebiseve_tocke(n)
  preslikava = x -> preslikaj(x, (-1, 1), (a, b))
  return preslikava.(x)
end

struct CebisevaVrsta
  koef
  interval
end

CebisevaVrsta(koef) = CebisevaVrsta(koef, (-1, 1))

import Base.length

length(T::CebisevaVrsta) = length(T.koef)

function vrednost(x, T::CebisevaVrsta)
  n = length(T)
  x = preslikaj(x, T.interval, (-1, 1))
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

function aproksimiraj(::Type{<:CebisevaVrsta}, fun, (a, b), n)
  koef = zeros(n + 1)
  t = cebiseve_tocke(n + 1)
  f = [fun(preslikaj(ti, (-1, 1), (a, b))) for ti in t]
  T0 = ones(n + 1)
  koef[1] = sum(f) / (n + 1)
  if n == 1
    return CebisevaVrsta(koef, (a, b))
  end
  T1 = t
  koef[2] = 2 * sum(f .* T1) / (n + 1)
  for i = 3:n+1
    T2 = 2 * t .* T1 - T0
    koef[i] = 2 * sum(f .* T2) / (n + 1)
    T0, T1 = T1, T2
  end
  return CebisevaVrsta(koef, (a, b))
end

export Interval, DoloceniIntegral, integrator, phi
export Kvadratura, AdaptivnaKvadratura, trapez, simpson, gl, integral
export CebisevaVrsta, vrednost, aproksimiraj, erfc

end # module Vaja13
