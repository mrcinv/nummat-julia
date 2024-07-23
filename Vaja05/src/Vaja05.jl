module Vaja05

# rbf
"""
    RBF(tocke, utezi, phi)

Podatkovni tip za linearno kombinacijo *radialnih baznih funkcij* oblike
`phi(norm(x - tocke[i])^2)`.
"""
struct RBF
  tocke
  utezi
  phi
end
# rbf
# rbf vrednost
using LinearAlgebra
"""
    y = vrednost(x, rbf::RBF)

Izračunaj vrednost linearne kombinacije radialnih baznih funkcij podane z 
`rbf` v točki `x`.
"""
function vrednost(x, rbf::RBF)
  vsota = zero(x[1])
  n = length(rbf.tocke)
  for i = 1:n
    norma = norm(rbf.tocke[i] - x) # norma razlike
    vsota += rbf.utezi[i] * rbf.phi(norma) # utežena vsota
  end
  vsota
end
"""
    rbf::RBF(x)

Izračunaj vrednost linearne kombinacije radialnih baznih funkcij `rbf`` v dani
točki `x`.
"""
(rbf::RBF)(x) = vrednost(x, rbf)
# rbf vrednost

# interpolacija
"""
    A = matrika(tocke, phi)

Poišči matriko sistema enačb za interpolacijo točk podanih v seznamu `tocke`
z linearno kombinacijo radialnih baznih funkcij s funkcijo oblike
`phi`.
"""
function matrika(tocke, phi)
  n = length(tocke)
  A = zeros(n, n)
  for i = 1:n, j = i:n
    A[i, j] = phi(norm(tocke[i] - tocke[j]))
    A[j, i] = A[i, j]
  end
  return A
end

"""
    rbf = interpoliraj(tocke, vrednosti, phi)

Interpoliraj `vrednosti` v danih točkah iz seznama `tocke` z linearno
kombinacijo radialnih baznih funkcij s funkcijo oblike `phi`. 
"""
function interpoliraj(tocke, vrednosti, phi)
  A = matrika(tocke, phi)
  F = cholesky!(A) # da prihranimo prostor, razcep naredimo kar v matriko A
  utezi = F \ vrednosti
  return RBF(tocke, utezi, phi)
end
# interpolacija

export RBF, interpoliraj, vrednost
end # module Vaja05
