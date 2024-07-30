#' # Reševanje sistemov nelinearnih enačb
#'
#' ## Primer razdalje med krivuljama
#'
using Plots
tocka(a) = tuple(a...)
K1(t) = [2 * cos(t) + 1 / 3, sin(t) + 0.25]
K2(s) = [cos(s) / 3 - sin(s) / 2, cos(s) / 3 + sin(s) / 2]
t = LinRange(0, 2 * pi, 60);
plot(tocka.(K1.(t)), label="K1")
plot!(tocka.(K2.(t)), label="K2")

#' Iščemo minimum kvadrata razdalje.

using LinearAlgebra

function d2(ts)
  delta = K1(ts[1]) - K2(ts[2])
  return dot(delta, delta)
end

using ForwardDiff
ForwardDiff.gradient(d2, [1, 2])
f(ts) = ForwardDiff.gradient(d2, ts)
JF(ts) = ForwardDiff.hessian(d2, ts)
fdf(ts) = (f(ts), JF(ts))

using Vaje07
ts, it = newton(fdf, [0, 0])
K1(ts[1])
scatter!(tuple(K1(ts[1])...))
scatter!(tuple(K2(ts[2])...))

#' Graf funkcije razdalje

contour(range(-pi, 2pi, 100),
  range(-pi, 2pi, 100),
  (t, s) -> d2([t, s]))
scatter!(tuple(ts...))

ts, it = newton(fdf, [2, 1])
scatter!(tuple(ts...))
