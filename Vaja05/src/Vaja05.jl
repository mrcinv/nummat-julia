module Vaja05

# rbf
"""
    RBF(točke, uteži, phi)

Podatkovni tip za linearno kombinacijo *radialnih baznih funkcij* oblike
`phi(norm(x - točke[i])^2)`.
"""
struct RBF
  točke
  uteži
  phi
end
# rbf
# rbf vrednost
using LinearAlgebra
"""
    y = vrednost(x, rbf::RBF)

Izračunaj vrednost linearne kombinacije radialnih baznih funkcij
`rbf` v točki `x`.
"""
function vrednost(x, rbf::RBF)
  vsota = zero(x[1])
  n = length(rbf.točke)
  for i = 1:n
    norma = norm(rbf.točke[i] - x) # norma razlike
    vsota += rbf.uteži[i] * rbf.phi(norma) # utežena vsota
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

Poišči matriko sistema enačb za interpolacijo točk v seznamu `tocke`,
z linearno kombinacijo radialnih baznih funkcij s funkcijo oblike
`phi`.
"""
function matrika(točke, phi)
  n = length(točke)
  A = zeros(n, n)
  for i = 1:n, j = i:n
    A[i, j] = phi(norm(točke[i] - točke[j]))
    A[j, i] = A[i, j]
  end
  return A
end

"""
    rbf = interpoliraj(točke, vrednosti, phi)

Interpoliraj `vrednosti` v danih točkah s seznama `točke` z linearno
kombinacijo radialnih baznih funkcij s funkcijo oblike `phi`.
"""
function interpoliraj(točke, vrednosti, phi)
  A = matrika(točke, phi)
  F = cholesky!(A) # da prihranimo prostor, razcep naredimo kar v matriko A
  uteži = F \ vrednosti
  return RBF(točke, uteži, phi)
end
# interpolacija

export RBF, interpoliraj, vrednost
end # module Vaja05
