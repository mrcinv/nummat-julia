using Vaja15
"""
    y = koren(x)

Izračunaj kvadratni koren argumenta `x`.
"""
function koren(x)
  y = 1 + (x - 1) / 2
  for i = 1:5
    y = (y + x / y) / 2
  end
  return y
end

"""Izračunaj simetrično diferenco za funkcijo `f` v točki `x` z odmikom `h`."""
dif(f, x, h) = (f(x + h) - f(x - h)) / (2h)

k2 = koren(2)
dk2 = 1 / (2k2) # prava vrednost odvoda v x=2

using Plots
h = 1 ./ 10 .^ ((1:16))

using Plots
napaka = [abs(dif(koren, 2, hi) - dk2) for hi in h]

scatter(h, napaka, yscale=:log10, xscale=:log10,
  label="napaka diference \$\\frac{f(x+h)-f(x-h)}{2h}\$", xlabel="\$h\$")

savefig("img/15-napaka-dif.svg")


# enacba
using Plots
e = 0.5
plot(E -> E - e * sin(E), -10, 10, label="\$E - e\\sin(E)\$")
M = 5
plot!(x -> M, -10, 10, label="\$M\$")
# enacba

savefig("img/15-enacba.svg")


# iteracija
plot(E -> E, -10, 10)
plot!(E -> M + e * sin(E), -10, 10)
# iteracija

# keplerE
"""
    E = keplerE(M, e)

Izračunaj ekscentrično anomalijo Keplerjeve orbite z ekscentričnostjo `e`
za povprečno anomalijo `M`.
"""
function keplerE(M, e, maxit=10, atol=1e-10)
  g(E) = M - E + e * sin(E)
  dg(E) = -1 + e * cos(E)
  E0 = M
  for i in 1:maxit
    E = E0 - g(E0) / dg(E0)
    if abs(E - E0) < atol
      @info "Newtonova metoda konvergira po $i korakih."
      return E
    end
    E0 = E
  end
  throw("Iteracija ne konvergira po $maxit korakih")
end
# keplerE

# orbita
"""
Izračunaj x in y koordinati na Keplerjevi orbiti.
"""
function orbita(t, a, b, n)
  M = n * t
  e = sqrt(1 - b^2 / a^2)
  E = keplerE(M, e)
  return (a * (cos(E) - e), b * sin(E))
end
# orbita

# slika orbite
a, b, n = 2, 1, 0.9
t = range(0, 6.8, 20)
o = [orbita(ti, a, b, n) for ti in t]
scatter(o, label="položaji v enakomernih časovnih razmikih",
  yrange=[-1, 1.5], legend=:topleft)

t = range(0, 2pi, 100)
e = sqrt(1 - b^2 / a^2)
plot!(a * (cos.(t) .- e), b * (sin.(t)), label=false)
scatter!((0, 0), label="masno središče (fokus elipse)")
plot!([o[2], (0, 0), o[3], (0, 0), o[7], (0, 0), o[8]], label=false)
# slika orbite

savefig("img/15-orbita.svg")

using BookUtils
using Vaja15
# hitrost 0
t0 = t[5] + ε
# hitrost 0
term("15-dual-t", t0)

# hitrost 1
o0 = orbita(t0, a, b, n)
# hitrost 1

term("15-polozaj", o0)

# hitrost 2
odvod.(o0)
# hitrost 2

term("15-hitrost", odvod.(o0))

# koren
"""
    y = koren(x)

Izračunaj vrednost korenske funkcije za argument `x`.
"""
function koren(x)
  y = 1 + (x - 1) / 2
  for i = 1:5
    y = (y + x / y) / 2
  end
  return y
end
# koren

# dkoren
"""
    y, dy = dkoren(x)

Izračunaj vrednost korenske funkcije in njenega odvoda za argument `x`.
"""
function dkoren(x)
  y = 1 + (x - 1) / 2
  dy = 1 / 2
  for i = 1:5
    y = (y + x / y) / 2
    dy = (dy + 1 / y - x / y^2 * dy) / 2
  end
  return y, dy
end
# dkoren

using BookUtils
# koren 2
y, dy = dkoren(2)
# koren 2
term("15-koren", (y, dy))
# koren 3
napaka = dy - 1 / (2sqrt(2))
# koren 3
term("15-napaka", napaka)

dkoren(0)

capture("15-koren-auto-err") do
y, dy = dkoren(2)
dy - 1 / (2y)
end

struct Elipsa{T}
  a::T
  b::T
end

ekscentricnost(e::Elipsa) = sqrt(1 - e.b^2 / e.a^2)

struct KeplerOrbit{T}
  n::T # povprečno gibanje
  e::Elipsa{T}
end

function eanomalija(M, e)
  f(E) = M - E + e * sin(E)
  df(E) = -1 + e * cos(E)
  E = M
  for i = 1:5
    E = E - f(E) / df(E)
  end
  return E
end

using Vaja15
# ackley
"""
Izračunj vrednost Ackleyeve funkcije za argument `x`
s parametri `a`, `b` in `c`.
"""
function ackley(x, a, b, c)
  d = length(x)
  S1 = 0.0
  S2 = 0.0
  for xi in x
    S1 += xi * xi
    S2 += cos(c * xi)
  end
  y = a + MathConstants.e
  y -= a * exp(-b * sqrt(S1 / d))
  y -= exp(S2 / d)
  return y
end
# ackley

# ack 0
x0 = [1.1, 1.2, 1.3]
# ack 0


# ack 1
x0 = Vaja15.spremenljivka(x0)
# ack 1

# ack 2
y = ackley(x0, 4, 5, 6)
# ack 2

# ack 3
dy = odvod(y)
# ack 3

using BookUtils

term("15-ackley-1", x0)
term("15-ackley-2", y)
term("15-ackley-3", dy)
