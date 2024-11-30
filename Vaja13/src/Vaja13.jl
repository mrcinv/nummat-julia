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

# Integral
"""
Podatkovna struktura za določeni integral funkcije `fun` na danem intervalu. 
"""
struct Integral{T}
  f
  interval::Interval{T}
end
# Integral

abstract type AbstraktnaKvadratura end

# trapezna
"""
Parametri za sestavljeno trapezno pravilo. Sestavljeno trapezno
pravilo ima en sam parameter `n`,  ki pove na koliko podintervalov
razdelimo interval.
"""
struct Trapezna <: AbstraktnaKvadratura
  n::Integer
end

"""
    I = integriraj(i::Integral, k::Trapezna)

Izračunaj približek za integral `i` s sestavljeno trapezno kvadraturo.
"""
function integriraj(i::Integral, k::Trapezna)
  a = i.interval.min
  b = i.interval.max
  h = (b - a) / k.n
  I = (i.f(a) + i.f(b)) / 2
  for j in 1:k.n-1
    I += i.f(a + j * h)
  end
  return h * I
end
# trapezna

# simpson
"""
Parametri za sestavljeno Simpsonovo pravilo. Pravilo ima en sam 
parameter `n`,  ki pove na koliko podintervalov razdelimo interval.
"""
struct Simpson <: AbstraktnaKvadratura
  n::Integer
end

"""
    I = integriraj(i::Integral, k::Simpson)

Izračunaj približek za integral `i` s sestavljeno Simpsonovo kvadraturo.
"""
function integriraj(i::Integral, k::Simpson)
  a = i.interval.min
  b = i.interval.max
  h = (b - a) / k.n
  I = (i.f(a) + i.f(b) + 4 * i.f(b - h / 2))
  for j in 1:k.n-1
    I += 4 * i.f(a + (j - 0.5) * h)
    I += 2 * i.f(a + j * h)
  end
  return (h / 6) * I
end

# simpson


struct Kvadratura{T} <: AbstraktnaKvadratura
  x::Vector{T}
  u::Vector{T}
  interval::Interval{T}
end

# integriraj
"""
    I = integriraj(i::Integral, k::Kvadratura)

Izračunaj približek za integral `i` s kvadraturo `k`.
# Primer
```jl
i = Integral(x->sin(x^2), Interval(2., 5.))
k = Kvadratura([0., 1.], [0.5, 0.5], Interval(0., 1.)) # trapezna formula
integriraj(i, k)
```
"""
function integriraj(i::Integral, k::Kvadratura)
  # funkcija, ki vozlišča kvadrature preslika na interval integrala
  razteg = dolzina(i.interval) / dolzina(k.interval)
  preslikaj(x) = razteg * (x - k.interval.min) + i.interval.min
  # zaporedje parov (u(j), x(j)) ustvarimo s funkcijo `zip`
  I = sum(u * i.f(preslikaj(x)) for (u, x) in zip(k.u, k.x))
  return razteg * I
end

# integriraj

# glkvad
using FastGaussQuadrature

function glkvad(n)
  x, u = gausslegendre(n)
  return Kvadratura(x, u, Interval(-1.0, 1.0))
end
# glkvad

struct AdaptivnaKvadratura{T}
  kvad::AbstraktnaKvadratura
  atol::T
  red::Integer
end

function razpolovi(interval::Interval)
  c = (interval.min + interval.max) / 2
  return Interval(interval.min, c), Interval(c, interval.max)
end

function razpolovi(i::Integral)
  levi, desni = razpolovi(i.interval)
  return Integral(i.f, levi), Integral(i.f, desni)
end

function integriraj(i::Integral, adk::AdaptivnaKvadratura)
  kvad = adk.kvad
  atol = adk.atol
  red = adk.red
  I0 = integriraj(i, kvad)
  levi, desni = razpolovi(i)
  leviI = integriraj(levi, kvad)
  desniI = integriraj(desni, kvad)
  napaka = leviI + desniI - I0
  k = 2^red - 1
  if abs(napaka) < k * atol
    return leviI + desniI + napaka / k,
    [levi.interval.min, levi.interval.max, desni.interval.max]
  else
    I1, x1 = integriraj(levi, adk)
    I2, x2 = integriraj(desni, adk)
    return I1 + I2, vcat(x1, x2[2:end])
  end
end


cebiseve_tocke(n) = [cos((2k + 1)pi / (2n)) for k in 0:n-1]

function preslikaj(x, int1::Interval, int2::Interval)
  razteg = dolzina(int2) / dolzina(int1)
  return razteg * (x - int1.min) + int2.min
end

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

export Interval, Integral, Trapezna, Simpson, integriraj, glkvad
export Kvadratura, CebisevaVrsta, aproksimiraj, AdaptivnaKvadratura

end # module Vaja13
