# 01cov
import Pkg
Pkg.test("Vaja00"; coverage=true)
# 01cov

using Plots
# 01plot
plot(x -> x - x^2, -1, 2, title="Graf y(x) = x - x^2 na [-1,2]")
# 01plot
savefig("img/01_graf.svg")
