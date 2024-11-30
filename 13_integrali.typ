#import "admonitions.typ": opomba
#import "julia.typ": code_box, jl, jlfb, repl, blk

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

== Trapezno pravilo in sestavljeno trapezno pravilo

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

Preden se lotimo implementacije trapeznega in sestavljenega trapeznega pravila, bomo napisali teste,
ki bodo preverili pravilnost bodoče implementacije.

#opomba(naslov: [Testno voden razvoj])[
  V tej vaji bomo sledili
  načinu razvoja programske opreme, ki se imenuje
  #link("https://sl.wikipedia.org/wiki/Testno_voden_razvoj")[testno voden razvoj]. Ideja testno
 vodenega razvoja je, da se najprej napiše teste in šele nato kodo, ki zadovolji te teste. S tem se
 pozornost preusmeri iz implementacije na uporabo in iz ustvarjalca kode na uporabnika. S tem ko
 najprej napišemo test, moramo najprej razmisliti, kako bo naša koda uporabljena. Tako se vživimo v
 vlogo uporabnika in začasno odmislimo implementacijo. Prednosti testno vodenega razvoja so tako
 dvojne. Uporabniška izkušnja je boljša, poleg tega pa je koda preverjena vsaj na enem primeru.
]

Vemo, da je trapezno pravilo in zato tudi sestavljeno trapezno pravilo točno za linearne funkcije.
Zato bomo v testu integrirali linearno funkcijo.

Da lahko napišemo test, si moramo najprej zamisliti, kako bomo kodo uporabljali.
V našem primeru želimo izračunati približek za določeni integral in za to uporabiti sestavljeno
trapezno pravilo. Osnovni pojem je integral, zato si zasluži svoj podatkovni tip #jl("Integral").
Določeni integral ima dve sestavini: funkcijo in interval. In tako bo imel podatkovni tip
#jl("Integral") dve polji #jl("f") za funkcijo in #jl("interval") za interval. Za daljše ime
#jl("interval") se odločimo, da preprečimo zamenjavo s precej podobno besedo #emph[integral].

Interval bi lahko predstavili s parom ali nizom števil, vendar raje definiramo
nov podatkovni tip #jl("Interval"), ki vsebuje dve polji #jl("min") in #jl("max").
Na prvi pogled se zdi, da vpeljava novega tipa nima smisla, saj par števil #jl("(1.0, 2.0)") in
vrednost #jl("Interval(1.0, 2.0)") vsebujeta iste podatke. Vendar pa nosi vrednost
tipa #jl("Interval") dodatno informacijo o vlogi, ki jo ima v programu. Ločevanje po vlogi in
ne le po obliki podatkov je priporčljivo, saj lahko prepreči napake, ki jih je sicer težko odkriti
in so posledica zamenjave podatkov iste oblike, ki pa nastopajo v različnih vlogah.

Ko smo določili zapis integrala, moramo razmisliti, kako v programu predstaviti sestavljeno trapezno
pravilo. V objektno orientiranih programskih
jezikih bi definirali vmesnik za splošno kvadraturo in razred za sestavljeno trapezno pravilo, ki ta
vmesnik implementira. Julia uporablja večlično razdelitev, ki omogoča definicijo več
specializiranih metod za isto funkcijo. Izbira metode je odvisna od tipa vhodnih podatkov. Zato je
naravno, da za sestavljeno trapezno pravilo definiramo svoj podatkovni tip #jl("Trapezna")
in metodo #jl("integriraj(i::Integral, m::Trapezna)") za splošno funkcijo #jl("integriraj"). Test
povzame odločitve in zasnovo programskega vmesnika, kot smo si ga zamislili.

#let test13(koda, caption) = figure(caption: caption, code_box(jlfb("Vaja13/test/runtests.jl", koda)))

#test13("# trapezna")[Test za sestavljeno trapezno formulo]

#pagebreak()
Definirajmo naslednje tipe in funkcije in poskrbimo, da bo test uspešen:
- tip #jl("Interval(a, b)"), ki predstavlja zaprti interval $[a, b]$ (@pr:13-Interval),
- tip #jl("Integral(fun, interval::Interval)"), ki predstavlja določeni integral funkcije #jl("fun")
  na intervalu #jl("interval") (@pr:13-Integral),
- tip #jl("Trapezna(n::Int)"), ki predstavlja sestavljeno trapezno formulo z $n$ enakomernimi koraki
  (@pr:13-Trapezna) in
