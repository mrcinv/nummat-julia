
using SparseArrays

# lestev
using Vaja06
G = krožna_lestev(8)

using GraphRecipes, Plots
graphplot(G, curves=false)
# lestev

savefig("img/06-lestev.svg")

# lestev fiz
t = range(0, 2pi, 9)[1:end-1]
x = cos.(t)
y = sin.(t)
točke = hcat(hcat(x, y)', zeros(2, 8))
# funkcija hcat zloži vektorje po stolpcih v matriko
fix = 1:8

vloži!(G, fix, točke)
graphplot(G, x=točke[1, :], y=točke[2, :], curves=false)
# lestev fiz
savefig("img/06-lestev-fiz.svg")

using Random
Random.seed!(321)
točke = rand(2, 50)

using DelaunayTriangulation

tri = triangulate(točke)

G = SimpleGraph(size(točke)[2])
for (i, j) in each_solid_edge(tri)
  add_edge!(G, i, j)
end
graphplot(G, x=točke[1, :], y=točke[2, :], curves=false)


lock_convex_hull!(tri)
rob = unique(get_boundary_nodes(tri))
robne_točke = [get_point(tri, i) for i in rob]
scatter!(robne_točke)

vloži!(G, rob, točke)
graphplot(G, x=točke[1, :], y=točke[2, :], curves=false)
scatter!(robne_točke)

# mreža
using Graphs
m, n = 6, 6
G = Graphs.grid((m, n), periodic=false)

# vogali imajo stopnjo 2
vogali = filter(v -> degree(G, v) <= 2, vertices(G))
točke = zeros(2, n * m)
točke[:, vogali] = [0 0 1 1; 0 1 0 1]

vloži!(G, vogali, točke)
graphplot(G, x=točke[1, :], y=točke[2, :], curves=false)
# mreža
savefig("img/06-mreža.svg")

# krožna
m, n = 6, 6
G = Graphs.grid((m, n), periodic=false)
rob = filter(v -> degree(G, v) <= 3, vertices(G))
urejen_rob = [rob[1]]

# uredi točke na robu v cikel
for i = 1:length(rob)-1
  sosedi = neighbors(G, urejen_rob[end])
  sosedi = intersect(sosedi, rob)
  sosedi = setdiff(sosedi, urejen_rob)
  push!(urejen_rob, sosedi[1])
end
t = range(0, 2pi, length(rob) + 1)[1:end-1]
točke = zeros(2, n * m)
točke[:, urejen_rob] = hcat(cos.(t), sin.(t))'
vloži!(G, urejen_rob, točke)
graphplot(G, x=točke[1, :], y=točke[2, :], curves=false)
# krožna
savefig("img/06-mreža-krog.svg")
