#import "julia.typ": code_box, jl, jlfb, repl, blk
#import "admonitions.typ": opomba

= Začetni problem za NDE

Navadna diferencialna enačba (NDE) prvega reda

$
u'(t) = f(t, u, p)
$

ima enolično rešitev za vsak začetni pogoj $u(t_0) = u_0$. Iskanje rešitve NDE z danim začetnim
pogojem imenujemo #link("https://en.wikipedia.org/wiki/Initial_value_problem")[začetni problem].

V tej vaji bomo napisali knjižnico za reševanje začetnega problema za NDE.

== Naloga

1. Definiraj podatkovno strukturo, ki hrani podatke o začetnemu problemu za NDE.
2. Definiraj podatkovno strukturo, ki hrani podatke o rešitvi začetnega problema.
3. Implementiraj funkcijo `resi`, ki poiščejo približek za rešitev začetnega
   problema z različnimi metodami:
  - z Eulerjevo metodo,
  - z metodo Runge-Kutta reda 2,
  - z metodo Runge-Kutta reda 4.
4. Napiši funkcijo `vrednost`, ki za dano rešitev začetnega problema izračuna vrednost rešitve v vmesnih
  točkah s Hermitovim kubičnim zlepkom (@sec:12-zlepki).
Napisane funkcije uporabi za obravnavo poševnega meta z upoštevanjem zračnega upora.
Iz Newtonovih zakonov gibanja in kvadratnega zakona upora zapiši sistem NDE.
Kako daleč leti telo, preden pade na tla? Koliko časa leti?

Za vse tri metode bomo oceni, kako se napaka spreminja v odvisnosti od dolžine koraka.
Namesto točne rešitve uporabi približek, ki ga izračunaš s polovičnim korakom.

== Reševanje enačbe z eno spremenljivko

Poglejmo, kako numerično poiščemo rešitev diferencialne enačbe z
eno spremenljivko. Reševali bomo le enačbe, pri katerih lahko odvod eksplicitno izrazimo. Take
enačbe lahko zapišemo v obliki

$
u'(t) = f(t, u(t)),
$

za neko funkcijo dveh spremenljivk $f(t, u)$. Funkcija $f(t, u)$ določa odvod $u'(t)$ in s tem
tangento na rešitev $u(t)$ v točki $(t, u(t))$. Za vsako točko $(t, u)$ dobimo tangento oziroma
smer v kateri se rešitev premakne. Funkcija $f(t, u)$ tako določa smerno polje v ravnini $(t, u)$.

Za primer vzemimo enačbo:

$
u'(t) = -2 t u(t),
$<eq:16-nde1>

ki jo znamo tudi analitično rešiti in ima splošno rešitev

$
u(t) = C e^(-t^2), quad C in RR.
$

#let demo16(koda) = code_box(
  jlfb("scripts/16_nde.jl", koda)
)

