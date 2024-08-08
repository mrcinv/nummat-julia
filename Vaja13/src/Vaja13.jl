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

function simpson_napaka(fun, a, b)
  x = range(a, b, 5)
  f = fun.(x)
  h = x[2] - x[1]
  I1 = 2*h/3*(f[1] + 4f[3] + f[5])
  I2 = h/3*(f[1] + 4f[2] + 2f[3] + 4f[4]+f[5])
  return I2, I2 - I1
end

function legendre_napaka(fun, a, b, n)
    x0, w0 = gl(a, b, n)
    x1, w1 = gl(a, b, n+1)
    I1 = w0' * fun.(x0)
    I2 = w1' * fun.(x1)
    err = I2 - I1
    return I1, err
end

legendre3(fun, a, b) = legendre_napaka(fun, a, b, 3)

function adaptive(fun, pravilo, a, b, atol=1e-8)
  I, err = pravilo(fun, a, b)
  if abs(err) <= atol
    return I, 1
  end
  c = (a + b)/2
  tol = atol/2
  I1, k1 = adaptive(fun, pravilo, a, c, tol)
  I2, k2 = adaptive(fun, pravilo, c, b, tol)
  return I1 + I2, k1 + k2
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