- metodo #jl("integriraj(i::Integral, k::Trapezna)"), ki izračuna približek za integral #jl("i")
  s sestavljno trapezno formulo #jl("k") (@pr:13-int-trapez).

== Simpsonovo pravilo

Simpsonovo pravilo dobimo tako, da poleg vrednosti funkcije v krajiščih intervala uporabimo še
vrednost funkcije v središču intervala. Tako dobimo formulo:

$
  integral_0^h f(x) d x = h/6 (f(a) + 4f((a+b)/2) + f(b)) + R_f,
$

kjer je napaka enaka $R_f = -1/2880 h^5 f^((4))(xi)$ za neznano vrednost $xi in [0, h]$. Obstoj
vrednosti $xi$ je posledica Lagrangevega izreka in vrednost $xi$ je odvisna od funkcije $f$, ki
jo integriramo. Izpeljavo Simpsonovega pravila si lahko ogledate v @sec:13-izpeljava[poglavju].

Podobno kot trapezno lahko tudi Simpsonovo pravilo preoblikujemo v sestavljeno pravilo. Sestavljeno
Simpsonovo pravilo z $2n$ enakomernimi koraki $h$ je dano kot:

$
  integral_a^b f(x) d x approx h/3 (f(a) + f(b) +
  4sum_(k=1)^n f(a + (2k - 1) h) + 2sum_(j=1)^(n-1)f(a+2 j h)),
$<eq:13-simpson>

kjer je $h = (b - a)/(2n)$. Napaka sestavljenega pravila @eq:13-simpson je enaka:

$
 -1/180 h^4(b-a)f^((4))(xi).
$

Podobno kot pri trapeznem pravilu sledimo testno vodenemu razvoju in najprej napišemo test. Večino
zasnove smo določili že pri trapeznem pravilu. Preostane nam le še podatkovni tip za Simpsonovo
pravilo, ki ga imenujemo #jl("Simpson"). Vemo, da je Simpsonovo pravilo točno za polinome 3. stopnje,
zato v testu uporabimo polinom 3. stopnje.

#test13("# simpson")[Test sestavljenega Simpsonovega pravila]

Definirajmo naslednje tipe in metode ter poskrbimo, da se test pravilno izvede:
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

Pri trapezni in Simpsonovi kvadraturi so vozlišča razporejena na robu in sredini
integracijskega intervala, uteži pa so določene tako, da je formula točna za polinome čim višjih
stopenj. To ni optimalna izbira. Če dovolimo, da so vozlišča razporejena drugače, lahko
dobimo kvadraturo, ki je točna za polinome višjih stopenj. Za integral na intervalu $[-1, 1]$
dobimo #link("https://en.wikipedia.org/wiki/Gauss%E2%80%93Legendre_quadrature")[Gauss-Legendreove]
kvadrature

$
 integral_(-1)^1 f(t) d t approx sum_(k=1)^n w_k f(t_k),
$<eq:10-gauss-lagendre>

ki so del družine
#link("https://en.wikipedia.org/wiki/Gaussian_quadrature")[Gaussovih kvadratur]. Za
Gauss-Legendrovo kvadraturo z $n$ vozlišči so ničle Legendreovega
polinoma stopnje $n$ optimalna izbira vozlišč. Vozlišča $x_k$ in uteži $u_k$ za Gaussove kvadrature
lahko poiščemo z
#link("https://en.wikipedia.org/wiki/Gaussian_quadrature#The_Golub-Welsch_algorithm")[Golub-Welschovim algoritmom],
a to presega obseg te vaje. Za izračun vozlišč in uteži bomo uporabili knjižnico
#jl("FastGaussQuadrature.jl").

Če želimo Gauss-Legendreovo kvadraturo uporabiti na poljubnem intervalu $[a, b]$,
moramo interval $[-1, 1]$ preslikati na $[a, b]$. To naredimo z linearno preslikavo oziroma uvedbo
nove spremenljivke $t in [-1, 1]$:

$
  t(x) = 2(x - a)/(b - a) - 1 quad #text[ in ] quad x(t) = (b - a) / 2 t + (a + b) / 2.
$

Intergral na $[a, b]$ lahko zapišemo

$
  integral_(a)^(b) f(x) d x = integral_(-1)^1 f(x(t)) x'(t) d t =
  1/2 (b - a) integral_(-1)^1 f(x(t)) d t,
$
kjer smo upoštevali, da je $x'(t) = 1/2 (b-a)$. Gauss-Legendrove formule na $[a, b]$ so tako

