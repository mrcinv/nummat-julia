module Vaja04

# RPP
"""
    rp = RobniProblemPravokotnik(op, ((a, b), (c, d)), [fs, fz, fl, fd])

Ustvari objekt tipa `RobniProblemPravokotnik`, ki hrani podatke za robni problem
za diferencialni operator `op` na pravokotniku `[a, b] x [c, d]` z robnimi
pogoji podanimi s funkcijami `fs`, `fz`, `fl`, `fd`, ki določajo vrednosti na
robovih pravokotnika `y = c`, `y = d`, `x = a` in `x = b`.
"""
struct RobniProblemPravokotnik
  op # abstrakten podatkovni tip, ki opiše diferencialni operator
  meje # meje pravokotnika [a, b] x [c, d] v obliki [(a, b), (c, d)]
  rp # funkcije na robu [fs, fz, fl, fd] f(a, y) = fl(y), f(x, c) = fs(x), ...
end
# RPP

# Laplace
"""
    L = Laplace()

Ustvari abstrakten objekt tipa `Laplace`, ki predstavlja Laplaceov diferencialni
operator. 
"""
struct Laplace end
# Laplace

# matrika
using SparseArrays

laplace(n) = spdiagm(1 => ones(n - 1), 0 => -2 * ones(n), -1 => ones(n - 1))
enota(n) = spdiagm(0 => ones(n))

"""
    A = matrika(Laplace(), n, m)

Ustvari matriko za diskretizacijo Laplaceovega operatorja v 2 dimenzijah
na pravokotni mreži dimenzije` `n` krat `m`. 
"""
function matrika(_::Laplace, n, m)
  return kron(laplace(n), enota(m)) + kron(enota(n), laplace(m))
end
# matrika

# desne strani
"""
  U0, x, y = diskretiziraj(rp::RobniProblemPravokotnik, h)

Diskretiziraj robni problem na pravokotniku `rp` s korakom `h`.
"""
function diskretiziraj(rp::RobniProblemPravokotnik, h)
  (a, b), (c, d) = rp.meje
  m = Integer(floor((b - a) / h))
  n = Integer(floor((d - c) / h))
  U0 = zeros(n + 2, m + 2)
  fs, fz, fl, fd = rp.rp
  (a, b), (c, d) = rp.meje
  x = range(a, b, m + 2)
  y = range(c, d, n + 2)
  U0[1, :] = fl.(y)
  U0[end, :] = fd.(y)
  U0[:, 1] = fs.(x)
  U0[:, end] = fz.(x)
  return U0, x, y
end

function desne_strani(U0)
  return -vec(U0[2:end-1, 1:end-2] + U0[2:end-1, 3:end] +
              U0[1:end-2, 2:end-1] + U0[3:end, 2:end-1])
end
# desne strani

# resi
"""
    U, x, y = resi(rp, h, metoda)

Poišči rešitev robnega problema na pravokotniku na pravokotni mreži z razmikom
`h` med posameznimi vozlišči v obeh dimenzijah.
"""
function resi(rp::RobniProblemPravokotnik, h)
  U, x, y = diskretiziraj(rp, h)
  n = length(x) - 2
  m = length(y) - 2
  A = matrika(L, n, m)
  d = desne_strani(U)
  res = A \ d  # reši sistem             
  U[2:end-1, 2:end-1] = reshape(res, n, m) # preoblikuj rešitev v matriko
  return U, x, y
end
# resi

# jacobi
"""
    U = korak_jacobi(U0)

Izvedi en korak Jacobijeve iteracije za Laplaceovo enačbo. Matrika `U0` vsebuje 
približke za vrednosti funkcije na mreži, funkcija vrne naslednji približek. 
"""
function korak_jacobi(U0)
  U = copy(U0)
  m, n = size(U)
  # spremenimo le notranje vrednosti
  for i = 2:m-1
    for j = 2:n-1
      # Jacobi
      U[i, j] = (U0[i+1, j] + U0[i, j+1] + U0[i-1, j] + U0[i, j-1]) / 4
    end
  end
  return U
end
# jacobi

# gs
"""
    U = korak_gs(U0)

Izvedi en korak Gauss-Seidlove iteracije za Laplaceovo enačbo. Matrika `U0`
vsebuje približke za vrednosti funkcije na mreži. 
"""
function korak_gs(U0)
  U = copy(U0)
  m, n = size(U)
  # spremenimo le notranje vrednosti
  for i = 2:m-1
    for j = 2:n-1
      # Gauss Seidel
      U[i, j] = (U[i+1, j] + U[i, j+1] + U[i-1, j] + U[i, j-1]) / 4
    end
  end
  return U
end
# gs

# sor
"""
    U = korak_sor(U0, ω)

Izvedi en korak SOR iteracije za Laplaceovo enačbo. Matrika `U0` vsebuje 
približke za vrednosti funkcije na mreži, funkcija vrne naslednji približek. 
"""
function korak_sor(U0, ω)
  U = copy(U0)
  m, n = size(U)
  # spremenimo le notranje vrednosti
  for i = 2:m-1
    for j = 2:n-1
      # Gauss Seidel
      U[i, j] = (U[i+1, j] + U[i, j+1] + U[i-1, j] + U[i, j-1]) / 4
      U[i, j] = (1 - ω) * U0[i, j] + ω * U[i, j] # SOR popravek
    end
  end
  return U
end
# sor


# iteracija
"""
  x, it = iteracija(korak, x0; maxit=maxit, atol=atol)

Poišči približek za limito rekurzivnega zaporedja podanega rekurzivno s 
funkcijo `korak` in začentim členom `x0`.
"""
function iteracija(korak, x0; maxit=1000, atol=1e-8)
  for i = 1:maxit
    x = korak(x0)
    if isapprox(x, x0, atol=atol)
      return x, i
    end
    x0 = x
  end
  throw("Iteracija ne konvergira po $maxit korakih!")
end
# iteracija

# resi iteracija
"""
  SOR(ω)

Podatkovni tip, ki predstavlja SOR iteracijo za dani parameter `ω`.
"""
struct SOR
  ω
end

"""
    U, x, y = resi(rp, h, metoda)

Poišči rešitev robnega problema na pravokotniku na pravokotni mreži z razmikom
`h` med posameznimi vozlišči v obeh dimenzijah.
"""
function resi(rp::RobniProblemPravokotnik, h, sor::SOR)
  U, x, y = diskretiziraj(rp, h)
  U, _ = iteracija(U -> korak_sor(U, sor.ω), U) # reši sistem
  return U, x, y
end
# resi iteracija

export RobniProblemPravokotnik, Laplace, matrika, resi

end # module Vaja04
