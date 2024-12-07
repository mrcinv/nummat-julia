#import "admonitions.typ": opomba, naloga
#import "julia.typ": code_box, jl, jlfb, repl, blk

= Integrali

Za numerični izračun določenega integrala funkcije $f$ na intervalu $[a, b]$
$
  integral_(a)^(b) f(x) d x
$
obstaja veliko različnih metod, ki jih imenujemo #emph[numerične kvadrature] ali
na kratko #emph[kvadrature]. V tej vaji si bomo ogledali,
kako izbrati primerno metodo, glede na to, kakšno funkcijo integriramo.

== Naloga

- Definiraj podatkovni tip, ki predstavlja določeni integral funkcije na danem intervalu.
- Definiraj podatkovni tip #jl("Kvadratura"), ki hrani podatke o vozlih in utežeh
  za dano kvadraturo na danem intervalu.
- Implementiraj funkcijo #jl("integriraj(int, kvad::Kvadratura)"), ki s kvadraturo #jl("kvad")
  izračuna integral `int`.
- Implementiraj sestavljeno trapezno, sestavljeno Simpsonovo, Gauss-Legendreove kvadrature in
  adaptivno Simpsonovo metodo. Za izračun vozlov in uteži Gauss-Legendreovih kvadratur uporabi paket
  #link("https://juliaapproximation.github.io/FastGaussQuadrature.jl/stable/")[FastGaussQuadrature.jl].
- Implementirane metode uporabi za izračun naslednjih integralov
  $
    integral_0^3 sin(x^2) d x quad #text[ in ] quad integral_(-1)^2 |2 - x^2| d x.
  $
  Napako oceni tako, da rezultat primerjaš z rezultatom, ki ga dobiš, če uporabiš dvakrat več
  vozlov in uporabiš
  #link("https://en.wikipedia.org/wiki/Richardson_extrapolation")[Richardsonovo ekstrapolacijo].

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
uporabimo trapezno formulo
$
  integral_a^b f(x) d x = integral_a^x_1 f(x) d x + integral_(x_1)^(x_2) f(x) d x + med dots med +
  integral_(x_(n-1))^b f(x) d x\
  approx (x_1 - a)(f(a) + f(x_1))/2 + (x_2 - x_1)(f(x_1) + f(x_2))/2 + med dots med +
  (b - x_(n-1))(f(x_(n-1)) + f(b))/2.
$

#figure(image("img/13-sest-trapez.svg", width: 60%), caption:[Ilustracija sestavljenega trapeznega pravila])

Če točke $x_k$ razporedimo enakomerno, tako da je $h = x_1 - a = x_2 - x_1 = med dots med =
b - x_(n-1)$ in $x_k = a + k h$, dobimo naslednjo formulo
$
  integral_a^b f(x) d x &approx  h/2(f(a)+f(x_1)) + h/2(f(x_1)+f(x_2))\
  +& dots med + h/2(f(x_(n-2)) + f(x_(n-1))) + h/2 (f(x_(n-1)) + f(b))\
  =& h(1/2 f(a) + f(x_1) + f(x_2) + dots + f(x_(n-1)) + 1/2 f(b)).
$<eq:13-trapez>

Predznačeni dolžini podintervala $x_(k+1) - x_k$ v sestavljeni kvadraturni formuli pogosto
rečemo #emph[korak]. Korak je lahko tudi negativen, če je spodnja meja integrala večja od zgornje.
Za formulo @eq:13-trapez pravimo, da je sestavljena formula z enakomernim korakom.

 Manjša kot je širina
intervala $h = (b - a)/n$, bližje je vsota @eq:13-trapez pravi vrednosti integrala. V nadaljevanju
se bomo prepričali, da za trapezno formulo, napaka pada sorazmerno s $h^2$.

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
ne le po obliki podatkov je priporočljivo, saj lahko prepreči napake, ki jih je sicer težko odkriti
in so posledica zamenjave podatkov iste oblike, ki pa nastopajo v različnih vlogah.

Ko smo določili zapis integrala, moramo razmisliti, kako v programu predstaviti sestavljeno trapezno
pravilo. V objektno orientiranih programskih
jezikih bi definirali vmesnik za splošno kvadraturo in razred za sestavljeno trapezno pravilo, ki ta
vmesnik implementira. Julia uporablja večlično razdelitev, ki omogoča definicijo več
specializiranih metod za isto funkcijo. Izbira metode je odvisna od tipa vhodnih podatkov. Zato je
naravno, da za sestavljeno trapezno pravilo definiramo svoj podatkovni tip #jl("Trapez")
in metodo #jl("integriraj(i::Integral, m::Trapez)") za splošno funkcijo #jl("integriraj"). Test
povzame odločitve in zasnovo programskega vmesnika, kot smo si ga zamislili.

