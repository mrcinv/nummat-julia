using BookUtils

# fx
f(x) = x^2 + sin(x)
# fx
term("01_fx", f)

# fpi2
f(pi / 2)
# fpi2
term("01_fpi2", f(pi / 2))

# gxy
g(x, y) = x + y^2
# gxy
term("01_gxy", g)

# g12
g(1, 2)
# g12
term("01_g12", g(1, 2))

# 01_hxy
function h(x, y)
  z = x + y
  return z^2
end
# 01_hxy
term("01_hxy", h)

# 01_h34
h(3, 4)
# 01_h34
term("01_h34", h(3, 4))

# 01_map
map(x -> x^2, [1, 2, 3])
# 01_map
term("01_map", map(x -> x^2, [1, 2, 3])
)

# 01_k1
k(x::Number) = x^2
# 01_k1
term("01_k1", k)
# 01_k2
k(x::Vector) = x[1]^2 - x[2]^2
# 01_k2
term("01_k2", k)
# 01_k3
k(2)
# 01_k3
term("01_k3", k(2))
# 01_k4
k([1, 2, 3])
# 01_k4
term("01_k4", k([1, 2, 3]))

# 01_v1
v = [1, 2, 3]
# 01_v1
term("01_v1", v)

# 01_v2
v[1] # vrne prvo komponento vektorja
# 01_v2
term("01_v2", v[1])
# 01_v3
v[2:end] # vrne komponente vektorja od druge do zadnje
# 01_v3
term("01_v3", v[2:end])
# 01_v4
sin.(v) # funkcijo uporabimo na komponentah vektorja, če imenu dodamo .
# 01_v4
term("01_v4", sin.(v))

# 01_for1
v = [1, 2, 3]
# 01_for1
# 01_for2
f(x) = x^2
# 01_for2
# 01_for3
[f(vi) for vi in v] # podobno kot v Pythonu
# 01_for3
term("01_for3", [f(vi) for vi in v])
# 01_for4
f.(v) # operator . je alias za funkcijo broadcast, ki funkcijo aplicira na komponente
# 01_for4
term("01_for4", f.(v))
# 01_for5
map(f, v)
# 01_for5
term("01_for5", map(f, v))


# 01cov
import Pkg
Pkg.test("Vaja01"; coverage=true)
# 01cov

using Plots
# 01plot
plot(x -> x - x^2, -1, 2, color=:blue,
  linestyle=:dash, title="Graf y(x) = x - x^2 na [-1,2]")
# 01plot
savefig("img/01_graf.svg")
include("../Vaja01/doc/01uvod.jl")
savefig("img/01_demo.svg")
