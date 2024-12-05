#import "julia.typ": code_box, jlfb, jl, repl, blk
#import "admonitions.typ": opomba

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

V tej vaji bomo v Julii implementirali avtomatsko odvajanje z
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
- Uporabi funkcijo za računanje gradienta in izračunaj gradient
  #link("https://en.wikipedia.org/wiki/Ackley_function")[Ackleyeve funkcije]:
  $
  f(bold(x)) = -a exp(-b sqrt(1/d sum_(i=1)^d x_(i)^2)) - exp(1/d sum_(i=1)^d cos(c x_i)) + a + exp(1),
  $<eq:15-ackley>
  ki se uporablja za testiranje optimizacijskih algoritmov.

== Ideja avtomatskega odvoda

Računalniški program ni nič drugega kot zaporedje osnovnih operacij, ki jih zaporedoma
opravimo na vhodnih podatkih. Matematično lahko vsak korak programa zapišemo kot preslikavo $k_(i)$,
ki stare vrednosti spremenljivk pred izvedbo koraka preslika v nove vrednosti po izvedbi koraka.
Program si lahko predstavljamo kot kompozitum posameznih korakov
$
P = k_(n) circle.tiny k_(n-1) circle.tiny med dots med circle.tiny k_2 circle.tiny k_1.
$
Pri avtomatskem odvajanju želimo program za računanje vrednosti neke
funkcije spremeniti v program, ki poleg vrednosti funkcije računa tudi vrednost odvoda pri istih
argumentih. Matematično lahko program ali funkcijo obravnavamo kot preslikavo med vhodnimi argumenti
in izhodnimi vrednostmi:
$
P: RR^n -> RR^m
$

Vsak korak programa je prav tako preslikava $k_(i): RR^(n_i)-> RR^(m_i)$. Če uporabimo verižno
pravilo, je odvod programa $P$ z danimi argumenti $bold(x)$ enak produktu:

$
D P(bold(x)) = D k_(n)(bold(x)_(n-1)) dot.c D k_(n-1)(bold(x)_(n-2))med  dots.c med D k_1(bold(x)_0),
$<eq:15-verizno>

kjer je $bold(x)_i = k_(i)(k_(i-1) dots k_2(k_1(bold(x)))dots)$ stanje lokalnih spremenljivk po tem,
ko se je izvedel $i$-ti korak.

Oglejmo si preprost primer funkcije, ki z Newtonovo metodo izračuna kvadratni koren.

#let demo15(koda) = code_box(
  jlfb("scripts/15_autodiff.jl", koda)
)
#demo15("# koren")

V programu moramo odvajati vsako vrstico kode posebej. Poglejmo prvo vrstico funkcije
#jl("koren")

#code_box(jl("y = 1 + (x-1)/2"))

Nova lokalna spremenljivka $y$ je funkcija $x$ in njen odvod je

$
y'(x) = (1 + (x - 1)/2)' = 1/2.
$

V zanki nato ponavljamo

#code_box(jl("y = (y - x/y)/2"))

Označimo z $y_i$ vrednost spremenljivke $y$ na $i$-tem koraku zanke.
Vrednost $y_i$ je odvisna od vrednosti $x$, za njen izračun potrebujemo tudi vrednost
$y$ na prejšnjem koraku $y_(i-1)(x)$. Vrstico programa lahko zapišemo kot rekurzivno enačbo

$
 y_(i)(x) = 1/2 (y_(i-1)(x) - (x)/(y_(i-1)(x))).
$

Če rekurzivno enačbo odvajamo, dobimo