#let test13(koda, caption) = figure(caption: caption, code_box(jlfb("Vaja13/test/runtests.jl", koda)))

#test13("# Trapez")[Test za sestavljeno trapezno formulo]

#pagebreak()
#naloga[
Definiraj naslednje tipe in funkcije in poskrbi, da bo test uspešen:
- tip #jl("Interval(a, b)"), ki predstavlja zaprti interval $[a, b]$ (@pr:13-Interval),
- tip #jl("Integral(fun, interval::Interval)"), ki predstavlja določeni integral funkcije #jl("fun")
  na intervalu #jl("interval") (@pr:13-Integral),
- tip #jl("Trapez(n::Int)"), ki predstavlja sestavljeno trapezno formulo z $n$ enakomernimi koraki
  (@pr:13-Trapez) in
- metodo #jl("integriraj(i::Integral, k::Trapez)"), ki izračuna približek za integral #jl("i")
  s sestavljeno trapezno formulo #jl("k") (@pr:13-int-trapez).
]
== Simpsonovo pravilo

Simpsonovo pravilo dobimo tako, da poleg vrednosti funkcije v krajiščih intervala uporabimo še
vrednost funkcije v središču intervala. Tako dobimo formulo:

$
  integral_0^h f(x) d x = h/6 (f(a) + 4f((a+b)/2) + f(b)) + R_f,
$

kjer je napaka enaka $R_f = -1/2880 h^5 f^((4))(xi)$ za neznano vrednost $xi in [0, h]$. Obstoj
vrednosti $xi$ je posledica Lagrangeevega izreka in vrednost $xi$ je odvisna od funkcije $f$, ki
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

#naloga[
Definiraj naslednje tipe in metode ter poskrbi, da se test pravilno izvede:
- podatkovni tip #jl("Simpson(n::Int)"), ki predstavlja sestavljeno Simpsonovo formulo
  (@pr:13-simpson) in
- metodo #jl("integriraj(i::Integral, k::Simpson)"), ki
  izračuna približek za integral #jl("i") s sestavljeno Simpsonovo formulo #jl("k")
  (@pr:13-int-simpson).
]

== Gaussove kvadraturne formule

Sestavljeni trapezna @eq:13-trapez in Simpsonova formula @eq:13-simpson nista nič drugega kot
uteženi vsoti funkcijskih vrednosti v izbranih točkah na integracijskem intervalu

$
 integral_a^b f(x) d x approx sum_(k=0)^n u_k f(x_k).
$

Vrednostim $u_k$ pravimo #emph[uteži], $x_k$ pa #emph[vozli] kvadraturne formule. Za sestavljeno
trapezno formulo so uteži enake $u_0 = u_n = h/2$ in $u_k = h, quad 1<= k<=n-1$
vozli pa $x_k = a + k h$.

Pri trapezni in Simpsonovi kvadraturi so vozli razporejeni na robu in sredini
integracijskega intervala, uteži pa so določene tako, da je formula točna za polinome čim višjih
stopenj. To ni optimalna izbira. Če dovolimo, da so vozli razporejeni drugače, lahko
dobimo kvadraturo, ki je točna za polinome še višjih stopenj. Za integral na intervalu $[-1, 1]$
dobimo #link("https://en.wikipedia.org/wiki/Gauss%E2%80%93Legendre_quadrature")[Gauss-Legendreove]
kvadrature

$
 integral_(-1)^1 f(t) d t approx sum_(k=1)^n w_k f(t_k),
$<eq:10-gauss-lagendre>

ki so del družine
#link("https://en.wikipedia.org/wiki/Gaussian_quadrature")[Gaussovih kvadratur]. Za
Gauss-Legendreovo kvadraturo z $n$ vozli so ničle Legendreovega
polinoma stopnje $n$ optimalna izbira. Gauss-Legendreova kvadratura z $n$ vozli je točna
za polinome stopnje $2n - 1$. Za $n=1$, dobimo sredinsko pravilo z vozlom v $x_1=0$, ki je točna
za linearne funkcije. Za $n=2$ dobimo formulo

