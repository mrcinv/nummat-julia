using Vaja16
# posevni
using LinearAlgebra
"""
Izračunaj desne strani enačb za poševni met.
"""
function f_posevni(_, u, p)
  v = u[4:6]
  g = -[0, 0, p[1]]
  f = g - p[2] * v * norm(v)
  return vcat(v, f)
end
# posevni
# posevni zp
"""
Sestavi začetni problem za poševni met z začetnimi pogoji in parametri.
"""
function posevni_met(x0, v0, t, g, C)
  u0 = vcat(x0, v0)
  tint = [0, t]
  p = [g, C]
  return ZacetniProblem(f_posevni, u0, tint, p)
end
# posevni zp

# primer 1
zp = posevni_met([0.0, 0.0, 1.0], [10.0, 5.0, 20.0], 3., 10.0, 0.1)
res = resi(zp, Euler(2000))
using Plots
plot!(t->res(t)[1], t->res(t)[3], 0, 3)
plot(t->res(t)[3], 0, 1)
# primer 1

# primer 2
res100 = resi(zp, RK2(100))
res200 = resi(zp, RK2(200))
plot(t -> norm(res100(t) - res200(t)), zp.tint...)
x = [u[1] for u in res.u]
y = [u[3] for u in res.u]
scatter(res.t)
# primer 2

# polje smeri
using LinearAlgebra

"""
Izračunaj enotski vektor v smeri tangente na rešitev diferencialne enačbe
  `u'(t)=f(t, u(t))``."""
function tangenta(f, t, u)
  v = [1, f(t, u)]
  return v / norm(v)
end

function daljica(f, t, u, l)
  v = l * tangenta(f, t, u) / 2
  dt, du = v
  return [t - dt, t + dt], [u - du, u + du]
end

""" Vzorči polje smeri za NDE `u' = fun(t, u)`"""
function vzorci_polje(fun, (t0, tk), (u0, uk), n=21)
  t = range(t0, tk, n)
  u = range(u0, uk, n)

  dt = t[2] - t[1]
  du = u[2] - u[1]
  l = min(dt, du) * 0.6

  # enotske vektorje skaliramo, da se ne prekrivajo
  polje = [daljica(fun, ti, ui, l) for ti in t for ui in u]
  return polje
end
# polje smeri

# polje slika
using Plots
function risi_polje(polje)
  N = length(polje)
  x = polje[1][1]
  y = polje[1][2]
  for i in 2:N
    # med daljice vrinemo vrednosti NaN, da plot prekine črto
    push!(x, NaN)
    append!(x, polje[i][1])
    push!(y, NaN)
    append!(y, polje[i][2])
  end
  return plot(x, y,
    xlabel="\$t\$", ylabel="\$u\$", label=false
  )
end

fun(t, u) = -2 * t * u
polje = vzorci_polje(fun, (-2, 2), (0, 4))
plt = risi_polje(polje)
# polje slika

# zacetni pogoj
t0 = [-1, -1, 1]
u0 = [0.5, 1, 1.5]
scatter!(plt, t0, u0, label="začetni pogoji")
for i in 1:3
  C = u0[i] / exp(-t0[i]^2)
  plot!(plt, t -> C * exp(-t^2), -2, 2, label="rešitev \$u(t)\$")
end
plt
# zacetni pogoj

savefig("img/16-resitve.svg")

# euler 1
using Vaja16

tint = (-0.5, 0.5)
u0 = 1
plt = risi_polje(fun, tint, (u0, 1.5))

C = u0 / exp(-tint[1]^2)
plot!(plt, x -> C * exp(-x^2), tint[1], tint[2],
  label="prava rešitev", legend=:topleft)


u, t = Vaja16.euler(fun, 1.0, [-0.5, 0.5], 4)
plot!(plt, t, u, marker=:circle, label="približna rešitev za \$n=4\$",
  xlabel="\$t\$", ylabel="\$u\$")

u, t = Vaja16.euler(fun, 1.0, [-0.5, 0.5], 8)
plot!(plt, t, u, marker=:circle, label="približna rešitev za \$n=8\$",
  xlabel="\$t\$", ylabel="\$u\$")
# for i = 2:4
#  C = u[i] / exp(-t[i]^2)
#  plot!(plt, x -> C * exp(-x^2), t[i], t[end],
#    label="\$u(t); u(t_$(i-1))=u_$(i-1)\$")
#end
plt
# euler 1

savefig("img/16-euler.svg")

# euler 2
fun(t, u, p) = -p * t * u
problem = ZacetniProblem(fun, 1.0, (-0.5, 1.0), 2.0)
upravi(t) = exp(-t^2) / exp(-0.5^2)

res100 = resi(problem, Euler(100))
plot(res100.t, res100.u - upravi.(res100.t), label="\$n=100\$")
res200 = resi(problem, Euler(200))
plot!(res200.t, res200.u - upravi.(res200.t), label="\$n=200\$")
# euler 2

savefig("img/16-euler-napaka.svg")
