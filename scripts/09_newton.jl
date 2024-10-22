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

# nicle 1
x1, it1 = newton(f, jf, [2, 0])
# nicle 1
term("09_nicle_1", (x1, it1))
# nicle 2
x2, it2 = newton(f, jf, [-1, 1.0])
# nicle 2
term("09_nicle_2", (x2, it2))
# nicle 3
x3, it3 = newton(f, jf, [-1, -1.0])
# nicle 3
term("09_nicle_3", (x3, it3))

# obmocje
using Plots
maxit = 20
obmocje = Box2d(Interval(-2, 2), Interval(-1, 1))
metoda(x0) = newton(f, jf, x0; atol=1e-4, maxit=maxit)
x, y, Z, nicle, koraki = konvergenca(obmocje, metoda, 800, 400; atol=1e-3)
heatmap(x, y, Z + 0.8 * min.(koraki / 10, 1), legend=false)
scatter!(Tuple.(nicle), label="rešitve")
# obmocje

savefig("img/09-fraktal.svg")

contour(x, y, Z, legend=false)
savefig("img/09-cipka.png")
