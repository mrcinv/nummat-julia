using Vaja09
using BookUtils

# primer
f(x) = [x[1]^3 - 3x[1] * x[2]^2 - 1, 3x[1]^2 * x[2] - x[2]^3]
function jf(x)
  a = 3x[1]^2 - 3x[2]^2
  b = 6x[1] * x[2]
  jf = [a -b; b a]
end
# primer

# nicle
x1, it1 = newton(f, jf, [2, 0])
x2, it2 = newton(f, jf, [-1, 1.0])
x3, it3 = newton(f, jf, [-1, -1.0])
# nicle

# obmocje
using Plots
maxit = 20
obmocje = Box2d(Interval(-2, 2), Interval(-1, 1))
metoda(x0) = newton(f, jf, x0; atol=1e-4, maxit=maxit)
x, y, Z, nicle = konvergenca(obmocje, metoda, 800, 400; atol=1e-3)
heatmap(x, y, Z, legend=false)
scatter!(Tuple.(nicle), label="rešitve")
# obmocje

savefig("img/09-fraktal.svg")