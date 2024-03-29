#' # Geronova lemniskata
#' Komentarji, ki se začnejo s `#'` se prevedejo v Markdown in 
#' v PDF dokumentu nastopajo kot tekst.
using Vaja00
#' Krivuljo narišemo tako, da koordinati tabeliramo za veliko število parametrov. 
t = range(-5, 5, 300) # generiramo zaporedje 300 vrednosti na [-5, 5]
x = lemniskata_x.(t) # funkcijo apliciramo na elemente zaporedja
y = lemniskata_y.(t) # tako da imenu funkcije dodamo .
#' Za risanje grafov uporabimo paket `Plots`.
using Plots
plot(x, y, label=false, title="Geronova lemniskata")
#' Zadnji rezultat pred tekstom se izpiše v dokument. Če je rezultat 
#' tipa, ki predstavlja plot, se v dokument vstavi slika.
savefig("img/01_demo.svg")