Poglejmo, kako je videti smerno polje za enačbo @eq:16-nde1. Tangente vzorčimo na pravokotni
mreži na pravokotniku $(t, u) in [-2, 2] times [0, 4]$. Za eksplicitno podano krivuljo $u = u(t)$ je
vektor v smeri tangente podan s koordinatami $[1, u'(t)]$. Da dobimo lepšo sliko, vektor v smeri
tangente normaliziramo in pomnožimo s primernim faktorjem, da se tangente na sliki ne prekrivajo.
Napišimo funkcijo #jl("risi_polje(fun, (t0, tk), (u0, uk), n)"), ki nariše polje tangent za
diferencialno enačbo (@pr:16-polje-smeri, @pr:16-risi-polje).

Narišimo polje smeri za enačbo @eq:16-nde1:

#demo16("# polje slika")

Narišimo še nekaj začetnih pogojev in rešitev, ki gredo skoznje.

#demo16("# zacetni pogoj")

#figure(
  kind: image,
  table(columns: 2, stroke: none,
  image("img/16-polje.svg"),
  image("img/16-resitve.svg")
  ),
  caption: [Levo: Smerno polje za enačbo $u'(t) = -2t u(t)$. V vsaki točki ravnine $(t, u)$ enačba
  definira odvod $u'(t) = f(t, u)$ in s tem tudi tangento na rešitev enačbe $u(t)$.
  Desno: Vsaka točka $(t_0, u_0)$ v ravnini $t, u$ določa začetni pogoj. Za različne začetne pogoje
 dobimo različne rešitve. Rešitev NDE se v vsaki točki dotika tangente, določene z
 $u'(t) = f(t, u)$.]
)

Diferencialna enačba @eq:16-nde1 ima neskončno rešitev. Čim pa določimo vrednost v neki
točki $u(t_0)=u_0$, ima enačba @eq:16-nde1 enolično rešitev $u(t)$. Pogoj $u(t_0)=u_0$ imenujemo
#emph[začetni pogoj], diferencialno enačbo skupaj z začetnim pogojem

$
  u'(t) &= f(t, u)\
  u(t_0) &= u_0
$<eq:16-zacetni-problem>

pa #emph[začetni problem].

Rešitev začetnega problema @eq:16-zacetni-problem je funkcija $u(x)$. Funkcijo $u(x)$ lahko
numerično opišemo na mnogo različnih načinov. Dva načina, ki se pogosto uporabljata, sta:
- z vektorjem vrednosti $[u_0, u_1, med dots med u_n]$ v danih točkah $t_0, t_1, med dots t_n$ ali
- z vektorjem koeficientov $[a_0, a_1 med dots med a_n]$ v razvoju $u(t) = sum a_k phi_k(t)$
  po dani bazi $phi_k(t)$.

Metode, ki poiščejo približek za vektor vrednosti, imenujemo
#link("https://en.wikipedia.org/wiki/Collocation_method")[kolokacijske metode], metode, ki poiščejo
približek za koeficiente v razvoju po bazi, pa
#link("https://en.wikipedia.org/wiki/Spectral_method")[spektralne metode].
Metode, ki jih bomo spoznali v nadaljevanju, uvrščamo med kolokacijske metode.

== Eulerjeva metoda

Najpreprostejša metoda za reševanje začetnega problema je
#link("https://en.wikipedia.org/wiki/Euler_method")[Eulerjeva metoda].
Za dani začetni problem @eq:16-zacetni-problem bomo poiskali vrednosti $u_i = u(t_i)$ v
točkah $t_0 < t_1 < med dots med t_n=t_k$ na intervalu $[t_0, t_k]$. Vrednosti $u_i$ poiščemo tako,
da najprej izračunamo približek $u_1$ za $t_1$ in nato z isto metodo rešimo začetni
problem z začetnim pogojem $u(t_1) = u_1$. Pri Eulerjevi metodi naslednjo vrednost dobimo tako, da
izračunamo vrednost na tangenti v točki $(t_k, u_k)$. Tako rekurzivno dobimo približke za vrednosti
v točkah $t_1, t_2, med dots t_n$:

$
  u_(k+1) = u_k + f(t_k, u_k)(t_(k+1) - t_k).
$<eq:16-euler>

Zapišimo sedaj funkcijo #jl("u, t = euler(fun, u0, (t0, tk), n)"), ki implementira Eulerjevo metodo
s konstantnim korakom.

#demo16("# euler 1")

#figure(
  image("img/16-euler.svg", width: 60%),
  caption: [Približna rešitev začetnega problema za enačbo $u' = -2 t u$ z začetnim pogojem
  $u(-0.5) = 1$ na intervalu $[-0.5, 0.5]$. Približki so izračunani s 4 in 8 koraki Eulerjeve
  metode. Več korakov kot naredimo, boljši je približek za rešitev.
  // Vsak približek definira nov začetni problem za isto enačbo z drugimi začetnimi pogoji. Na grafu so prikazane tudi rešitve začetnih problemov v izračunanih približkih.
  ]
)

