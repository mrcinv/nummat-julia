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
function diskretiziraj(rp::RobniProblemPravokotnik, n, m)
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
    U, x, y = resi(rp, h)

Poišči rešitev robnega problema na pravokotniku na pravokotni mreži z razmikom
`h` med posameznimi vozlišči v obeh dimenzijah.
"""
function resi(rp::RobniProblemPravokotnik, h)
    (a, b), (c, d) = rp.meje
    m = Integer(floor((b - a) / h))
    n = Integer(floor((d - c) / h))
    A = matrika(rp.op, n, m)
    U, x, y = diskretiziraj(rp, n, m)
    d = desne_strani(U)
    res = A \ d  # reši sistem             
    U[2:end-1, 2:end-1] = reshape(res, n, m) # preoblikuj rešitev v matriko
    return U, x, y
end
# resi

export RobniProblemPravokotnik, Laplace, matrika, resi

end # module Vaja04
