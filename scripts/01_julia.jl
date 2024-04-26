# 01cov
import Pkg
Pkg.test("Vaja01"; coverage=true)
# 01cov

using Plots
# 01plot
plot(x -> x - x^2, -1, 2, title="Graf y(x) = x - x^2 na [-1,2]")
# 01plot
savefig("img/01_graf.svg")
include("../Vaja01/doc/01uvod.jl")
savefig("img/01_demo.svg")
