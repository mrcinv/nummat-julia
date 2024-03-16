# 01demo
#' # Geronova lemniskata
using Vaja00
#' Krivuljo narišemo tako, da koordinati tabeliramo za veliko število parametrov. 
t = range(-5, 5, 300) # generiramo zaporedje 300 vrednosti na [-5, 5]
x = lemniskata_x.(t) # funkcijo apliciramo na elemente zaporedja
y = lemniskata_y.(t) # tako da imenu funkcije dodamo .
#' Za risanje grafov uporabimo paket `Plots`.
using Plots
plot(x, y, label=false, title="Geronova lemniskata")
# 01demo
savefig("img/01_demo.svg")