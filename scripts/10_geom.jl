#' # Reševanje sistemov nelinearnih enačb
#'
#' ## Primer razdalje med krivuljama
#'
using Plots
K1(t) = [2 * cos(t) + 1 / 3, sin(t) + 0.25]
K2(s) = [cos(s) / 3 - sin(s) / 2, cos(s) / 3 + sin(s) / 2]
t = LinRange(0, 2 * pi, 60);
plot(Tuple.(K1.(t)), label="K1")
plot!(Tuple.(K2.(t)), label="K2")

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
