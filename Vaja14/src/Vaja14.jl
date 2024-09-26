module Vaja14
using Vaja13
import LinearAlgebra: eigen, eigvals, eigvecs, SymTridiagonal

export VeckratniIntegral, integriraj, volumen, simpson, MonteCarlo
# simpson
simpson(a, b, n) = Kvadratura(collect(LinRange(a, b, 2n + 1)),
  (b - a) / (6 * n) * vcat([1.0], repeat([4, 2], n - 1), [4, 1]), Interval(a, b))
# simpson

# VeckratniIntegral
struct VeckratniIntegral{T,TI}
  fun # funkcija, ki jo integriramo
  box::Vector{Interval{T}}
end

dim(i::VeckratniIntegral) = length(i.box)
# VeckratniIntegral

# preslikaj
import Vaja13: preslikaj, dolzina
"""
  kvad2 = preslikaj(kvad1::Kvadratura{T}, interval::Interval{T})
  
Preslikaj kvadraturo `kvad1` na drug `interval`.
"""
function preslikaj(kvad::Kvadratura{T}, interval::Interval{T}) where {T}
  x = map(x -> preslikaj(x, kvad.interval, interval), kvad.x)
  u = dolzina(interval) / dolzina(kvad.interval) * kvad.u
  return Kvadratura(x, u, interval)
end
# preslikaj

import Vaja13: integriraj
# integriraj
"""
  I = integriraj(int::VeckratniIntegral{T, TI}, kvad::Kvadratura{T})

Integriraj veckratni `int` s produktno kvadraturo, ki je podana kot produkt
enodimenzionalne kvadrature `kvad`.

# Primer
```jldoctest
int = VeckratniIntegral{Float64, Float64}(
  x -> x[1] - x[2], [Interval(0., 2.), Interval(-1., 2.)]);
kvad = Kvadratura([0.5], [1.0], Interval(0.0, 1.0)); # sredinsko pravilo
integriraj(int, kvad)

# output

3.0
```
"""
function integriraj(
  int::VeckratniIntegral{T,TI}, kvad::Kvadratura{T}) where {T,TI}
  # kvadrature preslikamo pred glavno zanko
  kvadrature = [preslikaj(kvad, interval) for interval in int.box]
  d = dim(int)
  index = ones(Int, d)
  n = length(kvad.x)
  x = zeros(T, d) # alociramo vektorja vozlišč in uteži pred zanko
  w = zeros(T, d)
  I = zero(TI)
  for _ in 1:n^d
    for j in eachindex(x)
      kvad = kvadrature[j]
      x[j] = kvad.x[index[j]]
      w[j] = kvad.u[index[j]]
    end
    z::TI = int.fun(x)
    I += z * prod(w)
    naslednji!(index, n)
  end
  return I
end
# integriraj
# naslednji!
"""
  naslednji!(index, n)

Izračunanj naslednji multi index v zaporedju vseh multi indeksov 
``\\{1, 2, ... n\\}^d`` in ga zapiši v vektor `index`.
"""
function naslednji!(index, n)
  d = length(index)
  for i = 1:d
    if index[i] < n
      index[i] += 1
      return
    else
      index[i] = 1
    end
  end
end
# naslednji!
# mc
volumen(box::Vector{Interval{T}}) where {T} = prod(dolzina.(box))

struct MonteCarlo
  rng
  n::Int
end

function integriraj(int::VeckratniIntegral{T,TI}, mc::MonteCarlo) where {T,TI}
  I = zero(TI)
  x = zeros(T, dim(int))
  for _ in 1:mc.n
    for i in eachindex(x)
      x[i] = preslikaj(rand(mc.rng), int.box[i], Interval(0.0, 1.0))
    end
    z::TI = int.fun(x)
    I += z
  end
  return volumen(int.box) * I / mc.n
end
# mc

"""
    I = ndquad(f, x0, utezi, d)

izračuna integral funkcije `f` na d-dimenzionalni kocki ``[a,b]^d``
z večkratno uporabo enodimenzionalne kvadrature za integral na
intervalu ``[a,b]``, ki je podana z utežmi `utezi` in vozlišči `x0`.

# Primer
```jldoctest
julia> f(x) = x[1] + x[2]; #f(x,y)=x+1;
julia> utezi = [1,1]; x0 = [0.5, 1.5]; #sestavljeno sredinsko pravilo
julia> ndquad(f, x0, utezi, 2)
8.0
```
"""
function ndquad(f, x0, utezi, d)
  # število vozlišč
  n = length(x0)
  index = ones(Int, d)
  I = 0.0
  x = view(x0, index) # da se izognemo alokacijam spomina
  w = view(utezi, index)
  for i = 1:n^d
    z = f(x) * prod(w)
    I += z
    naslednji!(index, n)
  end
  return I
end

"""
    x, w = gauss_quad_rule(a, b, c, mu, n)

Izračuna uteži `w` in vozlišča `x` za
[Gaussove kvadraturne formule](https://en.wikipedia.org/wiki/Gaussian_quadrature)
za integral

```math
\\int_a^b f(x)w(x)dx \\simeq w_1f(x_1)+\\ldots w_n f(x_n)
```

z Golub-Welshovim algoritmom.

Parametri `a`, `b` in `c` so funkcije `n`, ki določajo koeficiente v tročlenski
rekurzivni formuli za ortogonalne polinome na intervalu ``[a,b]`` z utežjo `w(x)`

```math
p_n(x) = (a(n)x+b(n))p_{n-1}(x) - c_n p_{n-2}(x)
```

`mu` je vrednost integrala uteži na izbranem intervalu

```math
\\mu = \\int_a^b w(x)dx
```

# Primer
za računanje integrala z utežjo ``w(x)=1`` na intervalu ``[-1,1]``, lahko uporabimo
[Legendrove ortogonalne polinome](https://sl.wikipedia.org/wiki/Legendrovi_polinomi),
ki zadoščajo rekurzivni zvezi

```math
p_{n+1}(x) = \\frac{2n+1}{n+1}x p_n(x) -\\frac{n}{n+1} p_{n-1}
```

Naslednji program izpiše vozlišča in uteži za n od 1 do 5

```julia
a(n) = (2*n-1)/n; b(n) = 0.0; c(n) = (n-1)/n;
μ = 2;
println("Gauss-Legendrove kvadrature")
for n=1:5
  x0, w = gauss_quad_rule(a, b, c, μ, n);
  println("n=\$n")
  println("vozlišča: ", x0)
  println("uteži: ", w)
end
```
"""
function gauss_quad_rule(a, b, c, mu, n)
  d = zeros(n)
  du = zeros(n - 1)
  d[1] = -b(1) / a(1)
  for i = 2:n
    d[i] = -b(i) / a(i)
    du[i-1] = sqrt(c(i) / (a(i - 1) * a(i)))
  end
  J = SymTridiagonal(d, du)
  F = eigen(J)
  x0 = eigvals(F)
  w = eigvecs(F)[1, :] .^ 2 * mu
  return x0, w
end
"""
  x0, w0 = gauss_legendre_rule(n)

Izračunaj vozlišča in uteži za Gauss-Legendrove kvadrature z Golub-Welschovim
algoritmom.
"""
function gauss_legendre_rule(n)
  a(n) = (2 * n - 1) / n
  b(n) = 0.0
  c(n) = (n - 1) / n
  return gauss_quad_rule(a, b, c, 2, n)
end
end # module Vaja14
