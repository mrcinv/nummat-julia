using Vaja04

# rp sin
rp = RobniProblemPravokotnik(
  Laplace(),           # operator
  ((0, 1.5pi), (0, pi)),  # pravokotnik
  (x -> 0, x -> 0, sin, sin) # funkcije na robu
)
# rp sin

# sedlo
U, x, y = resi(rp, 0.1)
using Plots
surface(x, y, U)
# sedlo
savefig("img/04_sedlo.svg")

# napolnitev
using LinearAlgebra
A = Vaja04.matrika(Laplace(), 10, 10)
p1 = spy(A .!= 0, legend=false) # na grafu prikažemo neničelne elemente
F = lu(A)
p2 = spy(F.L .!= 0, legend=false) # neničelni elemnti za faktor L
spy!(p2, F.U .!= 0, legend=false) # in za faktor U
# napolnitev
savefig(p1, "img/04-spyA.svg")
savefig(p2, "img/04-spyLU.svg")

# lu
A = [1 2; 3 4]
b = [1, 1]
F = lu(A) # F je tipa LU,
x = F \ b # ki ga lahko uporabimo za rešitev sistema
# lu

# konvergenca jacobi 0
U0, x, y = Vaja04.diskretiziraj(rp, 0.1)
wireframe(x, y, U0, legend=false, title="\$ k=0\$")
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
ω = range(0.7, 1.99, 100)
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
  U = Vaja04.korak_sor(U, 1)
  surface(x, x, U, title="Konvergenca Gauss-Seidlove iteracije")
  frame(animation)
end
mp4(animation, "konvergenca.mp4", fps=10)
# animacija
