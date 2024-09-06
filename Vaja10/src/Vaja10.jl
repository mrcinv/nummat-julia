module Vaja10

using Vaja09
export samopres
# samopres
"""
    ts, it = samopres(k, dk, ts0)

Poišči samopresečišče krivulje `k` s smernim odvodom `dk` z Newtonovo metodo z začetnim
približkom `ts0`. Začetni približek `ts0` in rezultat `ts` sta dvodimenzionalna vektorja z dvema
različnima parametroma.
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

# grad
function spust(fdf)
end
# grad

end # module Vaja10