== Ogrodje za reševanje NDE

V nadaljevanju bomo definirali tipe in funkcije, ki bodo omogočali enotno obravnavo
reševanja začetnega problema in enostavno dodajanje različnih metod za reševanje NDE. Pri tem
se bomo zgledovali po paketu
#link("https://docs.sciml.ai/DiffEqDocs/stable/")[DifferentialEquations.jl] (glej @rackauckas2017
za podrobnejšo razlago).

#let vaja16(koda) = code_box(jlfb("Vaja16/src/Vaja16.jl", koda))

Definirajmo podatkovni tip #jl("ZacetniProblem"), ki vsebuje vse podatke o začetnem problemu
@eq:16-zacetni-problem. Uporabili ga bomo kot vhodni podatek za funkcije, ki bodo poiskale
numerično rešitev.

#figure(
  vaja16("# ZacetniProblem"),
  caption: [Podatkovni tip, ki vsebuje vse podatke o začetnem problemu]
)

Približke, ki jih bomo izračunali z različnimi metodami, bomo shranili v poseben podatkovni tip
#jl("ResitevNDE"). Poleg vrednosti neodvisne spremenljivke in izračunane približke rešitve bomo
v tipu #jl("ResitevNDE") hranili tudi vrednosti odvodov, ki jih izračunamo s smernim poljem NDE. Odvode bomo potrebovali za izračun vmesnih vrednosti s Hermitovim zlepkom.

#figure(
  vaja16("# ResitevNDE"),
  caption: [Podatkovni tip, ki vsebuje numerično rešitev začetnega problema]
)

Definirajmo podatkovni tip #jl("Euler"), ki vsebuje parametre za Eulerjevo metodo.
Nato napišimo funkcijo #jl("resi(p::ZacetniProblem, metoda::Euler)"), ki poišče rešitev začetnega
problema z Eulerjevo metodo (za rešitev glej @pr:16-euler-resi).

Ponovno rešimo začetni problem
$
  u'(t) &= -2 t u\
  u(-0.5)& = 1.
$

Faktor $-2$ v enačbi $u'(t) = - 2 t u$ lahko obravnavamo kot parameter enačbe. Ker poznamo točno rešitev $u(t) = e^(-t^2/sqrt(2))$ lahko izračunamo napako. Narišimo napako Eulerjeve metode za dve različni velikosti koraka.

#demo16("# euler 2")

#figure(
  image("img/16-euler-napaka.svg", width: 60%), caption: [Napaka Eulerjeve metode za začetni problem $u' = -2 u t; quad u(-0.5)=1$ pri
    različnih velikostih koraka $h=0.1$ in $h=0.05$]
)

#opomba(naslov: [Večlična razdelitev in posebni podatkovni tipi omogočajo abstraktno obravnavo])[
Uporaba specifičnih tipov omogoča definicijo specifičnih metod, ki so posebej napisane za posamezen
primer. Taka organizacija kode omogoča večjo abstrakcijo in definicijo
#link("https://en.wikipedia.org/wiki/Domain-specific_language")[domenskega jezika], ki je
prilagojen posameznemu področju. Tako lahko obravnavamo o #jl("ZacetniProblemNDE") namesto funkcije in vektorja, ki vsebujejo dejanske podatke. Vrednost tipa #jl("ResitevNDE") se
razlikuje od vektorjev in matrik, ki jih vsebuje, predvsem v tem, da Julia ve, da gre za podatke,
ki so numerični približek za rešitev začetnega problema. To prevajalniku omogoča, da za dane podatke
avtomatično uporabi metode glede na vlogo, ki jo imajo v danem kontekstu. Takšna organizacija je zelo
prilagodljiva in omogoča enostavno dodajanje novih numeričnih metod ali novih
formulacij problema samega.
]

