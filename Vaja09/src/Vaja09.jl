module Vaja09

# newton
using LinearAlgebra
"""
    x, it = newton(f, jf, x0)

Poišči rešitev sistema nelinearnih enačb `f(x) = 0` z Newtonovo metodo.
Argument `jf` je funkcija, ki vrne Jacobijevo matriko funkcije`f`.
Argument `x0`je začetni približek za Newtonovo metodo.
"""
function newton(f, jf, x0; maxit=100, atol=1e-8)
  for i = 1:maxit
    x = x0 - jf(x0) \ f(x0)
    if norm(x - x0, Inf) < atol
      return x, i
    end
    x0 = x
  end
  throw("Metoda ne konvergira po $maxit korakih!")
end
# newton

# box2d
"Podatkovna struktura za interval"
struct Interval
  min
  max
end

"Ali interval `I` vsebuje točko `x`?"
vsebuje(x, I::Interval) = x >= I.min && x <= I.max

"""
Podatkovna struktura za pravokotnik, vzporeden s koordinatnimi osmi (škatla).
Pravokotnik je podan kot produkt dveh intervalov za spremenljivki `x` in `y`.
"""
struct Box2d
  int_x
  int_y
end

"Ali škatla `b` vsebuje dano točko `x`?"
vsebuje(x, b::Box2d) = vsebuje(x[1], b.int_x) && vsebuje(x[2], b.int_y)

"""
  x = diskretiziraj(I, n)

Razdeli interval `I` na `n` enakih podintervalov. Vrni seznam krajišč
podintervalov.
"""
diskretiziraj(I::Interval, n) = range(I.min, I.max, n)

"""
  x = diskretiziraj(b, m, n)

Razdeli škatlo `b` na manjše škatle. Vrni seznama krajišč
podintervalov v smereh `x` in `y`.
"""
diskretiziraj(b::Box2d, m, n) = (
  diskretiziraj(b.int_x, m), diskretiziraj(b.int_y, n))

# box2d
# konvergenca
"""
    x, y, Z, ničle, koraki = konvergenca(območje, metoda, n=50, m=50; maxit=50, tol=1e-3)

Izračunaj, h katerim vrednostim konvergira metoda `metoda`, če uporabimo različne
začetne približke na pravokotniku `[a, b]x[c, d]`, podanim z argumentom `območje`.

Funkcija vrne:
- seznam krajišč podintervalov v x smeri,
- seznam krajišč podintervalov v y smeri,
- matriko z indeksi ničle, h kateri metoda konvergira,
- seznam ničel na izbranem območju,
- matriko s številom korakov, ki jih metoda potrebuje, da najde ničlo.

# Primer
Konvergenčno območje za Newtonovo metodo za reševanje
kompleksne enačbe ``z^3=(x + i y) ^3 = 1``

```jl
F((x, y)) = [x^3-3x*y^2-1; 3x^2*y-y^3];
JF((x, y)) = [3x^2-3y^2 -6x*y; 6x*y 3x^2-3y^2]
metoda(x0) = newton(F, JF, x0; maxit=10; tol=1e-3);
območje = Box2d(Interval(-2, 2), (-1, 1))
x, y, Z, ničle, koraki = konvergenca(območje, metoda; n=5, m=5)
```
"""
function konvergenca(območje::Box2d, metoda, m=50, n=50; atol=1e-3)
  Z = zeros(m, n)
  koraki = zeros(m, n)
  x, y = diskretiziraj(območje, n, m)
  ničle = []
  for i = 1:n, j = 1:m
    z = [x[i], y[j]]
    it = 0
    try
      z, it = metoda(z)
    catch
      continue
    end
    k = findfirst([norm(z - z0, Inf) < 2atol for z0 in ničle])
    if isnothing(k)
      if vsebuje(z, območje)
        push!(ničle, z)
        k = length(ničle)
      else
        continue
      end
    end
    Z[j, i] = k # vrednost elementa je enaka indeksu ničle
    koraki[j, i] = it # število korakov metode
  end
  return x, y, Z, ničle, koraki
end
# konvergenca


export newton, konvergenca, Interval, Box2d, vsebuje, diskretiziraj
end # module Vaja09
