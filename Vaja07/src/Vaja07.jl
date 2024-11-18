module Vaja07
# potencna
using LinearAlgebra

"""
    x, it = potencna(A)

Poišči lastni vektor matrike `A` za največjo lastno vrednost s potenčno metodo.
"""
function potencna(A, x0; atol=1e-8, maxit=1000)
  for i = 1:maxit
    x = A * x0
    x = x / norm(x, Inf)
    if norm(x - x0, Inf) < atol
      return x, i
    end
    x0 = x
  end
  throw("Potenčna metoda ne konvergira po $maxit korakih!")
end
# potencna

# indeksi
ij_v_k(i, j, n) = i + (j - 1) * n

function k_v_ij(k, m)
  j, i = divrem(k - 1, m)
  return (i + 1, j + 1)
end
# indeksi

# skakač
"""
  Skakač(m, n)

Podatkovna struktura, ki označuje Markovsko verigo za skakača na šahovnici
dimenzije `m` x `n`.
"""
struct Skakač
  m
  n
end
# skakač
# prehodna_matrika
using SparseArrays
"""
  P = prehodna_matrika(k::Skakač)

Poišči prehodno matriko za Markovsko verigo, ki opisuje skanje figure skakača po
šahovnici.
"""
function prehodna_matrika(skakač::Skakač)
  m = skakač.m
  n = skakač.n
  N = m * n
  P = spzeros(N, N)
  skoki = [(1, 2), (2, 1), (-1, 2), (-2, 1),
    (1, -2), (2, -1), (-1, -2), (-2, -1)]
  for k = 1:N
    i0, j0 = k_v_ij(k, m)
    for skok in skoki
      i = i0 + skok[1]
      j = j0 + skok[2]
      if i >= 1 && i <= m && j >= 1 && j <= n
        k1 = ij_v_k(i, j, m)
        P[k, k1] = 1
      end
    end
    P[k, :] /= sum(P[k, :]) # normiramo vrstico, da je vsota enaka 1
  end
  return P
end
# prehodna_matrika

export potencna, Skakač, prehodna_matrika


end # module Vaja07