== Metode Runge - Kutta

Implementirajmo še metodi Runge - Kutta drugega in četrtega reda podani z Butcherjevima tabelama

$
#table(columns: 2, stroke: none, align: bottom,
  table(columns:3, stroke: none,
    table.vline(x: 1, stroke: 0.5pt),
    $0$, none, none,
    $1$, $1$, none,
    table.hline(stroke: 0.5pt),
    none, $1/2$, $1/2$),
  table(columns:5, stroke: none,
    table.vline(x:1, stroke: 0.5pt),
    $0$, none, none, none, none,
    $1/2$, $1/2$, none, none, none,
    $1/2$, $0$, $1/2$, none, none,
    $1$, $0$, $0$, $1$, none,
    table.hline(stroke: 0.5pt),
    none, $1/6$, $1/3$, $1/3$, $1/6$)
)
$

Naslednji približek za $u_(n+1) = u(t_(n)+h)$ za metodo drugega reda lahko zapišemo kot:

$
k_1 &= h f(t_(n), u_(n), p)\
k_2 &= h f(t_(n) + h, u_(n) + k_1, p)\
u_(n+1) &= u_n + 1/2(k_1 + k_2).
$<eq:16-rk2>

Za metodo četrtega reda pa je naslednji približek enak:

$
k_1 &= h f(t_(n), u_(n), p)\
k_2 &= h f(t_(n) + 1/2 h, u_(n) + 1/2 k_1, p)\
k_3 &= h f(t_(n) + 1/2 h, u_(n) + 1/2 k_2, p)\
k_4 &= h f(t_(n) + h, u_(n) + k_3, p)\
u_(n+1) &= u_n + 1/6(k_1 + 2k_2 + 2k_3 + k_4).
$<eq:16-rk4>

Definirajmo:
- podatkovni tip #jl("RK2"), ki predstavlja metodo drugega reda @eq:16-rk2 in funkcijo
  #jl("korak(m::RK2, fun, t0, u0, par, smer)"), ki izračuna približek na naslednjem koraku
  (@pr:16-rk2),
- podatkovni tip  #jl("RK4"), ki predstavlja metodo četrtega reda @eq:16-rk4 in funkcijo
  #jl("korak(m::RK4, fun, t0, u0, par, smer)"), ki izračuna približek na naslednjem koraku
  (@pr:16-rk4).

== Hermitova interpolacija

Približne metode za začetni problem NDE izračunajo približke za rešitev zgolj v nekaterih vrednostih
spremenljivke $t$. Vrednosti rešitve diferencialne enačbe lahko interpoliramo s
#link("https://en.wikipedia.org/wiki/Cubic_Hermite_spline")[kubičnim Hermitovim zlepkom], ki smo ga
že spoznali v poglavju o zlepkih (@sec:12-zlepki). Hermitov
zlepek je na intervalu $[t_i, t_(i+1)]$ določen z vrednostmi rešitve in odvodi v krajiščih
intervala. Ti podatki so shranjeni v vrednosti tipa #jl("ResitevNDE").
Napišimo sedaj funkcijo #jl("vrednost(res::ResitevNDE, t)"), ki vrne približek
za rešitev NDE v dani točki (@pr:16-vrednost). Vrednosti rešitve lahko na ta način izračunamo tudi
za argumente $t$, ki so med približki, ki jih izračuna Eulerjeva ali kakšna druga metoda.
Prikažemo Hermitovo interpolacijo na grafu:

#demo16("# plot hermite")

#figure(
  image("img/16-hermite.svg", width: 60%),
  caption: [Vmesne vrednosti med približki metode Runge - Kutta reda 2 interpoliramo s Hermitovim
  zlepkom.]
)
== Poševni met z upoštevanja zračnega upora

