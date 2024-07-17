using Vaja07

P = prehodna_matrika(Konj(8, 8))

x, it = potencna(P', rand(64))

using LinearAlgebra

x, it = potencna(P' + I, rand(64))
x = x / sum(x)

using Plots
heatmap(reshape(x, 8, 8))