$
  integral_(-1)^1 f(x) d x approx f(-1/sqrt(3)) + f(1/sqrt(3)),
$<eq:13-gl2>

ki je točna za kubične polinome.

Če želimo Gauss-Legendreovo kvadraturo uporabiti na poljubnem intervalu $[a, b]$,
moramo interval $[-1, 1]$ preslikati na $[a, b]$. To naredimo z linearno funkcijo oziroma uvedbo
nove spremenljivke $t in [-1, 1]$:

$
  t(x) = 2(x - a)/(b - a) - 1 quad #text[ in ] quad x(t) = (b - a) / 2 t + (a + b) / 2.
$

Integral na $[a, b]$ lahko zapišemo

$
  integral_(a)^(b) f(x) d x = integral_(-1)^1 f(x(t)) x'(t) d t =
  1/2 (b - a) integral_(-1)^1 f(x(t)) d t,
$

kjer smo upoštevali, da je $x'(t) = 1/2 (b-a)$. Gauss-Legendreove formule na $[a, b]$ so tako

$
  integral_(a)^(b) f(x) d x = 1/2 (b-a) sum_(k=1)^N w_k f(x_k),
$
kjer je
$
  x_k = (b - a)/2 t_k + (a + b)/2.
$


Vozli $x_k$ in uteži $u_k$ za Gauss-Legendreove kvadrature ni tako enostavno poiskati, saj moramo
poiskati ničle ustreznega Legendreovega polinoma in določiti uteži. Obstaja tudi
#link("https://en.wikipedia.org/wiki/Gaussian_quadrature#The_Golub-Welsch_algorithm")[Golub-Welschovim algoritem],
ki vozle in uteži poišče kot lastne vrednosti posebej ustvarjene tridiagonalne matrike.
A računanje vozlov in uteži presega obseg te vaje in zato bomo za njihov izračun uporabili knjižnico
#jl("FastGaussQuadrature.jl").

Pri trapeznem in Simpsonovem pravilu smo uteži in vozli računali
sproti med računanjem približka za integral. To smo si lahko privoščili, ker je izračun
precej enostaven in ne zahteva veliko časa v primerjavi z izračunom utežene vsote. Pri
Gauss-Legendreovih kvadraturah pa izračun vozlov in uteži precej zahtevnejši, zato jih je smiselno shraniti za večkratno uporabo. Kvadrature bomo obravnavali splošno in definirali
podatkovni tip #jl("Kvadratura"), ki predstavlja splošno kvadraturo oblike

$
  integral_a^b f(x) d x approx sum_(k=1)^n u_k f(x_k).
$<eq:13-kvad>

Če pogledamo podrobno je kvadratura @eq:13-kvad podana z vozli $x_1, x_2, med dots, med x_n$,
utežmi $u_1, u_2, med dots, med u_n$ in intervalom $[a, b]$. Podatkovni tip #jl("Kvadratura") bo
tako imel tri polja:
- #jl("x") vektor vozlov,
- #jl("u") vektor uteži in
- #jl("interval") interval.

Ko imamo kvadraturo definirano, hočemo z njo izračunati integral. Napišimo v duhu testno vodenega
razvoja test za uporabo podatka tipa #jl("Kvadratura"). Kot smo videli, lahko
kvadraturo oblike @eq:13-kvad uporabimo na poljubnem intervalu, zato pričakujemo, da
funkcija #jl("integriraj") deluje tudi za integrale po intervalih, ki niso enaki intervalu
za kvadraturo. Za primer bomo uporabili Gauss-Legendreovo kvadraturo z dvema vozloma @eq:13-gl2,
ki je točna za kubične polinome.

#test13("# kvadratura")[Test za integracijo s splošno kvadraturo oblike @eq:13-kvad]

#naloga[
Napiši metodo $jl("integriraj(i::Integral, k::Kvadratura)")$, ki izračuna
približek za dani integral #jl("i") z dano kvadraturo #jl("k") (@pr:13-int-gl).
]

Napišimo sedaj test za Gauss-Legendreove kvadrature. Uporabimo dejstvo, da so kvadrature
z $n$ vozli točne za polinome stopnje $2n-1$.

#test13("# gl")[Test za generiranje Gauss-Legendreovih kvadratur]

Napišimo funkcijo #jl("glkvad(n::Int)"), ki vrne Gauss-Legendreovo kvadraturo z $n$ vozli
(@pr:13-glkvad).