Poševni met opisuje gibanje točkastega telesa pod vplivom gravitacije. Enačbe, ki opisujejo poševni
met, izpeljemo iz #link("https://sl.wikipedia.org/wiki/Newtonovi_zakoni_gibanja")[Newtonovih zakonov
gibanja]. Položaj telesa v vsakem trenutku opišemo z vektorjem položaja $bold(x) = [x, y, z]^T in RR^3$. Trajektorija
opisuje položaj v odvisnoti od časa in je podana kot krivulja $bold(x)(t)$. Označimo vektor hitrosti z
$
bold(v)(t)=dot(bold(x))(t) = (d bold(x))/(d t)
$
in vektor pospeška z
$
bold(a)(t) = dot.double(bold(x))(t) = (d bold(v)(t))/(d t) = (d^2 bold(x)(t))/(d t^2).
$
Gibanje točkastega telesa z maso $m$ pod vplivom vsote vseh sil $bold(F)$, ki delujejo na
dano telo, opiše 2. Newtonov zakon:

$
bold(F) = m bold(a)(t).
$<eq:16-2-newtonov-zakon>

Sile, ki delujejo na telo, so lahko odvisne tako od položaja kot tudi od hitrosti. Sili, ki delujeta
na telo pri poševnem metu, sta sila teže $bold(F)_g$ in sila zračnega upora $bold(F)_u$. Predpostavimo
lahko, da velja
#link("https://sl.wikipedia.org/wiki/Upor_sredstva#Kvadratni_zakon_upora")[kvadratni zakon upora],
po katerem je velikost sile upora sorazmerna kvadratu velikosti hitrosti. Sila upora vedno kaže v
nasprotno smer kot hitrost, zato lahko zapišemo:
$
bold(F)_u = -C' bold(v)norm(bold(v)),
$
kjer je parameter $C'$ odvisen od gostote medija in oblike ter velikosti  telesa. Sila teže kaže
vertikalno navzdol in je sorazmerna masi in težnemu pospešku $g$:
$
bold(F)_g = m bold(g) = -m g vec(0, 0, 1),
$
kjer je $bold(g) = g [0, 0, -1]^T$ vektor težnega pospeška. Vsoto vseh sil lahko zapišemo kot

$
bold(F) = -m bold(g) - C' bold(v)norm(bold(v)).
$<eq:16-vsota-sil>

Ko vstavimo @eq:16-vsota-sil v drugi Newtonov zakon @eq:16-2-newtonov-zakon, dobimo sistem enačb 2.
reda:

$
dot.double(bold(x))(t) = bold(a)(t) = bold(F)/m = bold(g) -
  C dot(bold(x))(t)norm(dot(bold(x))(t)),
$<eq:16-sistem-2-reda>

kjer je $C = C'/m$. Če želimo uporabiti metode za numerično reševanje diferencialnih enačb, moramo sistem
@eq:16-sistem-2-reda prevesti na sistem enačb 1. reda. To naredimo tako, da vpeljemo nove
spremenljivke za komponente odvoda $dot(bold(x))(t)$. Oznake za nove spremenljivke se ponujajo kar
same $bold(v)(t) = dot(bold(x))(t)$. Sistem enačb 2. reda @eq:16-sistem-2-reda je ekvivalenten
sistemu enačb 1. reda:

$
dot(bold(x))(t) &= bold(v)(t)\
dot(bold(v))(t) &= bold(g) - C dot(bold(x))(t)norm(dot(bold(x))(t)).
$<eq:16-sistem-1-reda>

V enačbah @eq:16-sistem-1-reda se v resnici skriva 6 enačb, po ena za vsako komponento vektorjev
$bold(x)$ in $bold(v)$.

Zapišimo vrednost tipa #jl("ZacetniProblem"), ki opiše začetni problem za enačbe
@eq:16-sistem-1-reda. Vektorja $bold(x)$ in $bold(v)$ združimo v en vektor s 6 komponentami:

$
bold(u)(t)=vec(x, y, z, v_x, v_y, v_z)
$

