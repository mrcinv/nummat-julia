# gauss mix
using Plots
using Random
m = 100;
Random.seed!(12)
x = [1 .+ randn(m, 1); -3 .+ randn(m, 1); randn(m, 1)];
y = [-2 .+ randn(m, 1); -1 .+ randn(m, 1); 1 .+ randn(m, 1)];
scatter(x[1:100], y[1:100], label="\$\\mu = (1, -2)\$")
scatter!(x[101:200], y[101:200], label="\$\\mu = (-3, -1)\$")
scatter!(x[201:300], y[201:300], label="\$\\mu = (0, 1)\$")
# gauss mix
savefig("img/08_oblak.svg")

# Laplace
using Vaja08
using SparseArrays
točke = hcat(x, y)'
r = 1.0
G = graf_eps(točke, r)
L = laplace(G)
spy(L, legend=false)
# Laplace
savefig("img/08_laplaceova_matrika.svg")

# eigen
using LinearAlgebra
razcep = eigen(Matrix(L))
scatter(razcep.values[1:20], title="Prvih 20 lastnih vrednosti Laplaceove matrike")
# eigen
savefig("img/08_lastne_vrednosti.svg")

# vložitev
x_nov = razcep.vectors[:, 5]
y_nov = razcep.vectors[:, 6]
scatter(x_nov[1:100], y_nov[1:100], label="\$\\mu=(1, -2)\$")
scatter!(x_nov[101:200], y_nov[101:200], label="\$\\mu=(-3, -1)\$")
scatter!(x_nov[201:300], y_nov[201:300], label="\$\\mu=(0, 1)\$")
# vložitev
savefig("img/08_vlozitev.svg")

using BookUtils
capture("08_inviterqr") do
  # inviter
  A = L + 0.1 * I # premik, da dobimo pozitivno definitno matriko
  n = size(L, 1)
  # poiščemo prvih 10 lastnih vektorjev
  X, lambda = inviterqr(B -> Vaja08.cgmat(A, B), ones(n, 10), 1000)
  # inviter
end
