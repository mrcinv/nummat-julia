using Vaja07
using BookUtils
# konj
P = prehodna_matrika(Konj(8, 8))

x, it = potencna(P', rand(64))
# konj
using LinearAlgebra
capture("07_lastne") do
  # lastne
  # funkcija `eigen` iz modula LinearAlgebra izračuna lastni razcep matrike
  lambda, v = eigen(Matrix(P'))
  # lambda ima tudi imaginarne komponente, ki pa so zanemarljivo majhne
  lambda = real.(lambda)
  println("Največja in najmanjša lastna vrednost matrike P':")
  println("$(maximum(lambda)),  $(minimum(lambda))")
  # lastne
end

# premik

x, it = potencna(P' + I, rand(64))
x = x / sum(x) # vrednosti normiramo, da je vsota enaka 1
porazdelitev = reshape(x, 8, 8)

using Plots
heatmap(porazdelitev, aspect_ratio=1, xticks=1:8, yticks=1:8)
# premik
savefig("img/07-konj.svg")