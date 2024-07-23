# primer 2 točk
using Vaja05
""" Ustvari Gaussovo funkcijo z danim `sigma`."""
gauss(sigma) = r -> exp(-r^2 / sigma^2)

tocke = [[1, 0], [2, 1]]
utezi = [2, 1]
rbf = RBF(tocke, utezi, gauss(0.7))
# za izračun vrednosti v dani točki lahko uporabimo `vrednost(rbf, [3, 4])`,
# lahko pa objekt tipa RBF kličemo direktno kot funkcijo
z = rbf([1.5, 1.5])
# primer 2 točk
using BookUtils

p("05_z", z)

# slika 2 točki
using Plots
x = range(0, 3, 50)
y = range(-1, 3, 50)
wireframe(x, y, (x, y) -> rbf([x, y]))
# slika 2 točki
savefig("img/05-2tocki.svg")

# oblak
fi = range(0, 2π, 21)
tocke = [[8cos(t) - cos(4t), 8sin(t) - sin(4t)] for t in fi[1:end-1]]
tocke_noter = tocke .* 0.9 # točke v smeri normal določimo približno
scatter(Tuple.(tocke), label="točke na krivulji")
scatter!(Tuple.(tocke_noter), label="točke v smeri normal")
# oblak

# interpolacija
vse_tocke = vcat(tocke, tocke_noter)
c1, c2 = -1, 5
vrednosti = vcat(
  c1*ones(length(tocke)), c2*ones(length(tocke)))
rbf = interpoliraj(vse_tocke, vrednosti, gauss(3))
x = range(-10, 10, 100)
y = range(-10, 10, 100)
contour!(x, y, (x, y) -> rbf([x, y]), levels=[c1, c2], clabels=true)
# interpolacija
savefig("img/05-krivulja.svg")

rbf.(vse_tocke)
x = range(-10, 10, 30)
x = y
contourf(x, y, (x, y) -> rbf([x, y]))

using CairoMakie
CairoMakie.contour3d(x, y, (x, y) -> rbf([x, y]), levels=[c, 1])
savefig("img/05-contour3d.svg")
contourf(x, y, (x, y) -> rbf([x, y]))

plot(tp2, 0, 2)
