#import "julia.typ": code_box, jlfb, jl, repl, blk

= Avtomatsko odvajanje z dualnimi števili

V grobem poznamo tri načine, kako lahko izračunamo odvod funkcije z
računalnikom:

- #link("https://en.wikipedia.org/wiki/Computer_algebra")[simbolično odvajanje],
- #link("https://en.wikipedia.org/wiki/Numerical_differentiation")[numerično odvajanje] s
  končnimi diferencami in
- #link("https://en.wikipedia.org/wiki/Automatic_differentiation")[avtomatsko odvajanje]
  programske kode z uporabo verižnega pravila.

Pri praktični uporabi v programiranju ima simbolično odvajanje težave pri odvajanju kompleksnih
programov, saj mora program prevesti v en sam matematični izraz. Ti izrazi
lahko za programe, ki vsebujejo zanke ali rekurzijo, hitro postanejo neobvladljivi.
Pri numeričnem odvajanju imamo težave z zaokrožitvenimi napakami. Tako simbolično kot tudi
numerično odvajanje je počasno pri računanju gradientov funkcij več spremenljivk.
Avtomatsko odvajanje ne trpi za omenjenimi težavami.

V tej vaji bomo v Juliji implementirali avtomatsko odvajanje z
#link("https://en.wikipedia.org/wiki/Dual_number")[dualnimi števili].

== Naloga

- Definiraj podatkovni tip za dualna števila.
- Za podatkovni tip dualnega števila definiraj osnovne operacije in elementarne
  funkcije, kot so $sin$, $cos$ in $exp$.
- Uporabi dualna števila in izračunaj hitrost nebesnega telesa, ki se giblje po
  Keplerjevi orbiti. Keplerjevo orbito izrazimo z rešitvijo
  #link("https://en.wikipedia.org/wiki/Kepler%27s_equation")[Keplerjeve enačbe], ki jo lahko
  rešiš z Newtonovo metodo.
- Posploši dualna števila, da je komponenta pri $epsilon$ lahko vektor. Uporabi
  posplošena dualna števila za izračun gradienta funkcije več spremenljivk.
- Uporabi funkcijo za računanje gradienta za aproksimacijo podatkov z
  #link("https://en.wikipedia.org/wiki/Logistic_function")[logistično funkcijo] s
  #link("https://en.wikipedia.org/wiki/Maximum_likelihood_estimation")[cenilko največjega verjetja].

== Ideja avtomatskega odvoda

Računalniški program ni nič drugega kot zaporedje osnovnih operacij, ki jih zaporedoma
opravimo na vhodnih podatkih. Matematično lahko vsak korak programa zapišemo kot preslikavo $k_(i)$,
ki stare vrednosti spremenljivk pred izvedbo koraka preslika v nove vrednosti po izvedbi koraka.
Program si lahko predstavljamo kot kompozitum posameznih korakov
$
P = k_(n) circle.tiny k_(n-1) med dots med k_2 circle.tiny k_1.
$
Pri avtomatskem odvajanju želimo program za računanje vrednosti neke
funkcije spremeniti v program, ki poleg vrednosti funkcije računa tudi vrednost odvoda pri istih
argumentih. Matematično
== Dualna števila

#link("https://en.wikipedia.org/wiki/Dual_number")[Dualna števila] so števila
oblike $a + b epsilon$, kjer sta $a, b in RR$, medtem ko je dualna enota
$epsilon$ neničelno število katerega kvadrat je nič $epsilon eq.not 0$ in $epsilon^2 = 0$.
Podobno kot dobimo kompleksna števila, če realna števila razširimo z imaginarno enoto
$i=sqrt(-1)$,
dobimo dualna števila, če realna števila razširimo z dualno enoto $epsilon$.

Z dualnimi števili računamo kot z navadnimi binomi, pri čemer upoštevamo, da je
$epsilon^2=0$. Pri vsoti dveh dualnih števil se realna in dualna komponenta seštejeta:
$
(a + b epsilon)(c + d epsilon) = (a+b) + (c+d)epsilon.
$
Pri izpeljavi pravila za produkt moramo upoštevati lastnost $epsilon^2=0$ in da
da je produkt komutativen:
$
(a + b epsilon)(c + d epsilon) = a c + a d epsilon + b c epsilon + b d epsilon^2 =
a c + (a d + b c)epsilon.
$

Pravilo za deljenje oziroma inverz dobimo tako, da število pomnožimo
z ulomkom $1 = (a - b epsilon)/(a - b epsilon)$

$
1/(a+b epsilon) = (a - b epsilon)/((a+b epsilon)(a - b epsilon)) =
(a - b epsilon)/(a^2 + b^2 epsilon^2) = 1/a - b/a^2 epsilon.
$

Pri izpeljavi pravila za potenciranje, si pomagamo z razvojem v binomsko vrsto

