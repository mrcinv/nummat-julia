using Vaja14, Vaja13
using LinearAlgebra

function razdalja(x)
  d = div(length(x), 2)
  return norm(x[1:d] - x[d+1:2d])
end

razdalja([1, 2, 3, 4])

function povprecna_razdalja(
  box::Vector{Interval{Float64}}, kvad::Kvadratura{Float64})
  integral = VeckratniIntegral{Float64, Float64}(razdalja, vcat(box, box))
  I = integriraj(integral, kvad)
  return I / volumen(box)^2
end

using FastGaussQuadrature
kvad_gl(n) = Kvadratura(gausslegendre(n)..., Interval(-1., 1.))

box = [Interval(-1.0, 1.0), Interval(-1., 1.)]
gl10 = kvad_gl(10)

I1 = Vaja14.ndquad(razdalja, gl10.x, gl10.u, 4)
integral = VeckratniIntegral{Float64, Float64}(razdalja, vcat(box, box))
I2 = integriraj(integral, gl10)

I1 -I2

function napaka_gl(n1, n2)
  box = [Interval(0.0, 1.0), Interval(0., 1.)]
  I0 = povprecna_razdalja(box, kvad_gl(n2+1))
  napaka =[povprecna_razdalja(box, kvad_gl(i)) - I0 for i in n1:n2]
  return n1:n2, napaka
end

errf(n) = povprecna_razdalja(box, kvad_gl(n)) - povprecna_razdalja(box, kvad_gl(n+1))

errf(70)

function napaka_simpson(n1, n2)
  I0 = povprecna_razdalja(box, simpson(0., 1., 2*n2))
  napaka =[povprecna_razdalja(box, simpson(0., 1., i)) - I0 for i in n1:n2]
  return n1:n2, napaka
end

ngl, errgl = napaka_gl(3, 25)
scatter(ngl.^4, abs.(errgl), yscale=:log10, xscale=:log10)
ns, errs = napaka_simpson(3, 12)
scatter((2*ns .+ 1).^4, abs.(errs), yscale=:log10, xscale=:log10)
reshape(log.((2*ns .+ 1)), length(errs), 1)\log.(abs.(errs))
reshape(log.(ngl), length(ngl), 1)\log.(abs.(errgl))
using Plots