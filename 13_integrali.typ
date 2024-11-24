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
- Implementiraj funkcijo #jl("integriraj(int, kvad::Kvadratura)"), ki s kvadraturo #jl("kvad")
  izračuna integral `int`.
- Implementiraj sestavljeno trapezno, sestavljeno Simpsonovo, Gauss-Legendrove kvadrature in
  adaptivno Simpsonovo metodo. Za izračun uteži in vozlišč Gauss-Legendrovih kvadratur uporabi paket
  #link("https://juliaapproximation.github.io/FastGaussQuadrature.jl/stable/")[FastGaussQuadrature.jl].
- Implementirane metode uporabi za izračun naslednjih integralov
  $
    integral_0^3 sin(x^2) d x, integral_(-oo)^(-5)e^(-x^2) d x quad #text[ in ]
    quad integral_(-1)^2 |2 - x^2| d x.
  $
  Napako oceni tako, da rezultat primerjaš z rezultatom, ki ga dobiš, če uporabiš dvakrat več
  vozlišč in uporabiš
  #link("https://en.wikipedia.org/wiki/Richardson_extrapolation")[Richardsonovo ekstrapolacijo].
- Simuliraj mersko napako, tako da vrednosti funkcije $sin(x)$ "pokvariš" s slučajnimi vrednostmi
  porazdeljenimi normalno. Nato primerjaj različne metode za izračun integrala:
  $
    integral_0^3 sin(x) d x.
  $

== Trapezno in Simpsonovo pravilo

== Sestavljena pravila

#opomba(naslov: [Zakaj so vse kvadraturne formule utežene vsote?])[
Vse kvadrature, ki jih poznamo, lahko na nek način prevedemo na  uteženo
vsoto funkcijskih vrednosti
$
  integral_a^b f(x) = sum_(i=1)^n u_i f(x_i).
$

Zakaj je tako? Integral lahko obravnavamo kot funkcijo na prostoru integrabilnih  funkcij

$
  I_([a, b]): f |-> integral_a^b f(x) d x.
$
Kvadraturo zapišemo kot funkcijo končnega števila funkcijskih vrednosti v izbranih vozliščih in jo
tudi obravnavamo kot funkcijo na prostoru integrabilnih funkcij:

$
  K(f) = k(f(x_1), f(x_2), med dots, med f(x_(n))).
$

Funkcija $I_([a, b])$ je linearen funkcional, zato želimo, da je tudi kvadratura $K$ linearen
funkcional, kar pa pomeni, da mora biti funkcija $k(f(x_1), f(x_2), med dots, med f(x_(n))$ linearna in

$
  K(f) = k(f(x_1), f(x_2), med dots, med f(x_(n))) = sum_(i=1)^n u_i f(x_i).
$

Izjema so adaptivne metode, pri katerih je izbira vozlišč $x_i$ odvisna od izbire funkcije $f$, ki
jo integriramo. Zato adaptivne metode strogo gledano niso linearni funkcionali, kljub temu, da jih
lahko prevedemo na uteženo vsoto.
]
== Preslikava na drug interval

Določeni integral

$
  integral_(a)^(b) f(x) d x
$<eq:13-int-a-b>

lahko s preprosto linearno preslikavo premaknemo na drug interval $[c, d]$. V integral @eq:13-int-a-b
vpeljemo novo spremenljivko $t = t(x) = k x + n$, ki preslika interval $[a, b]$ na interval $[c, d]$.
Formulo za $t$ določimo tako, da najprej preslikamo $[a, b]$ s preslikavo $s = (x - a)/(b-a)$ na
$[0, 1]$ in nato $s$ preslikamo $t = (d - c)s + c$ z intervala $[0, 1]$ na interval $[c, d]$.
Inverzno preslikavo $x = x(t)$ izračunamo enako:

$
  t(x) = (d - c)/(b - a)(x - a) + c quad #text[ in ] quad
  x(t) = (b - a)/(d - c)(t - c) + a.
$

Integral @eq:13-int-a-b lahko sedaj preslikamo na $[c, d]$:

$
  integral_(a)^(b) f(x) d x = integral_(t(a))^(t(b)) f(x(t)) x'(t) d t =
  (b-a)/(d-c) integral_c^d f((b -a)/(d-c)(t -c) + a) d t.
$<eq:13-int-ab-cd>

Pri izpeljavi @eq:13-int-ab-cd smo upoštevali, da je $d x = x'(t) d t = (b -a)/(d -c) d t$.
Če imamo kvadraturno formulo za interval $[c, d]$:

$
  integral_c^d f(t) d t approx sum_(i=1)^n u_i f(t_i),
$

lahko s preslikavo @eq:13-int-ab-cd zapišemo kvadraturno formulo za poljuben interval $[a, b]$:

$
  integral_a^b f(x) d x = (b - a)/(d - c)integral_c^d f(x(t)) d t approx
  (b - a)/(d - c) sum_(i=1)^n u_i f(x_i),
$

kjer so nova vozlišča $x_i$ enaka:

$
  x_i = (b - a)/(d - c)(t_i - c) + a.
$

Napišimo funkcijo $jl("integriraj(i::Integral, k::Kvadratura)")$, ki izračuna
približek za dani integral #jl("i") z dano kvadraturo #jl("k") (@pr:13-integriraj).

== Gaussove kvadraturne formule

$
 integral_(-1)^1 f(t) d t approx sum_(k=1)^N w_k f(t_k)
$<eq:10-gauss-lagendre>

Spremembo intervala z $[a, b]$ na $[-1, 1]$ naredimo z linearno preslikavo oziroma uvedbo
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


#figure(caption: [Absolutna vrednost napake pri izračunu $integral_0^3 sin(x^2) d x$ z različnimi
  kvadraturami],
  image("img/13-napaka-sin.svg", width: 60%))

== Tabela podatkov z mersko napako

Predpostavimo, da je merska napaka $epsilon$ slučajna spremenljivka, ki je porazdeljena normalno
$epsilon ~ N(0, sigma)$. V tem primeru metode visokega reda nič ne koristijo. Višji red metode bo
zgolj bolje ocenil prispevek napake $epsilon$, ki pa je še vedno neznana. Zato v tem primeru
povsem zadoščajo metode nizkega reda, kot je trapezna metoda.

== Rešitve

#let vaja13(koda, caption) = figure(caption: caption, code_box(jlfb("Vaja13/src/Vaja13.jl", koda)))

#vaja13("# integriraj")[Funkcija, ki izračuna integral z dano kvadraturo]<pr:13-integriraj>

== Testi

#let test13(koda, caption) = figure(caption: caption, code_box(jlfb("Vaja13/test/runtests.jl", koda)))
#test13("# integriraj")[Test za funkcijo #jl("integriraj")]