$
  integral_(a)^(b) f(x) d x = 1/2 (b-a) sum_(k=1)^N w_k f(x_k),
$
kjer je
$
  x_k = (b - a)/2 t_k + (a + b)/2.
$

Napišimo sedaj
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

Napišimo funkcijo $jl("integriraj(i::Integral, k::Kvadratura)")$, ki izračuna
približek za dani integral #jl("i") z dano kvadraturo #jl("k") (@pr:13-int-gl) in funkcijo
#jl("glkvad(n::Int)"), ki vrne Gauss-Legendrovo kvadraturo za interval $[-1, 1]$ z $n$ vozlišči
(@pr:13-glkvad).

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

#opomba(naslov: [Kaj smo se naučili?])[
  - Kvadraturne formule se večinoma prevedejo na uteženo vsoto funkcijskih vrednostih v
    vozliščih kvadrature.
  - Gauss-Legendrove kvadrature so najbolj primerne za integrale funkcij, ki jih lahko dobro
    aproksimiramo s polinomi.
  - Za splošno rabo so najbolj primerne adaptivne kvadrature.
  - V prisotnosti šuma, kvadrature visokega reda niso veliko boljše kot trapezno pravilo.
]

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
#vaja13("# glkvad")[Izračunaj uteži in vozlišča za Gauss-Legendrovo kvadraturo z $n$ vozlišči.]<pr:13-glkvad>

== Testi


== Izpeljava Simpsonovega pravila<sec:13-izpeljava>

Simpsonovo pravilo za izračun približka integrala poleg vrednosti funkcije v krajiščih uporabi še
vrednost funkcije na sredini. Pravilo lahko napišemo v naslednji obliki:

$
  integral_0^h f(x) d x = A f(a) + B f((a + b)/2) + C f(b) + R_f,
$

kjer so $A$, $B$ in $C$ uteži in $R_f$ enaka razliki med pravo vrednostjo in približkom. Uteži
določimo z metodo nedoločenih koeficientov. Vrednosti $A$, $B$ in $C$ določimo tako, da je $R_f = 0$
za polinome čim višjih stopenj. Začnemo s polinomom stopnje $0$, se pravi s konstanto $1$
$
  integral_0^h d x = h = A + B + C.
$
Nadaljujemo s polinomi $x$ in $x^2$
$
  integral_0^h x d x = h^2/2 = A dot.c 0 + B dot.c h/2 + C dot.c h\
  integral_0^h x^2 d x = h^3/3 = A dot.c 0 + B dot.c h^2/4 + C dot.c h^2\
$
Za uteži $A$, $B$ in $C$ dobimo sistem linearnih enačb
$
 h &= A + B + C,\
 h &= B + 2C,\
 4h &= 3B + 12C,
$

ki ga v matrični obliki lahko zapišemo kot

$
  mat(1, 1, 1; 0, 1, 2; 0, 3, 12)vec(A, B, C) = h vec(1, 1, 4)
$

in ga rešimo z Julio

#let demo13raw(koda) = blk("scripts/13_quad.jl", koda)
#code_box(
  repl(demo13raw("# abc"), read("out/13-abc.out"))
)

Vrednosti uteži so enake $A=h/6$, $B=2h/3$ in $C=h/6$, Simpsonovo pravilo pa se glasi:
$
  integral_0^h f(x) d x = h/6 (f(a) + 4f((a+b)/2) + f(b)) + R_f.
$

Formulo za napako $R_f$ dobimo tako, da v formulo vstavimo polinome še višjih stopenj, dokler
napaka ni več enaka $0$. Za $x^3$ je napaka $R_f$ enaka $0$

$
integral_0^h x^3 d x = h^4/4 =  2h/3 dot.c h^3/8 + h/6 dot.c h^3 = 1/4 h^4,
$

za $x^4$, pa ne več

$
integral_0^h x^4 d x = h^5/5 =  2h/3 dot.c h^4/16 + h/6 dot.c h^4 + R_(x^4) = 5/(24) h^5 + R_(x^4)\
R_(x^4) = -1/(120) h^5.
$

Ker je $x^4$ najnižja stopnja polinoma, pri kateri napaka vedno enaka $0$, bo v formuli za napako
nastopala vrednost četrtega odvoda $f^((4))(xi)$ v neznani točki $xi$. Napako lahko zapišemo kot
$R_f = C h^5 f^((4))(xi)$ in

$
  R_(x^4) = C h^5 (x^4)^((4)) = C h^5 4! = -1/120 h^5\
  C = -1/2880.
$