$
y'_(i)(x) = 1/2 (y'_(i-1)(x) - 1/(y_(i-1)(x)) - (x y'_(i-1)(x))/(y_(i-1)(x)^2)).
$

Program #jl("koren") dopolnimo, da hkrati računa vrednosti funkcije in vrednosti odvoda. To storimo
tako, da na vsakem koraku posodobimo vrednosti odvodov spremenljivk, ki jih na tem koraku
posodobimo.

#demo15("# dkoren")

Preverimo, če naša funkcija deluje. Odvod korenske funkcije je enak $(sqrt(x))' = 1/(2 sqrt(x))$.

#let demo15raw(koda) = blk("scripts/15_autodiff.jl", koda)
#code_box[
  #repl(demo15raw("# koren 2"), read("out/15-koren.out"))
  #repl(demo15raw("# koren 3"), read("out/15-napaka.out"))

]

== Dualna števila

#link("https://en.wikipedia.org/wiki/Dual_number")[Dualna števila] so števila
oblike $a + b epsilon$, kjer sta $a, b in RR$, medtem ko je dualna enota
$epsilon$ neničelno število katerega kvadrat je nič: $epsilon eq.not 0$ in $epsilon^2 = 0$.
Podobno kot dobimo kompleksna števila, če realna števila razširimo z imaginarno enoto
$i=sqrt(-1)$,
dobimo dualna števila, če realna števila razširimo z dualno enoto $epsilon$.

Z dualnimi števili računamo kot z navadnimi binomi, pri čemer upoštevamo, da je
$epsilon^2=0$. Pri vsoti dveh dualnih števil se realna in dualna komponenta seštejeta:
$
(a + b epsilon)(c + d epsilon) = (a+b) + (c+d)epsilon.
$
Pri izpeljavi pravila za produkt moramo upoštevati lastnost $epsilon^2=0$ in
komutativnost produkta z $epsilon$:
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
(f(x_0) + f'(x)d x)(g(x_0) + g'(x_0)d x)\
= f(x_0) g(x_0) + (f(x_0)g'(x_0) + f'(x_0)g(x_0))d x + cal(O)(d x^2).
$

Vse potence $d x^k$ za $k>=2$ potisnemo v ostanek $cal(O)(d x^2)$ in
v limiti zanemarimo. Pravila računanja 1-tokov in dualnih števil so povsem
enaka. Pri računanju z diferenciali ravno tako upoštevamo, da je
$d x^2 approx 0$ in vse potence $d x^k$ za $k>=2$ zanemarimo. Vrednosti odvoda v
neki točki lahko izračunamo z dualnimi števili. Če poznamo vrednost funkcije
in vrednost odvoda funkcije v neki točki, lahko z dualnimi števili
izračunamo izračunamo vrednosti odvodov različnih operacij. Z dualnimi števili lahko
predstavimo 1-tokove. Če sta $f$ in $g$ funkciji, potem dualni
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
(1 + 4epsilon)(1-epsilon)\
= 1 + 4epsilon - epsilon -4epsilon^2=1 + 3 epsilon.
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
ki se giblje po Keplerjevi orbiti v odvisnosti od
#link("https://sl.wikipedia.org/wiki/Elipsa#Izsrednost_(ekscentri%C4%8Dnost)")[ekscentričnosti]
orbite $e$ in #link("https://en.wikipedia.org/wiki/Mean_anomaly")[povprečne anomalije] $M$.

Keplerjevo orbito lahko izračunamo, če poznamo $E(t)$

$
x(t)& = a(cos(E(t)) -   e)\
y(t)& = b sin(E(t)),
$

kjer sta $a$ in $b$ polosi elipse ($a<=b$). Elipsa je premaknjena tako, da je eno od gorišč v točki $(0, 0)$.
Ekscentričnost $e$ je odvisna od razmerja polosi

$
e = sqrt(1-b^2/a^2) in [0, 1].
$

Vrednost $E(t)$ izračunamo iz Keplerjeve enačbe, saj velja
drugi Keplerjev zakon, ki pravi, da se povprečna anomalija $M(t)$ spreminja enakomerno:

$
M(t) = n(t - t_0).
$

Keplerjeva enačba ima eno samo rešitev. Res, funkcija $f(E) = E - e sin(E)$ je naraščajoča
in surjektivna na $(-oo, oo)$, saj je odvod $f'(E) = 1 - e cos(E) >= 0$ vedno nenegativen. Keplerjevo
enačbo @eq:15-kepler predstavimo grafično:

