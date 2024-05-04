module Vaja16
"""
  zp = ZacetniProblem(f!, u0 tspan, p)

Podatkovna struktura, ki definira začetni problem za navadne diferencialne enačbo (NDE)
```math
\\frac{du}{dt} = f(u, p, t).
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

"""
Podatkovna struktura, ki hrani približek za rešitev začetnega problema za NDE.
Uporablja se predvesm kot tip, ki ga vrnejo metode za reševanje začetnega problema.
"""
struct ResitevNDE
  zp::ZacetniProblem # referenca na začetni problem
  u  # približki za vrednosti rešitve
  t  # vrednosti časa(argumenta)
end

struct Euler end

function resi(p::ZacetniProblem, metoda::Euler, n=100)
  t0, t1 = p.tint
  f = p.f
  p = p.p
  t = range(t0, t1, n + 1)
  h = t[2] - t[1]
  u = [p.u0]
  for i = 1:n
    u0 += h * f(t[i], u[i], p)
    push!(u, u0)
  end
  return ResitevNDE(p, u, t)
end

struct RK2 end

function resi(zp::ZacetniProblem, metoda::RK2, n=100)
  t0, t1 = zp.tint
  f = zp.f
  par = zp.p
  t = range(t0, t1, n + 1)
  h = t[2] - t[1]
  u = [zp.u0]
  for i = 1:n
    k1 = h * f(t[i], u[i], par)
    k2 = h * f(t[i+1], u[i] + k1, par)
    push!(u, u[i] + (k1 + k2)/2)
  end
  return ResitevNDE(zp, u, t)
end

struct RK2Kontrola

function resi(zp::ZacetniProblem, metoda::RK2Kontrola, ε = 1e-8)
  t0, t1 = zp.tint
  f = zp.f
  zp = zp.p
  sigma = 0.9 # varnostni faktor
  h = t1 - t0
  u = [zp.u0]
  t = [t0]
  while (last(t) < t1)
    k1 = h * f(t[i], u[i], par)
    k2 = h * f(t[i+1], u[i] + k1, par)
    ln = (-k1 + k2)/2
    lnorma = norm(ln, Inf)
    if lnorma < ε*h
      t0 = t0 + h
      u0 += (k1 + k2)/2
      h = minimum([t1 - t0, sigma * h * sqrt(ε * h/lnorma)])
      push!(t, t0)
      push!(u, u0)
    else
      h = h/2
    end
  end
  return ResitevNDE(zp, u, t)
end

# baza polinomov
h00(t) = (1 + 2 * t) * (1 - t)^2
h01(t) = t^2 * (3 - 2 * t)
h10(t) = t * (1 - t)^2
h11(t) = t^2 * (t - 1)

"""
    y = hermiteint(x, xi, y, dy)

Izračunaj vrednost kubičnega polinoma `p(x)`, ki interpolira podatke `xi`, `y` in `dy`: 
`p(xi[j]) = y[j]` in `p'[xi[j]] = dy[j]` za `j = 1, 2`. 
"""
function hermiteint(x, xi, y, dy)
  dx = xi[2] - xi[1]
  t = (x - xi[1]) / dx
  return y[1] * h00(t) + y[2] * h01(t) +
         dx * (dy[1] * h10(t) + dy[2] * h11(t))
end


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
  hermiteint(t, r.t[i:i+1], r.u[i:i+1], [f(t[i], u[i], p), f(t[i+1], u[i+1], p)])
end

end # module Vaja16
