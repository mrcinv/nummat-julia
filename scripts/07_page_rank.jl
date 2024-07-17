using Vaja07
# konj
P = prehodna_matrika(Konj(8, 8))

x, it = potencna(P', rand(64))
# konj

# lastne
using LinearAlgebra
lambda, v = eigen(Matrix(P'))
println(display(lambda))
# lastne

# premik

x, it = potencna(P' + I, rand(64))
x = x / sum(x)

using Plots
heatmap(reshape(x, 8, 8))
# premik