#demo15("# enacba")

#figure(image("img/15-enacba.svg", width: 60%),
  caption: [Leva in desna stran Keplerjeve enačbe za $M=5$ in $e=0.5$])

Vidimo, da je rešitev Keplerjeve enačbe blizu vrednosti $M$, saj je $e sin(E)$ relativno
majhen v primerjavi z $M$. ZAto je vrednost $M$ dober začetni približek za rešitev enačbe
@eq:15-kepler. Rešitev lahko hitro poiščemo z Newtonovo metodo za funkcijo:

$
g(E) = M - E + e sin(E).
$

Napišimo funkcijo #jl("keplerE(M, e)"), ki izračuna vrednost ekscentrične anomalije za dane
vrednosti ekscentričnosti $e$ in povprečne anomalije $M$. Nato napišimo funkcijo
#jl("orbita(t, a, b, n)"), ki izračuna položaj orbite v času $t$, če je v času $t=0$ telo najbližje
masnemu središču.

#figure(image("img/15-orbita.svg", width: 60%), caption: [Položaji telesa na orbiti v enakomernih
časovnih razmikih. Drugi Keplerjev zakon pravi, da zveznica med telesom
in masnim središčem v enakem času pokrije enako ploščino.])

Hitrost telesa v določenem trenutku lahko izračunamo z avtomatskim odvodom. Najprej definiramo
dualno število $t + epsilon$ za vrednost $t$ v kateri bi radi izračunali hitrost. Nato v funkcijo
#jl("orbita")  vstavimo $t + epsilon$ in dobimo koordinate podane z dualnimi števili.

#code_box[
 #repl(demo15raw("# hitrost 0"),read("out/15-dual-t.out"))
 #repl(demo15raw("# hitrost 1"),read("out/15-polozaj.out"))
]

Dualni del koordinat je enak vektorju hitrosti:

#code_box(repl(demo15raw("# hitrost 1"),read("out/15-hitrost.out")))


#opomba(naslov:[Avtomatsko odvajanje kontrolnih struktur])[
  Kontrolne strukture kot na primer #jl("if") stavek lahko
 povzročijo razvejitve v programu in funkcija, ki jo program izračuna ni
 nujno zvezno odvedljiva. Če avtomatsko odvajamo tak program, dobimo odvod
 tiste veje, ki se za dane vhodne vrednosti izvede. Za večino vhodnih vrednosti
 se ta ujema z dejanskim odvodom. Za mejne vrednosti, pri katerih se program
 razveji, pa dobimo bodisi levi bodisi desni odvod. Odvisno od tega, katera
 veja se izvede. Poglejmo si primer implementacije funkcije $f(x) = |x|$:

 #code_box[
   ```jl
function f(x)
  if x>=0
    return x
  else
    return -x
  end
end
   ```
 ]

Funkcija je zvezno odvedljiva povsod razen v točki $0$. Če v funkcijo vstavimo $x=0$ oziroma
dualno število $0 + epsilon$, se izvede prva veja in izračuni odvod je enak $1$. Kar je enako
desnemu odvodu funkcije $|x|$ v točki $0$.
]

#opomba(naslov: [Tabeliranih funkcij ne moremo avtomatsko odvajati])[
Avtomatsko odvajanje deluje le za funkcije, ki so implementirane s programom.
Če je funkcija podana s tabelo funkcijskih vrednosti,
avtomatsko odvajanje ni mogoče. V tem primeru uporabimo končne diference.
]
== Računajne gradientov

Parcialne odvode funkcije več spremenljivk lahko ravno tako izračunamo z
dualnimi števili. Pri tem moramo paziti, da za odvode po različnih spremenljivkah
uporabimo neodvisne dualne enote. Poglejmo si primer funkcije dveh spremenljivk
$
  f(x, y) = x^2y + y^3sin(x).
