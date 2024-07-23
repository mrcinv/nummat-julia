using Plots, GraphRecipes
using SparseArrays

function lojtra(n)
  A = spzeros(2 * n, 2 * n)
  for i = vcat(1:n-1, n+1:2n-1)
    A[i, i+1] = 1
    A[i+1, i] = 1
  end

  for i = 1:n
    A[i, i+n] = 1
    A[i+n, i] = 1
  end

  A[1, n] = 1
  A[n, 1] = 1
  A[2n, n+1] = 1
  A[n+1, 2n] = 1
  return A
end

t = range(0, 2pi, 6)[1:end-1]
x = vcat(2*sin.(t), sin.(t))
y = vcat(2*cos.(t), cos.(t))

graphplot(lojtra(5), x=x, y=y, curves=false)

using Graphs

g = ladder_graph(6)

adjacency_matrix(g)

graphplot(adjacency_matrix(g), curves=false)

using Random
Random.seed!(123)
x = range(0, 1, 7)[2:end-1]
rob = hcat([0 1 1 0; 0 0 1 1], 
  hcat(x, ones(5))', 
  hcat(x, zeros(5))',
  hcat(ones(5), x)', 
  hcat(zeros(5), x)', 
  )
notranje_tocke = rand(2, 50)
tocke = rand(2, 50)

using DelaunayTriangulation

tri = triangulate(tocke)

triplot(tri)

lock_convex_hull!(tri)
rob = get_boundary_nodes(tri)
robne_tocke = [get_point(tri, i) for i in rob]
scatter(robne_tocke)
get_point(tri, 1)
using Vaja06

notranji_indeksi = setdiff(Set(each_vertex(tri)), Set(rob))

setdiff([1, 2, 3], [2, 3])

using Graphs

g = SimpleGraph(10)
Set(vertices(g))

d = Dict(1=>2, 3=> 4)
haskey(d, 2)

