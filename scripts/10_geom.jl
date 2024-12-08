# krivulja
using Plots
l(t) = [sin(2t), cos(3t)]
t = range(0, 2pi, 500)
# Funkcija plot drugače interpretira vektor vektorjev kot vektor parov (Tuple).
# Zato vektorje koordinat spremenimo v pare koordinat (Tuple).
plot(Tuple.(l.(t)), label=nothing)
# krivulja

savefig("img/10-lissajous.svg")

# samopresečišče
using Vaja09: newton
using Printf
f(tt) = l(tt[1]) - l(tt[2])
dl(t) = [2cos(2t), -3sin(3t)]
df(tt) = hcat(dl(tt[1]), -dl(tt[2]))
tt, it = newton(f, df, [0.0, pi / 2])
scatter!(Tuple.(l.(tt)),
  label=@sprintf "samopresečišče: \$t_1=%.3f\$, \$t_2=%.3f\$" tt...)
# samopresečišče

savefig("img/10-samopres.svg")

# območje samopres
using Vaja10: samopres
mod2pi(x) = rem(x, 2pi)
""" Poišči samopresečišče Lissajousove krivulje. Upoštevaj periodičnost."""
function splissajous(tt0)
  tt, it = samopres(l, dl, tt0)
  tt = mod2pi.(tt)
  if abs(tt[1] - tt[2]) < 1e-12
    throw("Isti vrednosti parametra ne pomenita samopresečišča.")
  end
  return sort(tt), it
end

using Vaja09: konvergenca, Box2d, Interval
x, y, Z, ničle, koraki = konvergenca(Box2d(Interval(0, 2pi), Interval(0, 2pi)),
  splissajous, 200, 200)
heatmap(x, y, Z, xlabel="\$t_1\$", ylabel="\$t_2\$")
scatter!(Tuple.(ničle), label="samopresečišča", legend=:bottomleft)
# območje samopres

savefig("img/10-obmocje-samopres.svg")

# vsa samopresečišča
p = plot(Tuple.(l.(t)), label="krivulja", legend=:bottom)
for tt in ničle
  scatter!(p, Tuple.(l.(tt)), label=@sprintf "\$t_1=%.2f\$, \$t_2=%.2f\$" tt...)
end
display(p)
# vsa samopresečišča

savefig("img/10-vsa-samopres.svg")

# krivulji
k1(t) = [2 * cos(t) + 1 / 3, sin(t) + 0.25]
k2(s) = [cos(s) / 3 - sin(s) / 2, cos(s) / 3 + sin(s) / 2]
t = range(0, 2pi, 60);
plot(Tuple.(k1.(t)), label="K1")
plot!(Tuple.(k2.(t)), label="K2")
# krivulji

savefig("img/10-krivulji.svg")


# razdalja

using Vaja10: razdalja2
d2 = razdalja2(k1, k2)

t = range(-pi, pi, 100)
s = t
contourf(t, s, d2, xlabel="\$t\$", ylabel="\$s\$")
# razdalja

savefig("img/10-graf-razdalja.svg")

using BookUtils: capture
# odvodi
using ForwardDiff
gradd2(ts) = ForwardDiff.gradient(ts -> d2(ts...), ts)
# odvodi
p("10_grad", v)

# spust
"Izračunaj zaporedje približkov gradientne metode."
function približki(grad, x0, h, n)
  p = [x0]
  for i = 1:n
    x = x0 - h * grad(x0)
    push!(p, x)
    x0 = x
  end
  return p
end

pribl = približki(gradd2, [2.0, -1.5], 0.2, 40)
scatter!(Tuple.(pribl), label="približki gradientne metode")
# spust

savefig("img/10_priblizki_grad.svg")

# newton
jacd2(x0) = ForwardDiff.jacobian(gradd2, x0)
korak_newton(f, Jf, x0) = x0 - Jf(x0) \ f(x0)
x0 = [2.0, -1.5]
pribl_newton = [x0]
for i = 1:10
  x0 = korak_newton(gradd2, jacd2, x0)
  push!(pribl_newton, x0)
end
scatter!(Tuple.(pribl_newton), label="približki Newtonove metode")
# newton

savefig("img/10_priblizki.svg")

# sedlo
using Vaja09: newton
t = range(0, 2pi, 100)
plot(Tuple.(k1.(t)), label="\$k_1(t)\$")
plot!(Tuple.(k2.(t)), label="\$k_2(s)\$")
ts, it = newton(gradd2, jacd2, [2, -1.5])
scatter!(Tuple(k1(ts[1])), label="\$k_1(t_0)\$")
scatter!(Tuple(k2(ts[2])), label="\$k_2(s_0)\$")
# sedlo

savefig("img/10_sedlo.svg")

# minimum
using Vaja10: spust
t = range(0, 2pi, 100)
plot(Tuple.(k1.(t)), label="\$k_1(t)\$")
plot!(Tuple.(k2.(t)), label="\$k_2(s)\$")
ts, it = spust(gradd2, [2, -1.5], 0.2)
scatter!(Tuple(k1(ts[1])), label="\$k_1(t_0)\$")
scatter!(Tuple(k2(ts[2])), label="\$k_2(s_0)\$")
# minimum

savefig("img/10_minimum.svg")


# območje grad
using Vaja09: konvergenca
using Vaja10: spust
function spustd2(x0)
  ts, it = spust(gradd2, x0, 0.2; maxit=1000)
  ts = map(t -> mod(t + pi, 2pi) - pi, ts)
  return ts, it
end
x, y, Z, ničle, koraki = konvergenca(
  Box2d(Interval(-pi, pi), Interval(-pi, pi)), spustd2, 100, 100;
  atol=1e-2)
heatmap(x, y, Z)
scatter!(Tuple.(ničle), label="lokalni minimumi")
contour!(x, y, d2)
# območje grad
savefig("img/10_obmocje_grad.svg")

# območje newton
function newtond2(x0)
  ts, it = newton(gradd2, jacd2, x0; atol=1e-5)
  ts = map(t -> mod(t + pi, 2pi) - pi, ts)
  return ts, it
end
x, y, Z, ničle, koraki = konvergenca(
  Box2d(Interval(-pi, pi), Interval(-pi, pi)), newtond2, 500, 500;
  atol=1e-2)
heatmap(x, y, Z)
scatter!(Tuple.(ničle), label="stacionarne točke")
contour!(x, y, d2)
# območje newton
savefig("img/10_obmocje_newton.svg")