in napišemo funkcijo #jl("f_posevni(t, u, p)"), ki izračuna vektor desnih stani enačb
@eq:16-sistem-1-reda:

#demo16("# posevni")

Primerjali bomo vse tri metode, ki smo jih spoznali. Za različne vrednosti koraka bomo
izračunali približek in ga primerjali s pravo rešitvijo. Ker prave rešitve ne poznamo, bomo namesto nje
uporabili približek, ki ga dobimo z metodo Runge-Kutta 4. reda s polovičnim korakom. Napako bomo
ocenili tako, da bomo poiskali največno napako med različnimi vrednostimi $t$ na danem intervalu
$[t_0, t_k]$.

#demo16("# napaka")

#figure(image("img/16-primerjava.svg", width: 60%), caption: [Napaka za različne metode v logaritemski skali v
odvisnosti od velikosti koraka])

#opomba(naslov: [Kako izbrati primerno metodo?])[
V tej vaji smo spoznali 3 različne metode: Eulerjevo, Runge-Kutta reda 2 in reda 4. Poleg omenjenih
metod, obstaja še cel živalski vrt različnih metod za reševanje začetnega problema. Tule je
na primer #link("https://docs.sciml.ai/DiffEqDocs/stable/solvers/ode_solve/")[seznam metod]
implementiranih v paketu #jl("DifferentialEquations"), podrobneje pa so opisane v
@hairer_solving_1993. Kako se odločimo, katero metodo izbrati?

Izberemo metodo, ki ima red vsaj 4, sicer je treba korak zelo zmanjšati, da dobimo
dovolj dobro natančnost. Za splošno rabo so najprimernejše metode s kontrolo koraka. Zelo popularna
je metoda #link("https://en.wikipedia.org/wiki/Dormand%E2%80%93Prince_method")[Dormand - Prince reda 5, DOPRI5],
ki jo privzeto uporabljajo Matlab, Octave in paket #jl("DifferentialEquations") za Julijo.

Pri nekaterih NDE postanejo običajne metode kot so Runge - Kutta in DOPRI5 numerično nestabilne.
Take enačbe imenujemo
#link("https://en.wikipedia.org/wiki/Stiff_equation")[toge diferencialne enačbe]. Za toge
diferencialne enačbe so razvili veliko specialnih metod (glej @hairer_solving_1996).

Prav tako obstajajo metode, ki so prilagojene posebnim razredom diferencialnih enačb na primer
enačbe na Liejevih grupah in homogenih prostorih, Hamiltonske enačbe in še mnogo drugih.
]

== Čas in dolžina meta
Za različne začetne pogoje in parametre želimo poiskati, kako daleč leti telo, preden pade na
tla. Predpostavimo, da so tla na višini $0$. Najprej poiščemo, kdaj telo zadene tla. To se
zgodi takrat, ko je višina enaka $0$. Iskani čas je torej rešitev enačbe
$
z(t) = x_3(t) = 0.
$<eq:16-tla>
Vrednost $z(t)$ je ena komponenta rešitve začetnega problema. Enačba @eq:16-tla je nelinearna
enačba, za katero ne poznamo eksplicitne formule. Kljub temu lahko za iskanje rešitev uporabimo
metode za reševanje nelinearnih enačb. Problema se lotimo splošnejše. Enačbo @eq:16-tla zapišemo kot:

$
h(t) = F(bold(u)(t)) = 0,
$<eq:16-pogoj>

kjer je $u(t)$ rešitev začetnega problema @eq:16-sistem-1-reda, funkcija $F(bold(u))$ pa vrne tretjo
komponento vektorja $bold(u)$:

$
F([x, y, z, v_x, v_y, v_z]) = z.
$