#opomba(naslov: [Zakaj so vse kvadraturne formule utežene vsote?])[
Vse kvadrature, ki jih poznamo, lahko na nek način prevedemo na uteženo
vsoto funkcijskih vrednosti
$
  integral_a^b f(x) = sum_(i=1)^n u_i f(x_i).
$

Zakaj je tako? Integral lahko obravnavamo kot preslikavo na prostoru integrabilnih  funkcij

$
  I_([a, b]): f |-> integral_a^b f(x) d x.
$

Preslikava $I_([a, b])$ je linearen funkcional, zato želimo, da je tudi kvadratura $K(f)$ linearen
funkcional. Če želimo kvadraturo v končnem času izračunati,
mora biti odvisna le od končnega števila funkcijskih vrednosti. To pa pomeni, da mora biti funkcija
$K(f)$ linearna kombinacija končnega števila funkcijskih vrednosti
$f(x_1), f(x_2), med dots, med f(x_(n))$:

$
  K(f) = k(f(x_1), f(x_2), med dots, med f(x_(n))) = sum_(i=1)^n u_i f(x_i).
$

Izjema so adaptivne metode, pri katerih je izbira vozlov $x_i$ odvisna od izbire funkcije $f$, ki
jo integriramo. Zato adaptivne metode strogo gledano niso linearni funkcionali, kljub temu, da jih
lahko prevedemo na uteženo vsoto.
]

== Primeri

#let demo13(koda) = code_box(jlfb("scripts/13_quad.jl", koda))
#let demo13raw(koda) = blk("scripts/13_quad.jl", koda)
Metode, ki smo jih implementirali v prejšnjih poglavjih, bomo uporabili za izračun integrala
$
  integral_0^3 sin(x^2) d x.
$<eq:13-sinx2>

#demo13("# sin x2")
#figure(caption: [Graf funkcije, ki jo integriramo.], image("img/13-sinx2.svg", width: 60%))

Izračunajmo integral @eq:13-sinx2 z metodami, ki smo jih implementirali. Za vse metode
uporabimo enako število vozlov.

#code_box[
  #repl(demo13raw("# primer 1.0"), none)
  #repl(demo13raw("# primer 1.1"), read("out/13-primer-1.1.out"))
  #repl(demo13raw("# primer 1.2"), read("out/13-primer-1.2.out"))
  #repl(demo13raw("# primer 1.3"), read("out/13-primer-1.3.out"))
]

Kako vemo, kateri rezultat je boljši? Točnega rezultata ne znamo izračunati, saj integral
@eq:13-sinx2 ni elementaren. Nekako moramo oceniti napako. Uveljavili sta se dve strategiji,
kako ocenimo napako. Za sestavljene kvadraturne formule rezultat primerjamo z rezultatom iste
kvadrature s polovičnim korakom. Za Gauss-Legendreove kvadrature pa uporabimo kvadraturo višjega
reda.

#code_box[
  #repl(demo13raw("# primer 1.4"), read("out/13-primer-1.4.out"))
  #repl(demo13raw("# primer 1.5"), read("out/13-primer-1.5.out"))
  #repl(demo13raw("# primer 1.6"), read("out/13-primer-1.6.out"))
]
Vidimo, da se je najbolje odrezala Gauss-Legendreova kvadratura. Oglejmo si na grafu, kako pada
napaka s številom izračunanih funkcijskih vrednosti za vse tri metode.

#demo13("# graf napake sin x2")

#figure(caption: [Absolutna vrednost napake pri izračunu $integral_0^3 sin(x^2) d x$ z različnimi
  kvadraturami. Naklon premice pri trapeznem in Simpsonovem pravilu je enak redu metode.],
  image("img/13-napaka-sin.svg", width: 60%))

#opomba(naslov: [Richardsonova ekstrapolacija])[
Če imamo kvadraturo reda $n$ za dani integral
$
  integral_a^b f(x) d x = K(h) + C h^n + cal(O)(h^(n+1)), quad h=(b-a)/N
$

lahko z #link("https://en.wikipedia.org/wiki/Richardson_extrapolation")[Richardsonovo ekstrapolacijo]
izpeljemo kvadraturo višjega reda:

