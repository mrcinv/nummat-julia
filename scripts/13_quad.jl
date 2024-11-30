using Vaja13
using Plots

# Izračun koeficientov Simpsonove formule
# abc
abc = [1 1 1; 0 1 2; 0 3 12]\[1, 1, 4]
# abc

using BookUtils
term("13-abc", abc)

# Graf, ki ilustrira trapezno formulo
x = [0.5, 1.5]
plot(sin, x..., fillrange=0, fillalpha=0.1, c=1, 
  xrange=[0.2, 1.8], label="\$\\int_a^b f(x) dx\$", 
  xticks = false)
plot!(x, sin.(x), fillrange=0, fillalpha=1, 
  c=:black, fillcolor=6, label="trapezna formula",
  framestyle=:zerolines,
  showaxis=:x)
plot!(x, sin.(x), label=false, c=:black, seriestype=:sticks)
plot!(x, zero(x), label=false, c=:black)
annotate!(x, 0.03*[-1, -1], ["\$a\$", "\$b\$"])
annotate!(x + 0.1*[-1, 1], sin.(x) + 0.01*[1, 1], ["\$f(a)\$", "\$f(b)\$"])
annotate!(1, 0.2, "\$\\int_a^b f(x) dx \\approx \\frac{b - a}{2}\\left(f(a)+f(b)\\right)\$")

savefig("img/13-trapez.svg")

# graf, ki ilustrira sestavljeno trapezno formulo
f(x) = sin(x+1)
x = range(0, 3, 6)
plot(f, x[1], x[end], fillrange=(x -> 0), 
  fillalpha=0.4, c=1, label="\$\\int_a^b f(x) dx\$",
  showaxis=:x,
  framestyle=:zerolines, ticks=false,
  grid=false, xlims=[-0.2, 3.2], 
  ylims=[f(x[end])-0.15, f(x[2]) + 0.15])
annotate!(x, 0.1*[-1, -1, -1, -1, 1, 1], 
  vcat(["\$x_0=a\$"], ["\$x_{$i}\$" for i in 1:4],["\$x_5=b\$"]))
annotate!((x[2]+x[3])/2, 0.1, "\$h\$")
plot!(x, f.(x), fillrange=(x->0), filalpha=0.1, c=:black, fillcolor=:6, label="sestavljena trapezna formula")
plot!(x, f.(x), seriestype=:sticks, c=:black, label=false)
scatter!(x, f.(x), label=false, markercolor=1)
annotate!(x + 0.1*[1, 1, 1, 1, -1, -1], f.(x) + 0.1*[1, 1, 1, 1, -1, -1], 
  vcat(["\$f(a)\$"], ["\$f(x_{$i})\$" for i in 1:4],["\$f(b)\$"]))

savefig("img/13-sest-trapez.svg")

# Primer sin(x^3) na [0, 3]
# sin x2
f(x) = sin(x^2)
plot(f, 0, 3, fillrange=0, fillalpha=0.4, label="\$\\int_0^3 \\sin(x^2) dx\$")
# sin x2
savefig("img/13-sinx2.svg")

int_1 = Integral(f, Interval(0.0, 3.0))

n = 2 .^ (3:10)
I_trapez = [integriraj(int_1, Trapezna(k)) for k in n]

I_simpson = [integriraj(int_1, Simpson(k)) for k in n]


n_gl = 5:20

I_gl = [integriraj(int_1, glkvad(k)) for k in n_gl]

I_p = integriraj(int_1, glkvad(2 * n_gl[end]))
# napaka sin
scatter(n .+ 1, abs.(I_trapez .- I_p), label="napaka trapezne formule")
scatter!(2n .+ 1, abs.(I_simpson .- I_p), label="napaka Simpsonove formule",)
scatter!(n_gl, abs.(I_gl .- I_p), xscale=:log10, yscale=:log10,
  label="napaka Gauss-Legendrove kvadrature",
  xlabel="število funkcijskih izračunov", ylabel="napaka",
  legend=:bottomright)
