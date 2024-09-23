module Vaja13

using FastGaussQuadrature

struct Kvadratura
  x # vozlišča
  u # uteži
  a # začetek intervala
  b # konec intervala
end

function preslikaj(x, (a, b), (c, d))
  return (d - c) * (x - a) / (b - a) + c
end

const enaskoren2pi = 1 / sqrt(2pi)


function integral(k::Kvadratura, f, a, b)
  I = 0.0
  for i in eachindex(k.x)
    t = preslikaj(k.x[i], (k.a, k.b), (a, b))
    I += f(t) * k.u[i]
  end
  return (b - a) / (k.b - k.a) * I
end

function Phi(x, k)
  f(t) = exp(-t^2 / 2)
  return 0.5 + enaskoren2pi * integral(k, f, 0, x)
end

function erfc(x, k)
  t = 1 / x
  f(u) = exp(-1 / u^2) / u^2
  integral(k, f, 0, t)
end


struct KvadData
  a
  b
  fa
  fb
end

simpson(a, b, fa, fb, fm) = (b - a) / 6 * (fa + 4fm + fb)

"""Evaluates the Simpson's Rule, also returning m and f(m) to reuse"""
function simpson_mem(f, a, fa, b, fb)
  m = (a + b) / 2
  fm = f(m)
  return (m, fm, (b - a) / 6 * (fa + 4 * fm + fb))
end

"""
Efficient recursive implementation of adaptive Simpson's rule.
Function values at the start, middle, end of the intervals are retained.
"""
function _quad_asr(f, a, fa, b, fb, eps, whole, m, fm)
  lm, flm, left = simpson_mem(f, a, fa, m, fm)
  rm, frm, right = simpson_mem(f, m, fm, b, fb)
  delta = left + right - whole
  if abs(delta) <= 15 * eps
    return left + right + delta / 15, 1
  end
  Ileft, k_left = _quad_asr(f, a, fa, m, fm, eps / 2, left, lm, flm)
  Iright, k_right = _quad_asr(f, m, fm, b, fb, eps / 2, right, rm, frm)

  return Ileft + Iright, k_left + k_right
end

"""Integrate f from a to b using Adaptive Simpson's Rule with max error of eps."""
function integral_asimpson(f, a, b, eps)
  fa, fb = f(a), f(b)
  m, fm, whole = simpson_mem(f, a, fa, b, fb)
  return _quad_asr(f, a, fa, b, fb, eps, whole, m, fm)
end

struct Trapezna
end

integral(k::Trapezna, f, a, b) = (f(a) + f(b)) / (b - a)

struct Simpson
end

integral(k::Simpson, f, a, b) = (b - a) / 6 * (f(a) + 4 * f((a + b) / 2) + f(b))

struct KvadraturniPar
  k0 # kvadratura
  k1 # red kvadrature
end

function integral_napaka(k::KvadraturniPar, f, a, b)
  I0 = integral(k.k0, f, a, b)
  I1 = integral(k.k1, f, a, b)
  return I1, I1 - I0
end

struct AdaptivnaKvadratura
  kvad # kvadratura z oceno napake
  rtol # relativna toleranca
end

function integral_napaka(kvadratura::AdaptivnaKvadratura, f, a, b)
  I, napaka = integral_napaka(kvadratura.kvad, f, a, b)
  if abs(napaka) <= rtol * abs(I)
    return I, napaka
  end
  c = (a + b) / 2
  I1, napaka1 = adaptivna(kvadratura, f, a, c)
  I2, napaka2 = adaptivna(kvadratura, f, c, b)
  return I1 + I2, napaka1 + napaka2
end

function integral(kvad::AdaptivnaKvadratura, f, a, b)
  I, napaka = integral_napaka(kvad, f, a, b)



function integral(k::AdaptivnaKvadratura, f, a, b)
  I, napaka, koraki = adaptivna(k.kvad, f, a, b, rtol)
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

export integral_asimpson
export Kvadratura, AdaptivnaKvadratura, trapez, simpson, gl, integral
export CebisevaVrsta, vrednost, aproksimiraj, erfc

end # module Vaja13
