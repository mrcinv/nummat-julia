using Vaja13
using Plots
using Profile

using FastGaussQuadrature
glkvad(n) = Kvadratura(gausslegendre(n)..., Interval(-1.0, 1.0))
glintegrator(n) = integrator(glkvad(n))
phi(kvad) = x -> Vaja13.phi(x, kvad)
phi_10 = phi(glkvad(10))
phi_11 = phi(glkvad(11))    
plot(x->abs(phi_10(x) - phi_11(x))/phi_11(x) + 1e-16, -5, 5, yscale=:log10)

plot(phi_11, -5, 5, yscale=:log10)

integrand(t) = exp(-1/t^2)/t^2
plot(integrand, 0, 1, label="preslikan integrand")

savefig("img/13-preslikan-integrand.svg")

erfc(kvad) = x -> Vaja13.erfc(x, kvad)
erfc_30 = erfc(glkvad(30))
erfc_31 = erfc(glkvad(31))
plot(x->abs((erfc_30(x)-erfc_31(x))/erfc_31(x)) + 1e-16, -30, -1, yscale=:log10)


gl78 = Vaja13.KvadraturniPar(glkvad(7), glkvad(8))

adgl78 = AdaptivnaKvadratura(gl78, 1e-13)
interfc(x) = DoloceniIntegral{Float64, Float64}(u->exp(-1/u^2)/u^2, Interval(0.0, x))
I, napaka = Vaja13.oceninapako(interfc(1/10.0), adgl78)
I, napaka = Vaja13.oceninapako(interfc(1/20.0), adgl78)



erfc_ad = erfc(AdaptivnaKvadratura(gl78, 1e-13))
F(x) = (1+2x)*exp(x^2)*erfc_ad(x)
exp(1/0.01^2)
plot(x->SpecialFunctions.erfc(x), 1, 10)
plot!(x->erfc_ad(x), 1, 10)
plot(x->(SpecialFunctions.erfc(x)-erfc_ad(x)), 1, 20)

SpecialFunctions.erfcx(30)
exp(30^2)
relnapaka(a, b) = abs(b - a)/b
plot(x->relnapaka(2/sqrt(pi)*erfc_ad(x), SpecialFunctions.erfc(x)), 1, 20)
(erfc_ad(2.0), SpecialFunctions.erfc(2))
using SpecialFunctions
function intexp(x, n)
  integrand(u) = exp(-(u - x)^2 / 2 + u)
  vozlisca, utezi = FastGaussQuadrature.gausslaguerre(n)
  I0 = vozlisca' * integrand.(utezi)
  vozlisca, utezi = FastGaussQuadrature.gausslaguerre(n + 1)
  I1 = vozlisca' * integrand.(utezi)
  return (I0, I1)
end


intexp(-10, 40)

using Vaja13

integrand(u) = u == 0 ? 0 : exp(-1/u^2)/u^2


n = 60
x = -10
I0 = integral(integrand, gl, (1/x, 0, n))
I1 = integral(integrand, gl, (1/x, 0, n+1))
(I1 - I0)/I1
exp(-7^2)

using Plots
plot(integrand, -0.5, 0)


function phi_adaptivna(x)
  k = x*exp(x^2)
  integrand(u) = exp(-1/u^2)/u^2 
  i, koraki = Vaja13.adaptive(u -> k*integrand(u), 
    Vaja13.legendre3, 1/x, 0, 1e-10)
  return i/k, koraki
end

x = -10
k = x*exp(x^2)
k*integrand(1/x)
Vaja13.adaptive(u->k*integrand(u), Vaja13.legendre3, -1/10, 0, 1e-8)

plot(x->phi_adaptivna(x)[2], -15, -1)

x = -14
exp(-x^2)

f3 = aproksimiraj(CebisevaVrsta, sin, (0, 2pi), 18)
f3.koef
plot(sin, 0, 2pi)
plot(x->sin(x)-f3(x), 0, 2pi)