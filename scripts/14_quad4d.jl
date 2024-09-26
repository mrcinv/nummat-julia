using Vaja14, Vaja13
using LinearAlgebra

# razdalja
function razdalja(x)
  d = div(length(x), 2)
  return norm(x[1:d] - x[d+1:2d])
end
# razdalja

razdalja([1, 2, 3, 4])

# povprecna
function povprecna_razdalja(
  box::Vector{Interval{Float64}}, kvad)
  integral = VeckratniIntegral{Float64,Float64}(razdalja, vcat(box, box))
  I = integriraj(integral, kvad)
  return I / volumen(box)^2
end
# povprecna

using FastGaussQuadrature
kvad_gl(n) = Kvadratura(gausslegendre(n)..., Interval(-1.0, 1.0))

# izracun
kvadrat = [Interval(0.0, 1.0), Interval(0.0, 1.0)]
integral = VeckratniIntegral{Float64,Float64}(razdalja, vcat(kvadrat, kvadrat))

d0 = integriraj(integral, simpson(0.0, 1.0, 30))
# izracun
using BookUtils

p("14-dp", I)


# napaka simpson
function napaka_simpson(kvadrat, n1, n2)
  d0 = povprecna_razdalja(kvadrat, simpson(0.0, 1.0, 2 * n2))
  napaka = [
    povprecna_razdalja(kvadrat, simpson(0.0, 1.0, i)) - d0 for i in n1:n2]
  return n1:n2, napaka
end

using Plots
ns, errs = napaka_simpson(kvadrat, 3, 20)
scatter((2 * ns .+ 1) .^ 4, abs.(errs), yscale=:log10, xscale=:log10, 
  label="napaka Simpson")
# napaka simpson
# red s
k = reshape(4*log.((2 * ns .+ 1)), length(errs), 1) \ log.(abs.(errs))
# red s
p("14-ksim", k)

# napaka mc
using Random
rng = Xoshiro(526)

function napaka_mc(kvadrat, n, d0, rng)
  napaka = [
    povprecna_razdalja(kvadrat, MonteCarlo(rng, i)) - d0 for i in n]
  return napaka
end

nmc = 2 .^(10:25)
errmc = napaka_mc(kvadrat, nmc, d0, rng)
scatter!(nmc, abs.(errmc), yscale=:log10, xscale=:log10, 
  label="napaka MC")
# napaka mc
# red mc
k = reshape(log.(nmc), length(nmc), 1) \ log.(abs.(errmc))
# red mc
p("14-kmc", k)

savefig("img/14-napaka.svg")