module Vaja10

using Vaja09
export samopres, razdalja2
# samopres
"""
    ts, it = samopres(k, dk, ts0)

Poišči samopresečišče krivulje `k` s smernim odvodom `dk` z Newtonovo metodo z
začetnim približkom `ts0`. Začetni približek `ts0` in rezultat `ts` sta
dvodimenzionalna vektorja z dvema različnima parametroma.
# Primer
```jl
k(t) = [t^2, t^3-t]
dk(t) = [2t, 3t^2-1]
ts, it = samopres(k, dk, [-0.5, 0.5])
```
"""
function samopres(k, dk, ts0)
  f(ts) = k(ts[1]) - k(ts[2])
  df(ts) = hcat(dk(ts[1]), -dk(ts[2]))
  ts, it = newton(f, df, ts0)
  ts = sort(ts)
  if abs(ts[1] - ts[2]) < 1e-12
    throw("Ista parametra ne pomenita samopresečišča.")
  end
  return ts, it
end
# samopres

# razdalja2
using LinearAlgebra

"""
  d2 = razdalja2(k1, k2)

Vrni funkcijo kvadrata razdalje `d2(t, s)` med točkama na krivuljah
`k1` in `k2`. Rezultat `d2` je funkcija spremenljivk `t` in `s`, kjer sta
`t` parameter na krivulji `k1` in `s` parameter na krivulji `k2`.
# Primer
```jl
k1(t) = [t, t^2 - 2]
k2(s) = [cos(s), sin(s)]
d2 = razdalja(k1, k2)
d2(1, pi)
```
"""
function razdalja2(k1, k2)
  function d2(t, s)
    delta = k1(t) - k2(s)
    return dot(delta, delta)
  end
  return d2
end
# razdalja2


# grad
"""
    x0, it = spust(gradf, x0, h)

Poišči lokalni minimum za funkcijo, podano z gradientom `gradf`, z metodo
najhitrejšega spusta. Argument `x0` je začetni približek, `h` skalar s
katerim pomnožimo gradient.
"""
function spust(gradf, x0, h; maxit=500, atol=1e-8)
  for i = 1:maxit
    x = x0 - h * gradf(x0)
    if norm(x0 - x) < atol
      return x, i
    end
    x0 = x
  end
  throw("Gradientni spust ne konvergira po $maxit korakih!")
end
# grad

end # module Vaja10
