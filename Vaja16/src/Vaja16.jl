module Vaja16

export ZacetniProblem, ResitevNDE, resi, Euler, RK2, RK2Kontrola

# euler plain
"""
    u, t = euler(fun, u0, (t0, tk), n)

Izračunaj približek za rešitev začetnega problema za diferencialno enačbo z
Eulerjevo metodo z enakimi koraki.
# Argumenti

- `fun` desne strani DE `u'=fun(t, u)`
- `u0` začetni pogoj `u(t0) = u0`
- `(t0, tk)` interval, na katerem iščemo rešitev
- `n` število korakov Eulerjeve metode
"""
function euler(fun, u0, tint, n)
  t0, tk = tint
  t = range(t0, tk, n + 1)
  h = t[2] - t[1]
  u = [u0]
  for i = 1:n
    u0 = u0 + h * fun(t[i], u0)
    push!(u, u0)
  end
  return u, t
end
# euler plain

# ZacetniProblem
"""
  zp = ZacetniProblem(f!, u0 tspan, p)

Podatkovna struktura s podatki za začetni problem za navadne diferencialne enačbo (NDE)
```math
u'(t) = f(u, p, t).
```
z začetnim pogojem ``u(t0) = u_0`` na intervalu ``tint=[t0, t_k]`` in
vrednostmi parametrov `p`.

## Polja

* `f`: funkcija, ki izračuna odvod (desne strani NDE)
* `u0`: začetni pogoj
* `tint`: časovni interval za rešitev
* `p`: vrednosti parametrov
"""
struct ZacetniProblem
  f    # desne strani NDE u' = f(t, u, p)
  u0   # začetna vrednost
  tint # interval na katerem iščemo rešitev
  p    # parametri sistema
end
# ZacetniProblem

# ResitevNDE
"""
Podatkovna struktura, ki hrani približek za rešitev začetnega problema za NDE.
Uporablja se predvesm kot tip, ki ga vrnejo metode za reševanje začetnega problema.
"""
struct ResitevNDE
  zp::ZacetniProblem # referenca na začetni problem
  u  # približki za vrednosti rešitve
  t  # vrednosti časa(argumenta)
end
# ResitevNDE

# Euler
"""
    Euler(n)

Parametri za Eulerjevo metodo za reševanje začetnega problema NDE s fiksnim korakom.
Edini parameter je `n`, ki je enak številu korakov Eulerjeve metode.
"""
struct Euler
  n # število korakov
end

"""
  r = resi(p::ZacetniProblem, metoda::Euler)

Reši začetni problem za NDE `p` z Eulerjevo metodo s parametri `metoda`.

## Primer

Rešimo ZP za enačbo `u'(t) = -2t u` z začetnim pogojem `u(-0.5) = 1.0`:

```julia-repl
julia> fun(t, u, p) = -p * t * u;
julia> problem = ZacetniProblem(fun, 1., (-0.5, 1), 2);
julia> res = resi(problem, Euler(3)) # reši problem s 3 koraki Eulerjeve metode
ResitevNDE(ZacetniProblem(fun, 1.0, (-0.5, 1), 2), [1.0, 1.5, 1.5, 0.75], -0.5:0.5:1.0)

```
"""
function resi(p::ZacetniProblem, metoda::Euler)
  # vstavimo parametre
  fun(t, u) = p.f(t, u, p.p)
  u, t = euler(fun, p.u0, p.tint, metoda.n)
  return ResitevNDE(p, u, t)
end
# Euler

# RK2
struct RK2
 n # število korakov
end

"""
  res = resi(p::ZacetniProblem, metoda::RK2)

Reši začetni problem za NDE `p` z metodo Runge Kutta reda 2 s parametri `metoda`.
"""
function resi(zp::ZacetniProblem, metoda::RK2)
  t0, t1 = zp.tint
  n = metoda.n
  f = zp.f
  par = zp.p
  t = range(t0, t1, n + 1)
  h = t[2] - t[1]
  u = [zp.u0]
  for i = 1:n
    k1 = h * f(t[i], u[i], par)
    k2 = h * f(t[i+1], u[i] + k1, par)
    push!(u, u[i] + (k1 + k2) / 2)
  end
  return ResitevNDE(zp, u, t)
end
# RK2

# RK2Kontrola
struct RK2Kontrola
  eps
end

using LinearAlgebra
"""
  r = resi(p::ZacetniProblem, metoda::RK2Kontrola)

Reši začetni problem za NDE `p` z metodo Runge Kutta reda 2 s kontrolo koraka s parametri `metoda`.
"""
function resi(zp::ZacetniProblem, metoda::RK2Kontrola)
  t0, t1 = zp.tint
  eps = metoda.eps
  f = zp.f
  zp = zp.p
  sigma = 0.9 # varnostni faktor
  h = t1 - t0
  u = [zp.u0]
  t = [t0]
  while (last(t) < t1)
    k1 = h * f(t[i], u[i], par)
    k2 = h * f(t[i+1], u[i] + k1, par)
    ln = (-k1 + k2) / 2
    lnorma = norm(ln, Inf)
    if lnorma < eps * h
      t0 = t0 + h
      u0 += (k1 + k2) / 2
      h = minimum([t1 - t0, sigma * h * sqrt(ε * h / lnorma)])
      push!(t, t0)
      push!(u, u0)
    else
      h = h / 2
    end
  end
  return ResitevNDE(zp, u, t)
end
# RK2Kontrola


# hermite
h00(t) = (1 + 2 * t) * (1 - t)^2
h01(t) = t^2 * (3 - 2 * t)
h10(t) = t * (1 - t)^2
h11(t) = t^2 * (t - 1)

"""
    y = hermiteint(x, xi, y, dy)

Izračunaj vrednost kubičnega polinoma `p(x)`, ki interpolira podatke `xi`, `y` in `dy`:
`p(xi[j]) = y[j]` in `p'(xi[j]) = dy[j]` za `j = 1, 2`.
"""
function hermiteint(x, xi, y, dy)
  dx = xi[2] - xi[1]
  t = (x - xi[1]) / dx
  return y[1] * h00(t) + y[2] * h01(t) +
         dx * (dy[1] * h10(t) + dy[2] * h11(t))
end
# hermite

# interpolacija
"""
    y = vrednost(r, t)

Izračunaj vrednost rešitve `r` v točki `t`. Funkcija za izračun vrednosti uporabi
Hermitov zlepek.
"""
function vrednost(r::ResitevNDE, t)
  i = searchsortedfirst(r.t, t)
  if i > lastindex(r.t) || (i == firstindex(r.t) && t < first(r.t))
    throw("Vrednost $t izven intervala")
  end
  f = r.zp.f
  p = r.zp.p
  u = r.u
  tabt = r.t
  hermiteint(t, tabt[i:i+1], u[i:i+1], [f(tabt[i], u[i], p), f(tabt[i+1], u[i+1], p)])
end

# Omogočimo, da rešitev NDE kličemo kot funkcijo
(res::ResitevNDE)(t) = vrednost(res, t)
# interpolacija

end # module Vaja16