Za reševanje enačbe $h(t)=0$ lahko uporabimo metode za reševanje nelinearnih enačb, na primer
bisekcijo ali Newtonovo metodo. Uporabili bomo Newtonovo metodo, saj
lahko vrednost odvoda $dot(bold(u))(t)$ in s tem tudi $h'(t)=d/(d t) F(bold(u)(t))$ izračunamo iz desnih
strani diferencialne enačbe:

$
h'(t) = d/(d t) F(bold(u)(t)) = nabla F(bold(u)(t)) dot.c dot(bold(u))(t) =
  nabla F dot.c f(t, bold(u)(t), p).
$

Z numeričnimi metodami dobimo približek za začetni problem v obliki zaporedja približkov
$
bold(u)_0, bold(u)_1 med dots med bold(u)_n
$
za vrednosti ob časih $t_0, t_1 med dots med t_n$. Za vsak izračun $h(t)$
bi morali vsakič znova izračunati začetni del zaporedja $bold(u)_i$. Da se
temu izognemo, najprej poiščimo interval $[t_(i), t_(i+1)]$, na katerem leži ničla. V tabeli
poiščemo $i$, za katerega je:
$
F(bold(u)_(i)) F(bold(u)_(i+1)) < 0.
$

Ko smo poiskali interval $[t_(i), t_(i+1)]$, na katerem je ničla, smo ničlo že poiskali z
natančnostjo  $delta = |t_(i+1) - t_(i)|$. Zmanjšanje koraka osnovne metode bi sicer dalo boljši
približek, vendar se tudi časovna zahtevnost poveča za enak faktor, kot se zmanjša natančnost.
Bistveno bolje je uporabiti eno od metod za reševanje nelinearnih enačb.

Vrednosti $t_i$ in $bold(u)_i$
uporabimo kot nov začetni približek za začetni problem. Tako lahko zgolj z enim korakom izbrane
metode izračunamo $h(t)=F(bold(u)(t))$ za poljuben $t in [t_(i), t_(i+1)]$.

#opomba(naslov: [Iskanje ničle v tabeli])[
Imamo tabelo vrednosti funkcije $[f_1, f_2 med dots med f_n]$ in želimo poiskati ničlo. Pogoj $f_i = 0$ ni najboljši, saj zaradi zaokrožitvenih napak skoraj zagotovo ni nikoli izpolnjen. Tudi pogoj $|f_i| < epsilon$ ni dosti boljši, ker je ničla lahko med dvema
vrednostima $f_i$ in $f_(i+1)$, čeprav sta vrednosti daleč stran od ničle. Ničla pa je zagotovo tam,
kjer funkcija spremeni predznak. Pravi pogoj je zato:
$
f_i dot.c f_(i+1) < 0.
$
]

Napišimo naslednje funkcije:
- #jl("niclaint(res::ResitevNDE, F)"), ki poišče interval, na katerem je dana funkcija
  #jl("F(t, u, du)") enaka $0$ (@pr:16-niclaint).
- #jl("nicla(res::ResitevNDE, F, DF)"), ki poišče ničlo funkcije #jl("F(t, u, du)")
  za dano rešitev začetnega problema. Za računanje novih vrednosti naj uporabi metodo #jl("RK4")
  (@pr:16-nicla).

#let demo16str(koda) = blk("scripts/16_nde.jl", koda)
#let meter = $upright(m)$
#let sekunda = $upright(s)$
Funkcijo #jl("nicla") uporabimo za poševni met. Uporabili bomo relativno velik
korak, da bo postopek iskanja ničle bolj nazoren. Rešimo začetni problem za poševni
met @eq:16-sistem-1-reda s parametri $g=9.8 meter slash sekunda^2$, $c=0.1$, z začetnim
položajem $x = 0meter, y = 1meter$ in začetno hitrostjo
$v_(x) = 10 meter slash sekunda, v_(y) = 20 meter slash sekunda$. Enote so v
 v numeričnem izračunu izpuščene.

#demo16("# nicla 1")