$
  I = K(h) + C h^n + cal(O)(h^(n+1))\
  I = K(h/2) + C h^n/2^n + cal(0)(h^(n+1))\
  2^n I - I = 2^n K(h/2) - K(h) + cal(O)(h^(n+1))\
  I = (2^n K(h/2) - K(h))/(2^n - 1) + cal(O)(h^(n+1)).
$<eq:13-rich>

Napako lahko ocenimo tako, da rezultat dobljen s kvadraturo $K(h)$ primerjamo z Richardsonovo
ekstrapolacijo @eq:13-rich:

$
  I - K(h) approx  2^n/(2^(n)-1)(K(h/2) - K(h))\
  I - K(h/2) approx  1/(2^(n)-1)(K(h/2) - K(h)).
$
]

Poglejmo si še en primer
$
  integral_(-1)^2 |2 - x^2| d x.
$<eq:13-abs>

Narišimo graf funkcije $g(x)=|2 - x^2|$ na intervalu $[-1, 2]$.

#demo13("# primer 2.0")


#figure(caption: [Graf funkcije $g(x)=|2 - x^2|$ na intervalu $[-1, 2]$],
  image("img/13-abs.svg", width: 60%))

Podobno kot prej bomo na grafu predstavili, kako je napaka odvisna od števila izračunanih vrednosti
funkcije. V tem primeru lahko vrednost integral izračunamo:

$
 integral_(-1)^2 |2 - x^2| d x = integral_(-1)^sqrt(2)(2 - x^2) d x +
  integral_sqrt(2)^2 -(2 - x^2) d x\
  = F(sqrt(2)) - F(-1) - (F(2) - F(sqrt(2)) = 2F(sqrt(2)) - F(1) - F(2),
$

kjer je $F(x) = integral (2-x^2) d x = 2x -x^3/3$.

#code_box[
  #repl(demo13raw("# primer 2.1"), none)
  #repl(demo13raw("# primer 2.2"), read("out/13-primer-2.2.out"))
]

Narišimo graf napake

#demo13("# primer 2.3")

#figure(caption: [Absolutna vrednost napake pri izračunu integrala @eq:13-abs z različnimi
  kvadraturami], image("img/13-napaka-abs.svg", width: 60%))

Vidimo, da pri integralu @eq:13-abs visok red kvadratur ne pomaga kaj dosti. Vse tri metode se
obnašajo približno enako. Vzrok je v tem, da funkcije $g(x)$ ni mogoče dobro aproksimirati s
polinomi. V takih primerih se bolje obnesejo
#link("https://en.wikipedia.org/wiki/Adaptive_quadrature")[adaptivne kvadraturne formule].

#opomba(naslov: [Kaj smo se naučili?])[
  - Kvadraturne formule se večinoma prevedejo na uteženo vsoto funkcijskih vrednostih v
    vozlih kvadrature.
  - Gauss-Legendreove kvadrature so najbolj primerne za integrale funkcij, ki jih lahko dobro
    aproksimiramo s polinomi.
  - Za splošno rabo so najbolj primerne adaptivne kvadrature.
]

== Rešitve

#let vaja13(koda, caption) = figure(caption: caption, code_box(jlfb("Vaja13/src/Vaja13.jl", koda)))

#vaja13("# Interval")[Podatkovni tip za zaprti interval $[a, b]$]<pr:13-Interval>
#vaja13("# Integral")[Podatkovni tip za določeni integral $integral_a^b f(x) d x$]<pr:13-Integral>
#vaja13("# Trapez")[Podatkovni tip za sestavljeno trapezno pravilo z $n$ enakomernimi koraki]<pr:13-Trapez>
#vaja13("# integriraj trapez")[Funkcija, ki izračuna integral s sestavljenim trapeznim pravilom.]<pr:13-int-trapez>
#vaja13("# Simpson")[Podatkovni tip za sestavljeno Simpsonovo pravilo z $2n$ enakomernimi koraki]<pr:13-simpson>
#vaja13("# integriraj simpson")[Funkcija, ki izračuna integral s sestavljenim Simpsonovim pravilom.]<pr:13-int-simpson>
#vaja13("# Kvadratura")[Podatkovni tip za splošno kvadraturno formulo]<pr:13-Kvadratura>
#vaja13("# integriraj gl")[Funkcija, ki izračuna integral z dano kvadraturo.]<pr:13-int-gl>
#vaja13("# glkvad")[Funkcija, ki vrne Gauss-Legendreovo kvadraturo z $n$ vozli.]<pr:13-glkvad>

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
