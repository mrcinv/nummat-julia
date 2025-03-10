module Vaja16

export ZačetniProblem, RešitevNDE, resi, Euler, RK2, RK4, ničla

# Euler plain
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
    u0 += h * fun(t[i], u0)
    push!(u, u0)
  end
  return t, u
end
# Euler plain

# ZačetniProblem
"""
  zp = ZačetniProblem(f, u0 tint, p)

Podatkovna struktura s podatki za začetni problem za
navadne diferencialne enačbe (NDE) oblike:

```math
u'(t) = f(t, u, p).
```
Desna stran NDE je podana s funkcijo `f`, ki je odvisna od vrednosti `u`, `t` in
parametrov enačbe `p`. Začetni pogoj ``u(t0) = u_0`` je določen s poljem `u0`
v začetni točki intervala ``tint=[t0, t_k]``, na katerem iščemo rešitev.

## Atributi

* `f`: funkcija, ki izračuna odvod (desne strani NDE)
* `u0`: začetni pogoj
* `tint`: časovni interval za rešitev
* `p`: vrednosti parametrov enačbe
"""
struct ZačetniProblem{TU,TT,TP}
  f       # desne strani NDE u' = f(t, u, p)
  u0::TU  # začetna vrednost
  tint::Tuple{TT,TT}    # interval, na katerem iščemo rešitev
  p::TP       # parametri sistema
end
# ZačetniProblem

# RešitevNDE
"""
Podatkovna struktura, ki hrani približek za rešitev začetnega problema za NDE.
Uporablja se kot tip, ki ga vrnejo metode za reševanje začetnega problema.
"""
struct RešitevNDE{TU,TT,TP}
  zp::ZačetniProblem{TU,TT,TP} # referenca na začetni problem
  t::Vector{TT}  # vrednosti časa (argumenta)
  u::Vector{TU}  # približki za vrednosti rešitve
  du::Vector{TU} # izračunane vrednosti odvoda
end
# RešitevNDE

# Euler
abstract type ReševalecNDE end
"""
    Euler(n)

Parametri za Eulerjevo metodo za reševanje začetnega problema NDE s fiksnim
korakom. Edini parameter je `h`, ki je enak velikosti koraka Eulerjeve metode.
"""
struct Euler{T} <: ReševalecNDE
  h::T # dolžina koraka
end

function korak(m::Euler{T}, fun, t0::T, u0, par, smer=1) where {T}
  du = fun(t0, u0, par)
  h = smer * m.h
  return t0 + h, u0 + h * du, du
end
# Euler

# resi
"""
  r = resi(zp::ZačetniProblem, reševalec::TR) where {TR<:ReševalecNDE}

Reši začetni problem za NDE `zp` z danim reševalcem `reševalec`.

# Primer

Rešimo ZP za enačbo `u'(t) = -2t u` z začetnim pogojem `u(-0.5) = 1.0`:
```julia-repl
julia> fun(t, u, p) = -p * t * u;
julia> problem = ZačetniProblem(fun, 1., (-0.5, 1), 2);
julia> res = resi(problem, Euler(0.5)) # reši problem s korakom 0.5
```
"""
function resi(zp::ZačetniProblem{TU,TT,TP}, metoda::TM) where
{TU,TT,TP,TM<:ReševalecNDE}
  t0, tk = zp.tint
  u0 = zp.u0
  smer = sign(tk - t0)
  t = [t0]
  u = [u0]
  du = TU[]
  while smer * t0 < smer * tk
    t0, u0, du0 = korak(metoda, zp.f, t0, u0, zp.p, smer)
    push!(t, t0)
    push!(u, u0)
    push!(du, du0)
  end
  push!(du, zp.f(t[end], u[end], zp.p)) # odvod v zadnjem približku
  return RešitevNDE(zp, t, u, du)
end
# resi

# RK2
struct RK2{T} <: ReševalecNDE
  h::T # dolžina koraka
end

"""
Izračunaj en korak metode Runge-Kutta reda 2.
"""
function korak(m::RK2, fun, t0, u0, par, smer)
  h = smer * m.h
  du = fun(t0, u0, par)
  t = t0 + h
  k1 = h * du
  k2 = h * fun(t, u0 + k1, par)
  return t, u0 + (k1 + k2) / 2, du
end
# RK2

# RK4
struct RK4{T} <: ReševalecNDE
  h::T
end

function korak(res::RK4, fun, t0, u0, par, smer)
  h = smer * res.h
  du = fun(t0, u0, par)
  k1 = h * du
  k2 = h * fun(t0 + h / 2, u0 + k1 / 2, par)
  k3 = h * fun(t0 + h / 2, u0 + k2 / 2, par)
  k4 = h * fun(t0 + h, u0 + k3, par)
  return t0 + h, u0 + (k1 + 2(k2 + k3) + k4) / 6, du
end
# RK4

# RKadaptivna

"""
Izračunaj k-je pri metodi Runge-Kutta s koeficienti `a` in `c` in korakom `h`
za enačbo podano s funkcijo `fun(t, u, p)`, začetnimi pogoji `t0` in `u0` in
vrednostjo parametrov `p`.
"""
function rk_k(a, c, fun, t0, u0, h, par)
  k = [h * fun(t0 + c[1] * h, u0, par)]
  for i in 1:n
    du = a[i]' * k
    push!(k, h * fun(t0 + c[i+1] * h, u0 + du, par))
  end
  return k
end

# interpolacija
using Vaja12
"""
    y = vrednost(r, t)

Izračunaj vrednost rešitve `r` v točki `t`. Funkcija za izračun vrednosti
uporabi interpolacijo s Hermitovim zlepkom.
"""
function vrednost(r::RešitevNDE, t)
  z = Vaja12.HermitovZlepek(r.t, r.u, r.du)
  return Vaja12.vrednost(t, z)
end

# Omogočimo, da rešitev NDE kličemo kot funkcijo.
(res::RešitevNDE)(t) = vrednost(res, t)
# interpolacija

# ničla
function newton(fdf, x0, maxit=10, atol=1e-8)
  for _ in 1:maxit # Newtonova metoda
    z, dz = fdf(x0)
    dx = -z / dz
    x0 += dx
    if abs(dx) < atol
      return x0
    end
  end
  throw("Newtonova metoda ne konvergira po $maxit korakih!")
end

function ničla(res::RešitevNDE, fun, dfun, maxit=10, atol=1e-8)
  t, u = res.t, res.u
  i = ničla_interval(res, fun)
  function rhs(tk) # desne strani enačbe
    reševalec = RK4(tk - t[i])
    smer = sign(tk - t[i])
    t0, u0, du0 = korak(reševalec, res.zp.f, t[i], u[i], res.zp.p, smer)
    return fun(t0, u0, du0), dfun(t0, u0, du0)
  end
  newton(rhs, t[i], maxit, atol)
end

# ničla

# ničla_interval
function ničla_interval(res::RešitevNDE, fun)
  t, u, du = res.t, res.u, res.du
  n = length(t)
  for i in 1:n-1
    if fun(t[i], u[i], du[i]) * fun(t[i+1], u[i+1], du[i+1]) < 0
      return i
    end
  end
  throw("Ni intervala z ničlo")
end
# ničla_interval

end # module Vaja16