$
(a + b epsilon)^n = a^n +  binom(n, n-1)a^(n-1)b epsilon + binom(n, n-2)a^(n-2)b^2epsilon^2 + dots=
a^n + n a^(n-1) b epsilon.
$

Za racionalne potence lahko uporabimo binomsko vrsto, če pa $epsilon$ nastopa v
eksponentu, pa uporabimo vrsto za $e^x$.

Dualna števila lahko uporabimo za računanje odvodov. Z dualnimi števili se namreč
računa podobno kot z diferenciali, oziroma linearnim delom Taylorjeve vrste.
Linearni del Taylorjeve vrste imenujemo tudi
#link("https://en.wikipedia.org/wiki/Jet_(mathematics)")[1-tok]. Množica 1-tokov
v neki točki predstavlja vse možne tangente na vse možne funkcije, ki gredo skozi to
točko. V točki $x_0$ lahko 1-tok funkcije $f$ zapišemo kot

$
 f(x_0) + f'(x_0)d x,
$
kjer je $d x = x - x_0$ diferencial neodvisne spremenljivke. Poglejmo si
primer 1-toka za produkt dveh funkcij $f$ in $g$:

$
(f(x_0) + f'(x)d x)(g(x_0) + g'(x_0)d x) =\
f(x_0) g(x_0) + (f(x_0)g'(x_0) + f'(x_0)g(x_0))d x + cal(O)(d x^2).
$

Vse potence $d x^k$ za $k>=2$ potisnemo v ostanek $cal(O)(d x^2)$ in
v limiti zanemarimo. Pravila računanja 1-tokov in dualnih števil so povsem
enaka. Pri računanju z differenciali ravno tako upoštevamo, da je
$d x^2 approx 0$ in vse potence $d x^k$ za $k>=2$ zanemarimo. Vrednosti odvoda v
neki točki lahko izračunamo z dualnimi števili. Če poznamo vrednost funkcije
in vrednost odvoda funkcije v neki točki, lahko z dualnimi števili
izračunamo izračunamo vrednosti odvodov različnih operacij. 1-tokove lahko
predstavimo z dualnimi števili. Če sta $f$ in $g$ funkciji, potem dualni
števili

$
f(x_0) + f'(x_0) epsilon quad #text[ in ] quad  g(x_0) + g'(x_0)epsilon
$

predstavljata 1-tokova za funkciji $f$ in $g$ v točki $x_0$. Če dualni
števili vstavimo v nek izraz npr. $x^2y$, dobimo 1-tok funkcije $f(x)^2g(x)$ in s
tem tudi vrednost odvoda v točki $x_0$.

Za primer izračunajmo odvod $f(x)^2g(x)$ v točki $x_0=1$ za funkciji
$f(x)=x^2$ in $g(x)=2-x$. Dualno število
za 1-tok za $f$ je
$
f(1) + f'(1)epsilon = 1 + 2epsilon,
$
dualno število za 1-tok za $g$ pa je
$
g(1) + g'(1)epsilon = 1 - epsilon.
$
Vstavimo zdaj dualni števili v izraz $x^2y$ in upoštevamo $epsilon^2=0$:

$
(1 + 2epsilon)^2(1 - epsilon) =
(1 + 4epsilon + 4epsilon^2)(1-epsilon) =
(1 + 4epsilon)(1-epsilon) =\ 1 + 4epsilon - epsilon -4epsilon^2=1 + 3 epsilon.
$
Od tod lahko razberemo, da je 1-tok za $(f^2g)$ v točki $1$ enak
$
(f^2g)(1) + (f^2g)'(1)epsilon = 1+ 3epsilon
$

in odvod $(f^2g)'(1)=3$.

Definirajmo podatkovni tip #jl("DualNumber"), ki predstavlja dualno število, nato pa še osnovne
računske operacije za ta tip in elementarne funkcije #jl("sin"), #jl("cos"), #jl("exp") in
#jl("log").

#let vaja15(koda) = code_box(
  jlfb("Vaja15/src/Vaja15.jl", koda)
)

#vaja15("# dual number")

== Keplerjeva enačba

#link("https://en.wikipedia.org/wiki/Kepler%27s_equation")[Keplerjeva enačba]
$
M = E - e sin(E)
$<eq:15-kepler>
določa
#link("https://sl.wikipedia.org/wiki/Ekscentri%C4%8Dna_anomalija")[ekscentrično anomalijo] za telo,
ki se giblje po Keplerjevi orbiti v odvisnoti od
#link("https://sl.wikipedia.org/wiki/Elipsa#Izsrednost_(ekscentri%C4%8Dnost)")[ekscentičnosti]
orbite $e$ in #link("https://en.wikipedia.org/wiki/Mean_anomaly")[povprečne anomalije] $M$.

Keplerjevo orbito lahko izračunamo, če poznamo $E(t)$

