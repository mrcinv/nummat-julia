#' # Reševanje sistemov nelinearnih enačb
#'
#' ## Primer razdalje med krivuljama
#
# krivulja
using Plots
l(t) = [sin(2t), cos(3t)]
t = range(0, 2pi, 500)
plot(Tuple.(l.(t)), label=nothing)
# krivulja

savefig("img/10-lissajous.svg")

# samopres
using Vaja09
f(ts) = l(ts[1]) - l(ts[2])
dl(t) = [2cos(2t), -3sin(3t)]
df(ts) = hcat(dl(ts[1]), - dl(ts[2]))
ts, it = newton(f, df, [0.0, pi/2])
scatter!(Tuple.(l.(ts)), label="samopresečišče")
# samopres

function samopres(k, dk, ts0)
  f(ts) = k(ts[1]) - k(ts[2])
  df(ts) = hcat(dk(ts[1]), -dk(ts[2]))
  ts, it = newton(f, df, ts0)
  mod2pi(x) = rem(x, 2pi)
  ts = mod2pi.(ts)
  ts = sort(ts)
  if abs(ts[1] - ts[2]) < 1e-12
    throw("Ista parametra ne pomenita samopresečišča")
  end
  return ts, it
end

samopres(l, dl, [0, 2pi])

x, y, Z, nicle, koraki = konvergenca(Box2d(Interval(0, 2pi), Interval(0, 2pi)), 
  x0 -> samopres(l, dl, x0), 200, 200)
heatmap(x, y, Z, xlabel="\$t\$", ylabel="\$s\$")
nicle
p = plot(Tuple.(l.(t)))
for ts in nicle
  scatter!(p, Tuple.(l.(ts)))
end
p
k1(t) = [2 * cos(t) + 1 / 3, sin(t) + 0.25]
k2(s) = [cos(s) / 3 - sin(s) / 2, cos(s) / 3 + sin(s) / 2]
t = range(0, 4 * pi, 60);
plot(Tuple.(k1.(t)), label="K1")
plot!(Tuple.(k2.(t)), label="K2")
# krivulja

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
