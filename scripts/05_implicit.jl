# primer 2 točk
using Vaja05
""" Ustvari Gaussovo funkcijo z danim `sigma`."""
gauss(sigma) = r -> exp(-r^2 / sigma^2)

točke = [[1, 0], [2, 1]]
uteži = [2, 1]
rbf = RBF(točke, uteži, gauss(0.7))
# za izračun vrednosti v dani točki lahko uporabimo `vrednost([1.5, 1.5], rbf)`,
# lahko pa objekt tipa RBF kličemo direktno kot funkcijo
z = rbf([1.5, 1.5])
# primer 2 točk
using BookUtils

p("05_z", z)

# slika 2 točki
using Plots
x = range(0, 3, 50)
y = range(-1, 3, 50)
wireframe(x, y, (x, y) -> rbf([x, y]), xlabel="\$x\$", ylabel="\$y\$")
# slika 2 točki
savefig("img/05-2točki.svg")

# oblak
fi = range(0, 2π, 21)
točke = [[8cos(t) - cos(4t), 8sin(t) - sin(4t)] for t in fi[1:end-1]]
točke_noter = točke .* 0.9 # točke v smeri normal določimo približno
scatter(Tuple.(točke), label="točke na krivulji")
scatter!(Tuple.(točke_noter), label="točke v notranjosti")
# oblak

# interpolacija
vse_točke = vcat(točke, točke_noter)
c1, c2 = -1, 5
vrednosti = vcat(
  c1 * ones(length(točke)), c2 * ones(length(točke)))
rbf = interpoliraj(vse_točke, vrednosti, gauss(3))
x = range(-10, 10, 100)
y = range(-10, 10, 100)
contour!(x, y, (x, y) -> rbf([x, y]), levels=[c1, c2], clabels=true)
# interpolacija
savefig("img/05-krivulja.svg")

contour(x, y, (x, y) -> rbf([x, y]))
savefig("img/05-contours.svg")


rbf = interpoliraj(vse_točke, vrednosti, gauss(1))
contour(x, y, (x, y) -> rbf([x, y]), levels=[c1])
scatter!(Tuple.(točke), label="točke na krivulji")
savefig("img/05-contours-1.svg")

rbf = interpoliraj(vse_točke, vrednosti, gauss(10))
contour(x, y, (x, y) -> rbf([x, y]), levels=[c1, c2])
scatter!(Tuple.(točke), label="točke na krivulji")
savefig("img/05-contours-5.svg")


rbf.(vse_točke)
x = range(-10, 10, 30)
x = y
contourf(x, y, (x, y) -> rbf([x, y])) 