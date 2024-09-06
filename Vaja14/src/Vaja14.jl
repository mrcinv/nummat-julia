module Vaja14

import LinearAlgebra: eigen, eigvals, eigvecs, SymTridiagonal

export gauss_quad_rule, ndquad, simpson

simpson(fun, a, b, n) = (b-a)/(6n)*sum(fun.(LinRange(a, b, 2n+1)).*vcat([1], repeat([4,2], n-1), [4, 1]))

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
  n = length(x0);
  index = ones(Int, d)
  I = 0.;
  x = view(x0, index) # da se izognemo alokacijam spomina
  w = view(utezi, index)
  for i=1:n^d
    z = f(x)*prod(w)
    I += z
    next_index!(index, n)
  end
  return I
end

function next_index!(index, n)
  d = length(index)
  j = 1
  for i=1:d
    if index[i]<n
      index[i] += 1
      return
    else
      index[i] = 1
    end
  end
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
  du = zeros(n-1)
  d[1] = -b(1)/a(1)
  for i=2:n
    d[i] = -b(i)/a(i)
    du[i-1] = sqrt(c(i)/(a(i-1)*a(i)))
  end
  J = SymTridiagonal(d, du)
  F = eigen(J)
  x0 = eigvals(F)
  w = eigvecs(F)[1,:].^2*mu
  return x0, w
end

end # module Vaja14