$
Ker imamo dva neodvisna parcialna odvoda $partial / (partial x)$ in $partial / (partial y)$,
potrebujemo dve neodvisni dualni enoti $epsilon_x$ in $epsilon_y$, ki zadoščata
pogojem:
$
  epsilon_x^2=0, quad epsilon_y^2 = 0 quad #text[ in ] epsilon_x epsilon_y = 0.
$
V funkcijo $f$ vstavimo $x + epsilon_x$ in $y + epsilon_y$ in dobimo
v 1-tok funkcije $f(x, y)$:
$
  f(x + epsilon_x, y + epsilon_y)& = (x + epsilon_x)^2(y + epsilon_y) +
  (y + epsilon_y)^3sin(x + epsilon_x)\
  =&(x^2 + 2x epsilon_x)(y + epsilon_y) + (y^3 + 3y^2 epsilon_y)(sin(x) + cos(x)epsilon_x)\
  =&x^2y + y^3sin(x) + 2x y epsilon_x + x^2 epsilon_y + 3y^2sin(x)epsilon_y +y^3cos(x)epsilon_x\
  =&f(x, y) + (2x y + y^3cos(x))epsilon_x + (x^2 + 3y^2sin(x))epsilon_y.
$
Vidimo, da sta koeficienta pri $epsilon_x$ in $epsilon_y$ ravno parcialna odvoda

$
  (partial f)/(partial x)(x, y) &= 2x y + y^3cos(x)\
  (partial f)/(partial y)(x, y) &= x^2 + 3y^2sin(x).
$

Za lažjo implementacijo koeficiente pri $epsilon_x$ in $epsilon_y$ postavimo v
vektor in zapišemo

$
  epsilon_x = vec(1, 0)epsilon, quad epsilon_y = vec(0, 1)epsilon.
$

Za funkcijo $n$ spremenljivk $f(x_1, x_2, med dots, med x_n)$ dobimo:

$
  epsilon_1 = vec(1, 0, dots.v, 0)epsilon, quad
  epsilon_2 = vec(0, 1, dots.v, 0)epsilon, quad dots quad
  epsilon_(n) = vec(0, 0, dots.v, 1)epsilon
$
in
$
f(x_1 + epsilon_1, x_2 + epsilon_2, med dots med x_(n) + epsilon_n) =
  f(x_1, x_2,  med dots x_(n)) + nabla f(x_1, x_2, med dots x_(n))epsilon.
$

V Julii definirajmo vektorska dualna števila tipa #jl("Dual"), ki opisujejo
elemente oblike
$
  a + vec(b_1, b_2, dots.v, b_(n))epsilon, quad a, b_1, b_2, dots, b_n in RR.
$

Podobno kot pri navadnih dualnih številih nato definiramo osnovne računske
operacije in nekatere elementarne funkcije (@pr:15-dual, @pr:15-dual-op).

