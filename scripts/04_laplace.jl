using Vaja04

# rp sin
rp = RobniProblemPravokotnik(
    Laplace(),           # operator
    ((0, pi), (0, pi)),  # pravokotnik 
    (sin, sin, sin, sin) # funkcije na robu
)
# rp sin

# sedlo
rp = RobniProblemPravokotnik(
    Laplace(),           # operator
    ((0, pi), (0, pi)),  # pravokotnik 
    (sin, sin, x->0, x->0) # funkcije na robu
)

U, x, y = resi(rp, 0.1)
using Plots
surface(x, y, U)
# sedlo
savefig("img/04_sedlo.svg")

# napolnitev
using LinearAlgebra
A = Vaja04.matrika(Laplace(), 10, 10)
p1 = spy(A.!=0, legend=false)
F = lu(A)
p2 = spy(F.L.!=0, legend=false)
spy!(p2, F.U.!=0, legend=false)
# napolnitev
savefig(p1, "img/04-spyA.svg")
savefig(p2, "img/04-spyLU.svg")
