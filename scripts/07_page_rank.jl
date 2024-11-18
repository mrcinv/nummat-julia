using Vaja07
using BookUtils

# splet 1
P = [
  0 1/3 0 1/3 0 1/3;
  0 0 1/2 1/2 0 0;
  0 0 0 1/2 1/2 0;
  1/2 0 1/2 0 0 0;
  0 0 0 0 0 1;
  0 1 0 0 0 0
]
x, it = potencna(P', rand(6))
# splet 1
# splet 2
delta = P' * x - x
# splet 2
term("07_splet", delta)
# splet 3
x = x / sum(x)
using Plots
bar(x, label=false)
# splet 3
savefig("img/07-rang.svg")
# skakač
P = prehodna_matrika(Skakač(8, 8))

x, it = potencna(P', rand(64))
# skakač
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