# napaka sin

savefig("img/13-napaka-sin.svg")

g(x) = exp(-x^2)
int_2 = Integral(g, Interval(-28.0, -5.0))

h(x) = abs(2 - x^2)
int_3 = Integral(h, Interval(-1.0, 2.0))

n = 2 .^ (3:15)
I_trapez = [integriraj(int_3, Trapezna(k)) for k in n]

I_simpson = [integriraj(int_3, Simpson(k)) for k in n]

diff(I_simpson)

n_gl = 2 .^ (5:20)

I_gl = [integriraj(int_3, glkvad(k)) for k in n_gl]

diff(I_gl)

atol = 1e-13
I_p, x = integriraj(int_3, AdaptivnaKvadratura(Simpson(1), atol, 4))
n_ad = length(x)
scatter(x, h.(x), label="krajišča podintervalov",
  legend=:bottomleft)
plot!(h, int_3.interval.min, int_3.interval.max, label="\$h(x)=|2 -x^2|\$")
savefig("img/13-adaptivna-abs.svg")

# napaka abs
scatter(n .+ 1, abs.(I_trapez .- I_p), label="napaka trapezne formule")
scatter!(2n .+ 1, abs.(I_simpson .- I_p), label="napaka Simpsonove formule",)
scatter!(n_gl, abs.(I_gl .- I_p), xscale=:log10, yscale=:log10,
  label="napaka Gauss-Legendrove kvadrature",
  xlabel="število funkcijskih izračunov", ylabel="napaka",
  legend=:topright)
# napaka abs
savefig("img/13-napaka-abs.svg")

gl78 = Vaja13.KvadraturniPar(glkvad(7), glkvad(8))

adgl78 = AdaptivnaKvadratura(gl78, 1e-13)
interfc(x) = DoloceniIntegral{Float64,Float64}(u -> exp(-1 / u^2) / u^2, Interval(0.0, x))
I, napaka = Vaja13.oceninapako(interfc(1 / 10.0), adgl78)
I, napaka = Vaja13.oceninapako(interfc(1 / 20.0), adgl78)



erfc_ad = erfc(AdaptivnaKvadratura(gl78, 1e-13))
F(x) = (1 + 2x) * exp(x^2) * erfc_ad(x)
exp(1 / 0.01^2)
plot(x -> SpecialFunctions.erfc(x), 1, 10)
plot!(x -> erfc_ad(x), 1, 10)
plot(x -> (SpecialFunctions.erfc(x) - erfc_ad(x)), 1, 20)

SpecialFunctions.erfcx(30)
exp(30^2)
relnapaka(a, b) = abs(b - a) / b
plot(x -> relnapaka(2 / sqrt(pi) * erfc_ad(x), SpecialFunctions.erfc(x)), 1, 20)
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

integrand(u) = u == 0 ? 0 : exp(-1 / u^2) / u^2


n = 60
x = -10
I0 = integral(integrand, gl, (1 / x, 0, n))
I1 = integral(integrand, gl, (1 / x, 0, n + 1))
(I1 - I0) / I1
exp(-7^2)

using Plots
plot(integrand, -0.5, 0)


function phi_adaptivna(x)
  k = x * exp(x^2)
  integrand(u) = exp(-1 / u^2) / u^2
  i, koraki = Vaja13.adaptive(u -> k * integrand(u),
    Vaja13.legendre3, 1 / x, 0, 1e-10)
  return i / k, koraki
end

x = -10
k = x * exp(x^2)
k * integrand(1 / x)
Vaja13.adaptive(u -> k * integrand(u), Vaja13.legendre3, -1 / 10, 0, 1e-8)

plot(x -> phi_adaptivna(x)[2], -15, -1)

x = -14
exp(-x^2)

f3 = aproksimiraj(CebisevaVrsta, sin, (0, 2pi), 18)
f3.koef
plot(sin, 0, 2pi)
plot(x -> sin(x) - f3(x), 0, 2pi)