Približki za rešitev so precej narazen, saj smo za izračun uporabili
relativno velik korak $h=0.3$. Kljub temu je zaradi visokega reda metode Runge-Kutta
izračun dokaj natančen. V naslednjem koraku v tabeli približko, ki smo jo dobili
z metodo Runge-Kutta, poiščemo interval, na katerem druga komponenta $u_2$
spremeni predznak. Nato z Newtonovo metodo rešimo nelinearno enačbo $u_2(t) = 0$.

#demo16("# nicla 2")
#figure(image("img/16-nicla-2.svg", width: 60%),
caption: [Slika ilustrira postopek, s katerim poiščemo, koliko časa
izstrelek leti, preden pade na tla. Najprej poiščemo približke za rešitev z metodo Runge-Kutta reda 4.
Nato poiščemo interval med približki, na katerem višina $y = u_2$ spremeni predznak. Z Newtonovo
metodo rešimo enačbo $u_2(t)=0$.])

#pagebreak()
Vrednost #jl("t0") predstavlja čas leta, medtem ko dolžino leta zaberemo iz
prve komponente rešitve.

#code_box(
repl(demo16str("# nicla 4"), read("out/16-nicla-vrednost.out"))
)

Iz rezultata razberemo, da je čas leta približno $2.57 sekunda$, medtem ko je
dolžina, ki jo izstrelek doseže enaka $9.67 meter$. Narišimo še
trajektorijo sistema, ki je podana s parametrično krivuljo $(x(t), y(t)) = (u_1(t), u_2(t))$.

#demo16("# nicla 3")
#figure(image("img/16-nicla-3.svg", width: 60%),
caption: [Trajektorija poševnega meta od začetka do trenutka, ko le ta doseže tla])

#pagebreak()
== Rešitve
#figure(
  demo16("# polje smeri"),
  caption:[Funkcija izračuna polje smeri za NDE prvega reda v vozliščih
  pravokotni mreže na danem pravokotniku.]
)<pr:16-polje-smeri>

#figure(
  demo16("# risipolje"), caption:[Funkcija nariše polje smeri za NDE prvega reda
  v ravnini $t, u$.]
)<pr:16-risi-polje>

#figure(
  vaja16("# euler plain"),
  caption: [Eulerjeva metoda za reševanje začetnega problema NDE]
)<pr:16-euler>

#figure(
  vaja16("# resi"),
  caption: [Funkcija #jl("resi"), ki poišče rešitev začetnega problema z različnimi metodami.
  Posamezne metode implementiramo tako, da definiramo metode za funkcijo #jl("korak").]
)<pr:16-resi>

#figure(
  vaja16("# Euler"),
  caption: [Metoda za funkcijo #jl("korak"), ki poišče rešitev začetnega problema
  z enim korakom Eulerjeve metode]
)<pr:16-euler-resi>

#figure(
  vaja16("# interpolacija"),
  caption: [Vmesne vrednosti rešitve NDE izračunamo s Hermitovim kubičnim
  zlepkom.]
)<pr:16-vrednost>

#figure(
  vaja16("# RK2"),
  caption: [Metoda za funkcijo #jl("korak"), ki poišče rešitev začetnega problema
  z enim korakom metode Runge-Kutta reda 2]
)<pr:16-rk2>


#figure(
  vaja16("# RK4"),
  caption: [Metoda za funkcijo #jl("korak"), ki poišče rešitev začetnega problema
  z enim korakom metode Runge-Kutta reda 4]
)<pr:16-rk4>

#figure(
  vaja16("# niclaint"),
  caption: [Funkcija, ki poišče interval $[t_(i), t_(i+1)]$, na katerem ima funkcija
  $F(bold(u)(t))$ ničlo
  ]
)<pr:16-niclaint>


#figure(
  vaja16("# nicla"),
  caption: [Funkcija, ki poišče vrednost $t$, pri kateri je $F(bold(u)(t)) = 0$]
)<pr:16-nicla>
