#import "admonitions.typ": opomba
#import "julia.typ": code_box, jl, jlfb

= Integrali

Za numerični izračun določenega integrala funkcije $f(x)$ na intervalu $[a, b]$
$
  integral_(a)^(b) f(x) d x
$
obstaja veliko različnih metod, ki jih imenujemo #emph[numerične kvadrature] ali
na kratko #emph[kvadrature]. V tej vaji si bomo ogledali
kako izbrati primerno metodo, glede na to, kakšno funkcijo integriramo.

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

#emph[Trapezno pravilo] izhaja iz formule za ploščino trapeza. Integral $f$ na $[a, b]$ ocenimo s
ploščino trapeza z oglišči $(a, 0)$, $(a, f(a))$, $(b, f(b))$ in $(b, 0)$
$
  integral_a^b f(x) d x approx (b-a)(f(a) + f(b))/2.
$

#figure(image("img/13-trapez.svg", width: 60%), caption:[Ilustracija trapeznega pravila])

Sestavljeno trapezno pravilo izpeljemo tako, da interval $[a, b]$ razdelimo na manjše dele in na vsakem
podintervalu uporabimo trapezno formulo. Interval $[a, b]$ razdelimo na $n$ podintervalov in označimo z
$x_0=a < x_1 < x_2 < med dots med < x_(n-1) < x_(n)=b$ krajišča podintervalov. Integral na $[a, b]$
lahko razbijemo na vsoto integralov po intervalih $[x_(i), x_(i+1)]$ in na vsakem podintervalu
uporabimom trapezno formulo
$
  integral_a^b f(x) d x = integral_a^x_1 f(x) d x + integral_(x_1)^(x_2) f(x) d x + med dots med +
  integral_(x_(n-1))^b f(x) d x approx\
  (x_1 - a)(f(a) + f(x_1))/2 + (x_2 - x_1)(f(x_1) + f(x_2))/2 + med dots med +
  (b - x_(n-1))(f(x_(n-1)) + f(b))/2.
$

#figure(image("img/13-sest-trapez.svg", width: 60%), caption:[Ilustracija sestavljenega trapeznega pravila])

Če točke $x_k$ razporedimo enakomerno, tako da je $h = x_1 - a = x_2 - x_1 = med dots med =
b - x_(n-1)$ in $x_k = a + k h$, dobimo naslednjo formulo
$
  integral_a^b f(x) d x approx  h/2(f(a)+f(x_1)) + h/2(f(x_1)+f(x_2)) +\
  dots med + h/2(f(x_(n-2)) + f(x_(n-1))) + h/2 (f(x_(n-1)) + f(b)) = \
  h/2(f(a) + 2f(x_1) + 2f(x_2) + dots + 2f(x_(n-1)) + f(b)).
$<eq:13-trapez>

Predznačeni dolžini podintervala $x_(k+1) - x_k$ v sestavljeni kvadraturni formuli pogosto
rečemo #emph[korak]. Korak je lahko tudi negativen, če je spodnja meja integrala večja od zgornje.
Za formulo @eq:13-trapez pravimo, da je sestavljena formula z enakomernim korakom.

 Manjša kot je širina
intervala $h = (b - a)/n$, bližje je vsota @eq:13-trapez pravi vrednosti integrala. V nadaljevanju
se bomo prepričali, da za trapezno formulo, napaka pada približno sorazmerno s $h^2$.

Definirajmo naslednje tipe in funkcije:
- tip #jl("Interval(a, b)"), ki predstavlja zaprti interval $[a, b]$ (@pr:13-Interval),
- tip #jl("Integral(fun, interval::Interval)"), ki predstavlja določeni integral funkcije #jl("fun")
  na intervalu #jl("interval") (@pr:13-Integral),
- tip #jl("Trapezna(n::Int)"), ki predstavlja sestavljeno trapezno formulo z $n$ enakomernimi koraki
  (@pr:13-Trapezna) in
- metodo #jl("integriraj(i::Integral, k::Trapezna)"), ki izračuna približek za integral #jl("i")
  s sestavljno trapezno formulo #jl("k") (@pr:13-int-trapez).

Sestavljena Simpsonova formula z $2n$ enakomernimi koraki $h$:
$
  integral_a^b f(x) d x approx h/3 (f(a) + f(b) +
  4sum_(k=1)^n f(a + (2k - 1) h) + 2sum_(j=1)^(n-1)f(a+2 j h)),
$<eq:13-simpson>

kjer je $h = (b - a)/(2n)$.

Definirajmo naslednje tipe in metode:
- podatkovni tip #jl("Simpson(n::Int)"), ki predstavlja sestavljeno Simpsonovo formulo,
  (@pr:13-simpson) in
