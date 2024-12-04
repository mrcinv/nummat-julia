using Vaja14, Vaja13
using LinearAlgebra

# razdalja
"""
Izračunaj razdaljo med dvema točkama podanima v enem vektorju `x`.
Koordinate prve točke so podana v prvi polovici, koordinate druge točke pa v
drugi polovici komponent vektorja `x`.
"""
function razdalja(x)
  d = div(length(x), 2)
  return norm(x[1:d] - x[d+1:2d])
end
# razdalja

razdalja([1, 2, 3, 4])

# povprecna
"""Izračunaj povprečno razdaljo med dvema točkama na danem pravokotniku."""
function povprecna_razdalja(box::Vector{Interval{Float64}}, kvadratura)
  integral = VeckratniIntegral{Float64,Float64}(razdalja, vcat(box, box))
  I = integriraj(integral, kvadratura)
  return I / volumen(box)^2
end
# povprecna

using BookUtils

# izracun
kvadrat = [Interval(0.0, 1.0), Interval(0.0, 1.0)]
integral = VeckratniIntegral{Float64,Float64}(razdalja, vcat(kvadrat, kvadrat))
n = 15
d0 = integriraj(integral, simpson(0.0, 1.0, n))
# izracun
term("14-dp", d0)

# ocena napake
n = 30
d1 = integriraj(integral, simpson(0.0, 1.0, n))
napaka = d0 - d1
# ocena napake
term("14-napaka", napaka)


# mc izračun
using Random
rng = Xoshiro(4526) # ustvarimo nov pseudo random generator
mc = MonteCarlo(rng, 16^4) # uporabimo isto število izračunov kot prvič
dmc = [
  integriraj(integral, mc) for i in 1:5] # vsaka ponovitev vrne nekaj drugega
# mc izračun
term("14-dmc", dmc)

# napaka simpson
using Plots
nsim = 3:20
napakesim = [povprecna_razdalja(kvadrat, simpson(0.0, 1.0, i)) - d1 for i in nsim]
scatter((2 * nsim .+ 1) .^ 4, abs.(napakesim), yscale=:log10, xscale=:log10,
  label="napaka Simpson")
# napaka simpson
# red s
k = reshape(4 * log.((2 * nsim .+ 1)), length(nsim), 1) \ log.(abs.(napakesim))
# red s
term("14-ksim", k)

# napaka gl
using FastGaussQuadrature
glkvvad(n) = Kvadratura(gausslegendre(n)..., Interval(-1.0, 1.0))
ngl = 10:4:40
napakegl = [povprecna_razdalja(kvadrat, glkvvad(i)) - d1 for i in ngl]
scatter!(ngl .^ 4, abs.(napakegl), yscale=:log10, xscale=:log10,
  label="napaka Gauss-Legendre")
# napaka gl
dgl = povprecna_razdalja(kvadrat, glkvvad(60))
dgl - d1
"""
Izračunaj sestavljeno Gauss-Legendreovo formulo s osnovnim pravilom s `k`
vozli in delitvijo na `n` podintervalov.
"""
function glsest(k, n)
  x0, u0 = gausslegendre(k)
  x, u = x0, u0
  for i in 1:n-1
    u = vcat(u, u0)
    x = vcat(x, x0 .+ 2 * i)
  end
  return Kvadratura(x, u, Interval(-1.0, 1.0 + 2 * (n - 1)))
end

# napaka za sestavljeno GL7
glsest(3, 2)

ngls = 1:20
napakegls = [povprecna_razdalja(kvadrat, glsest(1, i)) - dgl for i in ngls]
scatter!((1 * ngls) .^ 4, abs.(napakegls), yscale=:log10, xscale=:log10,
  label="napaka GL7")
# napaka mc
using Random
rng = Xoshiro(526)
nmc = 2 .^ (10:25)
napakamc = [povprecna_razdalja(kvadrat, MonteCarlo(rng, i)) - d1 for i in nmc]
scatter!(nmc, abs.(napakamc), yscale=:log10, xscale=:log10,
  label="napaka MC", xlabel="število izračunov funkcije")
# napaka mc
savefig("img/14-napaka.svg")
# red mc
k = reshape(log.(nmc), length(nmc), 1) \ log.(abs.(napakamc))
# red mc
term("14-kmc", k)

# singularnost
x(t) = [t, 0, 1 - t, 0]
plot(t -> razdalja(x(t)), 0, 1)
plot(t -> razdalja([t, t, 1 - t, 1 - t]), 0, 1)
# singularnost
