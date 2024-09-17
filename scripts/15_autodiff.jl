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

"""Izračunaj simetično diferenco za funkcijo `f` v točki `x` z odmikom `h`."""
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

"""
    y, dy = dkoren(x)

Izračunaj vrednost korenske funkcije in  njenega odvoda za argument
`x`.
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

using BookUtils
capture("15-koren-auto-err") do
  y, dy = dkoren(2)
  dy - 1/(2y)
end