$
x(t)& = a(cos(E(t)) -   e)\
y(t)& = b sin(E(t)),
$

kjer so $a$ in $b$ polosi elipse. Elipsa je premaknjena tako, da je en od fokusov v točki $(0, 0)$.
Ekscentričnost $e$ je odvisna od razmerja polosi

$
e = sqrt(1-b^2/a^2) in [0, 1].
$

Vrednost $E(t)$ izračunamo iz Keplerjeve enačbe, saj velja
2. Keplerjev zakon, ki pravi, da se povprečna anomalija $M(t)$ spreminja enakomerno:

$
M(t) = n(t - t_0).
$

Keplerjeva enačba ima eno samo rešitev. Res, funkcija $f(E) = E - e sin(E)$ je naraščajoča
in surjektivna na $(-oo, oo)$, saj je odvod $f'(E) = 1 - e cos(E) >= 0$ vedno nenegativen. Keplerjevo
enačbo @eq:15-kepler predstavimo grafično:

#let demo15(koda) = code_box(
  jlfb("scripts/15_autodiff.jl", koda)
)
#demo15("# enacba")

#figure(image("img/15-enacba.svg", width: 60%),
  caption: [Leva in desna stran Keplerjeve enačbe za $M=5$ in $e=0.5$])

Vidimo, da je rešitev Keplerjeve enačbe blizu vrednosti $M$, in vrednost $M$ lahko izberemo za
začetni približek. Rešitev tako lahko hitro poiščemo z Newtonovo metodo za funkcijo:

$
g(E) = M - E + e sin(E).
$

Napišimo funkcijo #jl("keplerE(M, e)"), ki izračuna vrednost ekscentrične anomalije za dane
vrednosti ekscentičnosti $e$ in povprečne anomalije $M$. Nato napišimo funkcijo
#jl("orbita(t, a, b, n)"), ki izračuna položaj orbite v času $t$, če je v času $t=0$ telo najbližje
masnemu središču.

#figure(image("img/15-orbita.svg", width: 60%), caption: [Položaji telesa na orbiti v enakomernih
časovnih razmikih. Drugi Keplerjev zakon pravi, da zveznica med telesom
in masnim središčem, v enakem času pokrije enako ploščino.])

Hitrost telesa v določenem trenutku lahko izračunamo z avtomatskim odvodom. Najprej definiramo
dualno število $t + epsilon$ za vrednost $t$ v kateri bi radi izračunali hitrost. Nato v funkcijo
#jl("orbita")  vstavimo $t + epsilon$ in dobimo koordinate podane z dualnimi števili.

#let demo15raw(koda) = blk("scripts/15_autodiff.jl", koda)
#code_box[
 #repl(demo15raw("# hitrost 0"),read("out/15-dual-t.out"))
 #repl(demo15raw("# hitrost 1"),read("out/15-polozaj.out"))
]

Dualni del koordinat je enak vektorju hitrosti:

#code_box(repl(demo15raw("# hitrost 1"),read("out/15-hitrost.out")))

== Računajne gradientov

== Cenilka največjega verjetja
#let LL = $cal(L)$
Avtomatsko računaje gradienta bomo preiskusili pri iskanju cenilke največjega verjetja z gradientno
metodo. Cenilka največjega verjetja je izbira parametrov $phi$ verjetnostnega modela, pri kateri je
verjetje $LL(phi, x)$ največje za dane podatke $x$ in parametre $phi$. Denimo, da imamo
verjetnostni model za slučajno spremenljivko $X$, ki je odvisen od parametrov $phi$. Slučajna
spremenljivka je lahko tudi vektorska. Verjetnost, da $X$ doseže neko vrednost $bold(x)$ je
podana bodisi s funkcijo gostote verjetnosti $p(bold(x), phi)$ za zvezne spremenljivke ali s
funkcijo verjetnosti $p(bold(x), phi) = P(X=bold(X)| phi)$ za diskretne spremenljivke.
Za dano vrednost slučajne spremenljivke $bold(x)$ je funkcija verjetja funkcija odvisna od $phi$
$
phi -> p(bold(x), phi)
$


== Rešitve

#figure(caption: [Osnovne operacije med dualnimi števili], vaja15("# operacije"))
#figure(caption: [Elementarne funkcije za dualna števila], vaja15("# funkcije"))
#figure(caption: [Izračunaj odvod funkcije ene spremenljivke], vaja15("# odvod"))
#figure(caption: [Podatkovni tip za mešanico dualnih števil], vaja15("# vektor dual"))
#figure(caption: [Osnovne operacije med vektorskimi dualnimi števili], vaja15("# operacije dual"))
#figure(caption: [Elementarne funkcije za vektorska dualna števila], vaja15("# funkcije dual"))
#figure(caption: [Funkcija izračuna gradiant funkcije vektorske spremenljivke v dani točki], vaja15("# gradient"))