- metodo #jl("integriraj(i::Integral, k::Simpson)") za funkcijo #jl("integriraj"), ki
  izračuna približek za integral #jl("i") s sestavljeno Simpsonovo formulo #jl("k")
  (@pr:13-int-simpson).

== Gaussove kvadraturne formule

Sestavljeni trapezna @eq:13-trapez in Simpsonova formula @eq:13-simpson nista nič drugega kot
uteženi vsoti funkcijskih vrednosti v izbranih točkah na integracijskem intervalu

$
 integral_a^b f(x) d x approx sum_(k=0)^n u_k f(x_k).
$

Vrednostim $u_k$ pravimo #emph[uteži], $x_k$ pa #emph[vozlišča] kvadraturne formule. Za sestavljeno
trapezno formulo so uteži enake $u_0 = u_n = h/2$ in $u_k = h, quad 1<= k<=n-1$
vozlišča pa $x_k = a + k h$.

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

#figure(caption: [Absolutna vrednost napake pri izračunu $integral_0^3 sin(x^2) d x$ z različnimi
  kvadraturami],
  image("img/13-napaka-sin.svg", width: 60%))

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
približek za dani integral #jl("i") z dano kvadraturo #jl("k") (@pr:13-int-gl).

== Adaptivne metode

#opomba(naslov:[Ponovna uporaba že izračunanih funkcijskih vrdnosti])[
V naši implementaciji adaptivne metode smo vrednosti funkcije v nekatirh vozliščih večkrat
izračunali. Hitrost smo žrtvovali v prid enostavnosti in preglednosti. V praksi se adaptivne
metode implementira na način, da se funkcijske vrednosti v vsakem vozlišču izračuna samo enkrat
in se nato te vrednosti uporabi v nadalnjih izračunih.

To dobro deluje za kvadrature kot so Simpsonova in trapezna formula, ki spadajo med
#link("https://en.wikipedia.org/wiki/Newton%E2%80%93Cotes_formulas")[Newton-Cotesove] kvadrature.
Za Gaussove kvadrature je več težav, saj se vozlišča kvadratur višjega reda ne prekrivajo z vozlišči
kvadratur nižjega reda. Rešitev ponujajo
#link("https://en.wikipedia.org/wiki/Gauss%E2%80%93Kronrod_quadrature_formula")[Gauss-Kronrodove kvadrature],
ki so podane kot pari kvadratur, pri katerem kvadratura višjega reda vsebuje vsa vozlišča
kvadrature nižjega reda. Kvadratura nižjega reda je Gauss-Legendrova kvadratura z $n$ vozlišči.
Nato se izbere dodatnih $n+1$ vozlišč in na novo določi uteži, tako da je druga kvadratura čim
višjega reda.
]
== Primeri


== Tabela podatkov z mersko napako

Predpostavimo, da je merska napaka $epsilon$ slučajna spremenljivka, ki je porazdeljena normalno
$epsilon ~ N(0, sigma)$. V tem primeru metode visokega reda nič ne koristijo. Višji red metode bo
zgolj bolje ocenil prispevek napake $epsilon$, ki pa je še vedno neznana. Zato v tem primeru
povsem zadoščajo metode nizkega reda, kot je trapezna metoda.

== Rešitve

#let vaja13(koda, caption) = figure(caption: caption, code_box(jlfb("Vaja13/src/Vaja13.jl", koda)))

#vaja13("# Interval")[Podatkovni tip za zaprti interval $[a, b]$]<pr:13-Interval>
#vaja13("# Integral")[Podatkovni tip za določeni integral $integral_a^b f(x) d x$]<pr:13-Integral>
#vaja13("# Trapez")[Podatkovni tip za sestavljeno trapezno formulo z $n$ eankomernimi koraki]<pr:13-Trapezna>
#vaja13("# integriraj trapez")[Funkcija, ki izračuna integral z dano kvadraturo]<pr:13-int-trapez>
#vaja13("# Simpson")[Podatkovni tip za sestavljeno Simpsonovo formulo z $2n$ eankomernimi koraki]<pr:13-simpson>
#vaja13("# integriraj simpson")[Funkcija, ki izračuna integral z dano kvadraturo]<pr:13-int-simpson>
#vaja13("# Kvadratura")[Podatkovni tip za splošno kvadraturno formulo]<pr:13-Kvadratura>
#vaja13("# integriraj gl")[Funkcija, ki izračuna integral z dano kvadraturo]<pr:13-int-gl>

== Testi

#let test13(koda, caption) = figure(caption: caption, code_box(jlfb("Vaja13/test/runtests.jl", koda)))
#test13("# integriraj")[Test za funkcijo #jl("integriraj")]
