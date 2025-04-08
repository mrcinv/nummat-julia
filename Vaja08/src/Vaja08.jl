module Vaja08

using LinearAlgebra, SparseArrays
export inviter, inviterqr, graf_eps, laplace

# inviter
"""
    v, lambda = inviter(resi, x0)

Poišči lastno vrednost `lambda` in lastni vektor `v` za matriko z inverzno iteracijo.
Argument `resi` je funkcija, ki za dani vektor `b` poišče rešitev sistema `Ax=b`.
Argument `x0` je začetni približek.

# Primer

```jl
A = [3 1 1; 1 1 3; 1 3 4]
F = lu(A)
resi(b) = F \\ b
v, lambda = inviter(resi, [1., 1., 1.])
```
"""
function inviter(resi, x0, maxit=100, tol=1e-10)
  # poiščemo po absolutni največji element v x0
  ls, index = findmax(abs, x0)
  ls = x0[index]
  x = x0 / ls # normiramo, da je največji element enak 1
  for i = 1:maxit
    x = resi(x) # poišči rešitev sistema Ay = x
    ln, index = findmax(abs, x)
    ln = x[index]
    x = x / ln # x normiramo, da je največji element enak 1
    if abs(ln - ls) < tol
      println("Inverzna potenčna metoda se je končala po $i korakih.")
      return x, 1 / ln
    end
    ls = ln
  end
  throw("Inverzna potenčna metoda ne konvergira v $maxit korakih.")
end
# inviter

# inviterqr
"""
    x, lambda = inviterqr(resi, x0)

Poišči nekaj najmanjših lastnih vrednosti in lastnih vektorjev z inverzno iteracijo
s QR razcepom.
Argument `resi` je funkcija, ki za dani vektor `b` poišče rešitev sistema `Ax=b`.
Argument `x0` je matrika začetnih približkov. Toliko kot je stolpcev v matriki
`x0`, toliko lastnih parov vrne funkcija.
"""
function inviterqr(resi, x0, maxit=100, tol=1e-10)
  _, m = size(x0)
  x = x0
  ls = Inf * ones(m)
  for i = 1:maxit
    x = resi(x) # poišči rešitev sistema Ay = x
    Q, R = qr(x)
    x = Matrix(Q)
    ln = diag(R) # lastne vrednosti A^(-1) so na diagonali R
    if norm(ln - ls, Inf) < tol
      println("Inverzna iteracija s QR razcepom se je končala po $i korakih.")
      return x, 1 ./ ln
    end
    ls = ln
  end
  throw("Inverzna iteracija s QR razcepom ne konvergira v $maxit korakih.")
end
# inviterqr

# graf_eps
"""
    A = graf_eps(oblak, epsilon)

Poišči podobnostni graf ε okolic za dani oblak točk.
Argument `oblak` je `k x n` matrika, katere stolpci so koordinate točk v oblaku.
Funkcija vrne matriko sosednosti A za podobnostni graf.
"""
function graf_eps(oblak, epsilon)
  _, n = size(oblak)
  A = spzeros(n, n)
  for i = 1:n
    for j = i+1:n
      if norm(oblak[:, i] - oblak[:, j]) < epsilon
        A[i, j] = 1
        A[j, i] = 1
      end
    end
  end
  return A
end
# graf_eps

# laplace
"""
  L = laplace(A)

Poišči Laplaceovo matriko za dani graf, podan z matriko sosednosti `A`.
Laplaceova matrika grafa ima na diagonali stopnje točk, izven diagonale
pa vrednosti -1 ali 0, odvisno, ali sta indeksa povezana v grafu ali ne.
"""
laplace(A) = spdiagm(vec(sum(A, dims=2))) - A
# laplace

# cgmat
import Vaja06: cg
"""
  X = cgmat(A, B)

Poišči rešitev matričnega sistema `A X = B` z metodo konjugiranih gradientov.
"""
function cgmat(A, B)
  _, m = size(B)
  X = copy(B)
  for i = 1:m
    X[:, i] = cg(A, B[:, i])
  end
  return X
end
# cgmat
end # module Vaja08
