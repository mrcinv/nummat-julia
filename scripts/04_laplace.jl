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
  (sin, sin, x -> 0, x -> 0) # funkcije na robu
)

U, x, y = resi(rp, 0.1)
using Plots
surface(x, y, U)
# sedlo
savefig("img/04_sedlo.svg")

# napolnitev
using LinearAlgebra
A = Vaja04.matrika(Laplace(), 10, 10)
p1 = spy(A .!= 0, legend=false)
F = lu(A)
p2 = spy(F.L .!= 0, legend=false)
spy!(p2, F.U .!= 0, legend=false)
# napolnitev
savefig(p1, "img/04-spyA.svg")
savefig(p2, "img/04-spyLU.svg")

# konvergenca jacobi 0
U0, x, y = Vaja04.diskretiziraj(rp, 0.1)
wireframe(x, y, U, legend=false, title="\$ k=0\$")
# konvergenca jacobi 0
savefig("img/04-konv-0.svg")
# konvergenca jacobi 10
U = U0
for i = 1:10
  U = Vaja04.korak_gs(U)
end
wireframe(x, y, U, legend=false, title="\$k=10\$")
# konvergenca jacobi 10
savefig("img/04-konv-10.svg")
# konvergenca jacobi 50
U = U0
for i = 1:50
  U = Vaja04.korak_gs(U)
end
wireframe(x, y, U, legend=false, title="\$k=50\$")
# konvergenca jacobi 50
savefig("img/04-konv-50.svg")
# konvergenca jacobi oo
U, it = Vaja04.iteracija(Vaja04.korak_gs, U0; atol=1e-3)
wireframe(x, y, U, legend=false, title="\$k=$it\$")
# konvergenca jacobi oo
savefig("img/04-konv-oo.svg")

# konvergenca sor
ω = range(0.6, 1.99, 100)
koraki = Vector{Float64}()
for ω_i in ω
  _, k = Vaja04.iteracija(U -> Vaja04.korak_sor(U, ω_i), U0; atol=1e-3)
  push!(koraki, k)
end
plot(ω, koraki, label=false, ylabel="št. korakov", xlabel="\$\\omega\$")
# konvergenca sor
savefig("img/04-konv-sor.svg")

# animacija
animation = Animation()
for i = 1:200
  U = korak_sor(L, U)
  surface(x, x, U, title="Konvergenca Gauss-Seidlove iteracije")
  frame(animation)
end
mp4(animation, "konvergenca.mp4", fps=10)
# animacija