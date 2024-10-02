using Vaja16
# posevni
using LinearAlgebra
"""
Izračunaj desne strani enačb za poševni met.
"""
function f_posevni(_, u, par)
  g, c = par
  n = div(length(u), 2)
  v = u[n+1:end]
  fg = zero(v)
  fg[end] = -g
  f = fg - c * v * norm(v)
  return vcat(v, f)
end
# posevni

# primer 1
x0 = [0.0, 1.0]
v0 = [10.0, 20.0]
tint = (0.0, 3.0)
g = 9.8
c = 0.1
zp = ZacetniProblem(f_posevni, vcat(x0, v0), tint, (g, c))
res = resi(zp, Euler(0.1))
using Plots
plot(t -> res(t)[1], 0, 3, label="\$x(t)\$")
plot!(t -> res(t)[2], 0, 3, label="\$y(t)\$")
plot!(t -> res(t)[3], 0, 3, label="\$v_x(t)\$")
plot!(t -> res(t)[4], 0, 3, label="\$v_y(t)\$")
# primer 1
savefig("img/16-komponente.svg")

# primer 2
plot(t -> res(t)[1], t -> res(t)[2], 0, 3, label="pot izstrelka")
# primer 2
savefig("img/16-trajektorija.svg")

# primer napaka
res2 = resi(zp, Euler(0.001))
plot(t -> norm(res(t) - res2(t), Inf), zp.tint..., label="napaka")
# primer napaka
savefig("img/16-napaka-euler.svg")

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
risi_polje(vzorci_polje(fun, tint, (u0, 1.5)))

C = u0 / exp(-tint[1]^2)
plot!(x -> C * exp(-x^2), tint[1], tint[2],
  label="prava rešitev", legend=:topleft)


t4, u4 = Vaja16.euler(fun, 1.0, (-0.5, 0.5), 4)
plot!(t4, u4, marker=:circle, label="približna rešitev za \$n=4\$",
  xlabel="\$t\$", ylabel="\$u\$")

t8, u8 = Vaja16.euler(fun, 1.0, [-0.5, 0.5], 8)
plot!(t8, u8, marker=:circle, label="približna rešitev za \$n=8\$",
  xlabel="\$t\$", ylabel="\$u\$")
# euler 1

savefig("img/16-euler.svg")

# euler 2
fun(t, u, p) = -p * t * u
problem = ZacetniProblem(fun, 1.0, (-0.5, 1.0), 2.0)
upravi(t) = exp(-t^2) / exp(-0.5^2)

res1 = resi(problem, Euler(0.1))
scatter(res1.t, res1.u - upravi.(res1.t), label="\$h=0.1\$")
res2 = resi(problem, Euler(0.05))
scatter!(res2.t, res2.u - upravi.(res2.t), label="\$h=0.05\$")
# euler 2

savefig("img/16-euler-napaka.svg")

# napaka
zp = ZacetniProblem(f_posevni, [0.0, 2.0, 10.0, 20.0], (0.0, 3.0), (9.8, 0.1))
function napaka(resevalec, zp, resitev, nvzorca=100)
  priblizek = resi(zp, resevalec)
  t0, tk = zp.tint
  t = range(t0, tk, nvzorca)
  maximum(t -> norm(priblizek(t) - resitev(t)), t)
end


h = 3 ./ (2 .^ (2:10))
resitev = resi(zp, RK4(h[end] / 2))
napakaEuler = [napaka(Euler(hi), zp, resitev) for hi in h]
napakaRK2 = [napaka(RK2(hi), zp, resitev) for hi in h]
napakaRK4 = [napaka(RK4(hi), zp, resitev) for hi in h]
scatter(h, napakaEuler, xscale=:log10, yscale=:log10, label="Euler")
scatter!(h, napakaRK2, xscale=:log10, yscale=:log10, label="RK2")
scatter!(h, napakaRK4, xscale=:log10, yscale=:log10, label="RK4", legend=:topleft)
# napaka
savefig("img/16-primerjava.svg")

# ničla
zp = ZacetniProblem
# ničla