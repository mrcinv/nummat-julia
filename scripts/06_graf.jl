
using SparseArrays

using Vaja06

# lestev
using Vaja06
G = krozna_lestev(8)

using GraphRecipes, Plots
graphplot(G, curves=false)
# lestev

savefig("img/06-lestev.svg")

# lestev fix
t = range(0, 2pi, 9)[1:end-1]
x = cos.(t)
y = sin.(t)
scatter(x[1:8], y[1:8], label="fiksna vozlišča")
# lestev fix

# lestev fiz
tocke = hcat(hcat(x, y)', zeros(2, 8))
fix = 1:8

vlozi!(G, fix, tocke)
graphplot!(G, x=tocke[1, :], y=tocke[2, :], curves=false)
# lestev fiz
savefig("img/06-lestev-fiz.svg")

using Random
Random.seed!(321)
tocke = rand(2, 50)

using DelaunayTriangulation

tri = triangulate(tocke)

G = SimpleGraph(size(tocke)[2])
for (i, j) in each_solid_edge(tri)
  add_edge!(G, i, j)
end
graphplot(G, x=tocke[1, :], y=tocke[2, :], curves=false)


lock_convex_hull!(tri)
rob = unique(get_boundary_nodes(tri))
robne_tocke = [get_point(tri, i) for i in rob]
scatter!(robne_tocke)

vlozi!(G, rob, tocke)
graphplot(G, x=tocke[1, :], y=tocke[2, :], curves=false)
scatter!(robne_tocke)

using Graphs
# mreža
m, n = 6, 6
G = grid((m, n), periodic=false)

# vogali imajo stopnjo 2
vogali = filter(v -> degree(G, v) <= 2, vertices(G))
tocke = zeros(2, n * m)
tocke[:, vogali] = [0 0 1 1; 0 1 0 1]

vlozi!(G, vogali, tocke)
graphplot(G, x=tocke[1, :], y=tocke[2, :], curves=false)
# mreža
savefig("img/06-mreza.svg")

# krožna
m, n = 6, 6
G = grid((m, n), periodic=false)
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
tocke = zeros(2, n * m)
tocke[:, urejen_rob] = hcat(cos.(t), sin.(t))'
vlozi!(G, urejen_rob, tocke)
graphplot(G, x=tocke[1, :], y=tocke[2, :], curves=false)
# krožna
savefig("img/06-mreza-krog.svg")