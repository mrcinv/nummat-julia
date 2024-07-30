module Vaja13

using FastGaussQuadrature

function preslikaj((a, b), (c, d), x)
  return (d - c) * (x - a) / (b - a) + c
end

"""
Poišči Gauss-Legendrove kvadrature z `n` točkami za interval [a, b]
"""
function gl(a, b, n)
  x, w = gausslegendre(n)
  x = (b - a) / 2 * x .+ (a + b) / 2
  w = (b - a) / 2 * w
  return x, w
end

"""
    x, w = trapez(a, b, n)

Izračunaj vozlišča `x` in uteži `w` za sestavljeno trapenzno pravilo na
intervalu `[a, b]` z `n` podintervali.
"""
function trapez(a, b, n)
  x = range(a, b, n + 1)
  h = x[2] - x[1]
  w = ones(n + 1) * h
  w[1] /= 2
  w[end] /= 2
  return x, w
end

function simpson(a, b, n)
  x = range(a, b, 2n + 1)
  h = x[2] - x[1]
  w = h / 3 * ones(2n + 1)
  w[2:2:end-1] *= 4
  w[3:2:end-1] *= 2
  return x, w
end

"""
    I = integral(fun, metoda, parametri)

Izračunaj integral funkcije `fun` z metodo `metoda` s `parametri`.
Argument `metoda` je funkcija, ki vrne vektorja vozlišč in uteži.
"""
function integral(fun, metoda, parametri)
  x, w = metoda(parametri...)
  return w' * fun.(x)
end

cebiseve_tocke(n) = [cos((2k + 1)pi / (2n)) for k in 0:n-1]

function cebiseve_tocke(n, (a, b))
  x = cebiseve_tocke(n)
  preslikava = x -> preslikaj((-1, 1), (a, b), x)
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
  x = preslikaj(T.interval, (-1, 1), x)
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

function aproksimiraj(fun, (a, b), n)
  koef = zeros(n + 1)
  t = cebiseve_tocke(n + 1)
  f = [fun(preslikaj((-1, 1), (a, b), ti)) for ti in t]
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

function aproksimiraj(fun, (a, b); atol=1e-8)
  
end

export trapez, simpson, gl, integral, CebisevaVrsta, vrednost, aproksimiraj

end # module Vaja13
