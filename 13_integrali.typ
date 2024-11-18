#import "admonitions.typ": opomba
#import "julia.typ": code_box, jl, jlfb

= Integrali

Za numerični izračun določenega integrala funkcije $f(x)$ na intervalu $[a, b]$
$
  integral_(a)^(b) f(x) d x
$
obstaja veliko različnih metod. V tej vaji si bomo ogledali kako izbrati primerno metodo,
glede na to, kakšno funkcijo integriramo.

== Naloga

- Definiraj podatkovni tip, ki predstavlja določeni integral funkcije na danem intervalu.
- Definiraj podatkovni tip #jl("Kvadratura"), ki hrani podatke o utežeh in vozliščih
  za dano kvadraturo na danem intervalu.
- Implementiraj funkcijo #jl("integriraj(integral, ::Kvadratura)"), ki z dano kvadraturo izračuna
  integral.
- Implementiraj sestavljeno trapezno, sestavljeno Simpsonovo, Gauss-Legendrove kvadrature in
  adaptivno Simpsonovo metodo. Za izračun uteži in vozlišč Gauss-Legendrovih kvadratur uporabi paket
  #link("https://juliaapproximation.github.io/FastGaussQuadrature.jl/stable/")[FastGaussQuadrature.jl].
- Implementirane metode uporabi za izračun naslednjih integralov
  $
    integral_0^3 sin(x) d x quad #text[ in ] quad integral_(-1)^2 |2 - x^2| d x.
  $
  Napako oceni tako, da rezultat primerjaš z rezultatom, ki ga dobiš, če uporabiš dvakrat več
  vozlišč in uporabiš
  #link("https://en.wikipedia.org/wiki/Richardson_extrapolation")[Richardsonovo ekstrapolacijo].
- Simuliraj mersko napako, tako da vrednosti funkcije $sin(x)$ "pokvariš" s slučajnimi vrednostmi
  porazdeljenimi normalno. Nato primerjaj različne metode za izračun integrala:
  $
    integral_0^3 sin(x) d x.
  $

== Gaussove kvadraturne formule

$
 integral_(-1)^1 f(t) d t approx sum_(k=1)^N w_k f(t_k)
$<eq:10-gauss-lagendre>

Spremembo intervala z $[a, b]$ na $[-1, 1]$ naredimo z linearno transformacijo oziroma uvedbo
nove spremenljivke $t in [-1, 1]$:

$
  t(x) = 2(x - a)/(b - a) - 1 quad #text[ in ] quad x(t) = (b - a) / 2 t + (a + b) / 2.
$

Intergral na $[a, b]$ lahko zapišemo

$
  integral_(a)^(b) f(x) d x = integral_(-1)^1 f(x(t)) x'(t) d t =
  1/2 (b - a) integral_(-1)^1 f(x(t)) d t.
$

Gauss-Legendrove formule na $[a, b]$

$
  integral_(a)^(b) f(x) d x = 1/2 (b-a) sum_(k=1)^N w_k f(x_k),
$
kjer je
$
  x_k = (b - a)/2 t_k + (a + b)/2.
$

== Tabela podatkov z mersko napako

Predpostavimo, da je merska napaka $epsilon$ slučajna spremenljivka, ki je porazdeljena normalno
$epsilon ~ N(0, sigma)$. V tem primeru metode visokega reda nič ne koristijo. Višji red metode bo
zgolj bolje ocenil prispevek napake $epsilon$, ki pa je še vedno neznana. Zato v tem primeru
povsem zadoščajo metode nizkega reda, kot je trapezna metoda.

== Rešitve

#let vaja13(koda, caption) = figure(caption: caption, code_box(jlfb("Vaja13/src/Vaja13.jl", koda)))