#opomba(naslov: [Odvajanje naprej, odvajanje nazaj]
)[
Z dualnimi števili lahko učinkovito računamo odvode in gradiente funkcij, ki so
implementirane s programom.
To metodo lahko posplošimo tudi na računaje Jacobijevih matrik in višjih odvodov.
V osnovi metoda temelji na verižnem pravilu in zapisu programa kot kompozituma posameznih
korakov. Formula @eq:15-verizno predstavlja odvod kot produkt
matrik
$
  D P(bold(x)) = D k_(n)(bold(x)_(n-1)) dot.c D k_(n-1)(bold(x)_(n-2)) med dots.c med D k_1(bold(x)).
$<eq:15-produkt-odvodov>

Matrike $D k_(i)(bold(x)_(i-1))$ so lahko različnih dimenzij in vrstni red množenja
posameznih faktorjev vpliva na velikost spomina, ki ga potrebujemo.

V praksi sta se uveljavila dva načina računanja produkta. Produkt @eq:15-produkt-odvodov
lahko računamo sproti, tako da zmnožimo matrike takoj, ko so na voljo. To pomeni, da množimo z desne.
Če metoda deluje na ta način, pravimo, da uporablja #emph[način odvajanje naprej]
(angl. #emph[forward mode]).

Drug razred metod, ki ga imenujemo #emph[način odvajanja nazaj] (angl.
#emph[backward mode]),
množi matrike v produktu @eq:15-produkt-odvodov z leve. To pa pomeni, da odvodov
ni mogoče izračunati dokler izračun vrednosti funkcije ni končan. Pri odvajanju nazaj
si mora program zapomniti vmesne vrednosti $bold(x)_k$ do konca izračuna.

Metode računanja nazaj so navadno implementirane kot transformacija izvorne kode, medtem ko
metode računanja naprej navadno implementiramo z definicijo novih podatkovnih tipov
ali razredov.

Računanje z dualnimi števili uporablja način odvajanja naprej.
]
== Gradient Ackleyeve funkcije

Izračunajmo gradient funkcije #link("https://en.wikipedia.org/wiki/Ackley_function")[Ackleyeve funkcije]:
$
f(bold(x)) = -a exp(-b sqrt(1/d sum_(i=1)^d x_(i)^2)) - exp(1/d sum_(i=1)^d cos(c x_i)) + a + exp(1),
$<eq:15-ackley>
ki se uporablja za testiranje optimizacijskih algoritmov. Najprej napišimo funkcijo v Julii, ki
izračuna vrednost Ackleyeve funkcije:

#figure(caption: [Funkcija za izračun Ackleyeve funkcije], demo15("# ackley"))

Gradient izračunamo tako, da za vhodni vektor $bold(x)_0$ ustvarimo
vektor dualnih vektorskih števil in ga vstavimo v funkcijo.
Dimenzija dualnega dela (vektorja ob $epsilon$) je enaka dimenziji
vhodnega vektorja $bold(x)_0$.

#code_box[
  #repl(demo15raw("# ack 0"), none)
  #repl(demo15raw("# ack 1"), read("out/15-ackley-1.out"))
  #repl(demo15raw("# ack 2"), read("out/15-ackley-2.out"))
  #repl(demo15raw("# ack 3"), read("out/15-ackley-3.out"))
]

Dualni del rezultata je enak gradientu funkcije.

#opomba(naslov: [Knjižnice za avtomatsko odvajanje])[
  Knjižnice za avtomatsko odvajanje obstajajo za večino programskih jezikov, ki se uporabljajo za numerične izračune. V Julii so poleg #jl("ForwardDiff") na voljo še drugi paketi. Paketi so zbrani v neformalni organizaciji #link("https://juliadiff.org/")[JuliaDiff].  
]

#opomba(naslov: [Kaj smo se naučili?])[
  - Odvode programov učinkovito računamo z avtomatskim odvajanjem.
  - Obstajata dva načina avtomatskega odvajanja: #emph[način odvajanja naprej] in
    #emph[način odvajanja nazaj].
  - Odvajanje naprej lahko implementiramo z dualnimi števili.
]

== Rešitve

#figure(caption: [Osnovne operacije med dualnimi števili], vaja15("# operacije"))
#figure(caption: [Elementarne funkcije za dualna števila], vaja15("# funkcije"))
#figure(caption: [Funkcija, ki izračuna odvod funkcije ene spremenljivke.], vaja15("# odvod"))
#figure(caption: [Podatkovni tip za mešanico dualnih števil], vaja15("# vektor dual"))<pr:15-dual>
#figure(
  caption: [Osnovne operacije med vektorskimi dualnimi števili],
  vaja15("# operacije dual"))<pr:15-dual-op>
#figure(caption: [Elementarne funkcije za vektorska dualna števila], vaja15("# funkcije dual"))
#figure(caption: [Funkcija, ki izračuna gradient funkcije vektorske spremenljivke v dani točki.],
  vaja15("# gradient"))
