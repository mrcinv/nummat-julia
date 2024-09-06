# krivulja
using Plots
l(t) = [sin(2t), cos(3t)]
t = range(0, 2pi, 500)
plot(Tuple.(l.(t)), label=nothing)
# krivulja

savefig("img/10-lissajous.svg")

# samopres
using Vaja09
using Printf
f(ts) = l(ts[1]) - l(ts[2])
dl(t) = [2cos(2t), -3sin(3t)]
df(ts) = hcat(dl(ts[1]), -dl(ts[2]))
ts, it = newton(f, df, [0.0, pi / 2])
scatter!(Tuple.(l.(ts)),
  label=@sprintf "samopresečišče: \$t=%.3f\$, \$s=%.3f\$" ts...)
# samopres

savefig("img/10-samopres.svg")

# obmocje samopres
using Vaja10
mod2pi(x) = rem(x, 2pi)
""" Poišči samopresečišče Lissjousove krivulje. Upoštevaj periodičnost."""
function splissajous(ts0)
  ts, it = samopres(l, dl, ts0)
  ts = mod2pi.(ts)
  if abs(ts[1] - ts[2]) < 1e-12
    throw("Ista parametra ne pomenita samopresečišča.")
  end
  return sort(ts), it
end

x, y, Z, nicle, koraki = konvergenca(Box2d(Interval(0, 2pi), Interval(0, 2pi)),
  splissajous, 200, 200)
heatmap(x, y, Z, xlabel="\$t\$", ylabel="\$s\$")
scatter!(Tuple.(nicle), label="samopresečišča", legend=:bottomleft)
# obmocje samopres

savefig("img/10-obmocje-samopres.svg")

# vsa samopres
p = plot(Tuple.(l.(t)), label="krivulja", legend=:bottom) # narišemo zopet krivuljo
for ts in nicle
  scatter!(p, Tuple.(l.(ts)), label=@sprintf "\$t=%.2f\$, \$s=%.2f\$" ts...)
end
display(p)
# vsa samopres

savefig("img/10-vsa-samopres.svg")

k1(t) = [2 * cos(t) + 1 / 3, sin(t) + 0.25]
k2(s) = [cos(s) / 3 - sin(s) / 2, cos(s) / 3 + sin(s) / 2]
t = range(0, 4 * pi, 60);
plot(Tuple.(k1.(t)), label="K1")
plot!(Tuple.(k2.(t)), label="K2")

savefig("img/10-vsa-samopres.svg")

savefig("img/10_krivulji.svg")
#' Iščemo minimum kvadrata razdalje.

using LinearAlgebra

function razdajla2(K1, K2)
  function d2(t, s)
    delta = K1(t) - K2(s)
    return dot(delta, delta)
  end
  return d2
end

t = range(-pi, 2pi, 100)
s = t

d2 = razdajla2(K1, K2)

contour(t, s, d2(K1, K2))

savefig("img/graf_razdalja.svg")

using ForwardDiff
ForwardDiff.gradient(d2, [1, 2])

f(t, s) = [K1(t) - K2(s), 1]
JF(ts) = ForwardDiff.hessian(d2, ts)
fdf(ts) = (f(ts), JF(ts))

using Vaje07
ts, it = newton(fdf, [0, 0])
K1(ts[1])
scatter!(tuple(K1(ts[1])...))
scatter!(tuple(K2(ts[2])...))

#' Graf funkcije razdalje


scatter!(tuple(ts...))

ts, it = newton(fdf, [2, 1])
scatter!(tuple(ts...))
