#import "julia.typ": code_box, jl, jlfb
#import "admonitions.typ": opomba

= Reševanje začetnega problema za NDE

Navadna diferencialna enačba

$
u'(t) = f(t, u, p)
$

ima enolično rešitev za vsak začetni pogoj $u(t_0) = u_0$. Iskanje rešitve NDE z danim začetnim pogojem imenujemo #link("https://en.wikipedia.org/wiki/Initial_value_problem")[začetni problem].

V naslednji vaji bomo napisali knjižnico za reševanje začetnega problema za NDE. Napisali  bomo naslednje:

1. Podatkovno strukturo, ki hrani podatke o začetnemu problemu.
2. Podatkovno strukturo, ki hrani podatke o rešitvi začetnega problema.
3. Različne metode za funkcijo `resi`, ki poiščejo približek za rešitev začetnega problema z različnimi metodami:
  - Eulerjevo metodo,
  - Runge-Kutta reda 2,
  - prediktor korektor z Eulerjevo in implicitno trapezno metodo in kontrolo koraka.
4. Funkcijo `vrednost`, ki za dano rešitev začetnega problema izračuna vrednost rešitve v vmesnih
  točkah s Hermitovim kubičnim zlepkom (@sec:12-zlepki).
5. Napisane funkcije uporabite, da poiščete rešitev začetnega problema za poševni met z zračnim uporom.
  Kako daleč leti telo preden pade na tla? Koliko časa leti?
6. Ocenite napako, tako da rezultat izračunajte z dvakrat manjšim korakom.


== Reševanje enačbe z eno spremenljivko

Poglejmo, si najprej, kako numerično poiščemo rešitev diferencialne enačbe z
eno spremenljivko. Reševali bomo le enačbe, pri katerih lahko odvod eksplicitno izrazimo. Take
enačbe lahko zapišemo v obliki

$
u'(t) = f(t, u(t)),
$

za neko funkcijo dveh spremenljivk $f(t, u)$. Funkcija $f(t, u)$ določa odvod $u'(t)$ in s tem
tangento na rešitev $u(t)$ v točki $(t, u(t))$. Za vsako točko $(t, u)$ dobimo tangento oziroma
smer v kateri se rešitev premakne. Funkcija $f(t, u)$ tako določa polje smeri v ravnini $(t, u)$.

Za primer vzemimo enačbo

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

Poglejmo si, kako je videti polje smeri za enačbo @eq:16-nde1. Tangente vzorčimo na pravokotni
mreži na pravokotniku $(t, u) in [-2, 2] times [0, 4]$. Za eksplicitno podano krivuljo $u = u(t)$ je
vektor v smeri tangente podan s koordinatami $[1, u'(t)]$. Da dobimo lepšo sliko, vektor v smeri
tangente normaliziramo in pomnožimo s primernim faktorjem, da se tangente na sliki ne prekrivajo.

#demo16("# polje smeri")

Polje smeri nato narišemo s funkcijo #jl("quiver") iz paketa `Plots`:

#demo16("# polje slika")

Narišimo še nekaj začetnih pogojev in rešitev, ki gredo skoznje.

#demo16("# zacetni pogoj")

#figure(
  kind: image,
  table(columns: 2, stroke: none,
  image("img/16-polje.svg"),
  image("img/16-resitve.svg")
  ),
  caption: [Levo: Polje smeri za enačbo $u'(t) = -2t u(t)$. V vsaki točki ravnine $t, u$ enačba
  definira odvod $u'(t) = f(t, u)$ in s tem tudi tangento na rešitev enačbe $u(t)$.
  Desno: Vsaka točka $(t_0, u_0)$ v ravnini $t, u$ določa začetni pogoj. Za različne začetne pogoje
 dobimo različne rešitve. Rešitev NDE se v vsaki točki dotika tangente določene z
 $u'(t) = f(t, u)$.]
)

Diferencialne enačba @eq:16-nde1 ima neskončno rešitev. Če pa določimo vrednost v neki
točki $u(t_0)=u_0$, ima enačba @eq:16-nde1 enolično rešitev $u(t)$. Pogoj $u(t_0)=u_0$ imenujemo
#emph[začetni pogoj], diferencialno enačbo skupaj z začetnim pogojem

$
  u'(t) &= f(t, u)\
  u(t_0) &= u_0
$<eq:16-zacetni-problem>

pa #emph[začetni problem].

Rešitev začetnega problema @eq:16-nde1 je funkcija $u(x)$. Funkcijo lahko
numerično opišemo na mnogo različnih načinov. Dva načina, ki se pogosto uporabljata, sta
- z vektorjem vrednosti $[u_0, u_1, med dots med u_n]$ v danih točkah $t_0, t_1, med dots t_n$ ali
- z vektorjem koeficientov $[a_0, a_1 med dots med a_n]$ v razvoju $u(t) = sum a_k phi_k(t)$
  po dani bazi $phi_k(t)$.

Metode, ki poiščejo približek za vektor vrednosti imenujemo #link("https://en.wikipedia.org/wiki/Collocation_method")[kolokacijske metode], metode, ki poiščejo približek za koeficiente v razvoju
po bazi pa #link("https://en.wikipedia.org/wiki/Spectral_method")[spektralne metode].
Metode, ki jih bomo spoznali v nadaljevanju, sodijo med kolokacijske metode.

=== Eulerjeva metoda

Najpreprostejša metoda za reševanje začetnega problema je
#link("https://en.wikipedia.org/wiki/Euler_method")[Eulerjeva metoda].
Za dani začetni problem @eq:16-zacetni-problem bomo poiskali vrednosti $u_i = u(t_i)$ v
točkah $t_0 < t_1 < med dots med t_n=t_k$ na intervalu $[t_0, t_k]$. Vrednosti $u_i$ poiščemo tako,
da najprej izračunamo približek $u_1$ za $t_1$ in nato uporabimo isto metodo, da rešimo začetni
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

V nadaljevanju bomo definirali tipe in funkcije, ki bodo omogočali enotno obravnava
reševanja začetnega problema in enostavno dodajanje različnih metod za reševanje NDE. Pri tem
se bomo zgledovali po paketu
#link("https://docs.sciml.ai/DiffEqDocs/stable/")[DifferentialEquations.jl] (glej @rackauckas2017
za podrobnejšo razlago).

#let vaja16(koda) = code_box(jlfb("Vaja16/src/Vaja16.jl", koda))

Definirajmo podatkovni tip #jl("ZacetniProblem"), ki vsebuje vse podatke o začetnem problemu
@eq:16-zacetni-problem in ga bomo uporabili kot vhodni podatek za funkcije, ki bodo poiskale
numerično rešitev.

#figure(
  vaja16("# ZacetniProblem"),
  caption: [Podatkovni tip, ki vsebuje vse podatke o začetnem problemu]
)

Približke, ki jih bomo izračunali z različnimi metodami bomo tudi shranili v poseben podatkovni tip
#jl("ResitevNDE").

#figure(
  vaja16("# ResitevNDE"),
  caption: [Podatkovni tip, ki vsebuje vse numerično rešitev začetnega problema]
)

Definirajmo podatkovni tip #jl("Euler"), ki vsebuje parametre za Eulerjevo metodo.
Nato napišimo funkcijo #jl("resi(p::ZacetniProblem, metoda::Euler)"), ki poišče rešitev začetnega
problema z Eulerjevo metodo (za rešitev glej @pr:16-euler-resi).

Ponovno rešimo začetni problem
$
  u'(t) &= -2 t u\
  u(-0.5)& = 1.
$

Faktor $2$ v enačbi $u'(t) = - 2 t u$ lahko obravnavamo kot parameter enačbe.

#demo16("# euler 2")

#figure(
  image("img/16-euler-napaka.svg", width: 60%), caption: [Napaka Eulerjeve metode za $100$ in
  $200$ korakov]
)

#opomba(naslov: [Večlična razdelitev in posebni podatkovni tipi omogočajo abstraktno obravnavo])[
Uporaba specifičnih tipov omogoča definicijo specifičnih metod, ki so posebej napisane za posamezen
primer. Taka organizacija kode omogoča večjo abstrakcijo in definicijo
#link("https://en.wikipedia.org/wiki/Domain-specific_language")[domenskega jezika], ki je
prilagojen posameznemu področju. Tako lahko govorimo o #jl("ZacetnemuProblemuNDE") namesto
o funkcijah in vektorjih, ki vsebujejo dejanske podatke. Vrednost tipa #jl("ResitevNDE") se
razlikuje od vektorjev in matrik, ki jih vsebuje, predvsem v tem, da Julia ve, da gre za podatke,
ki so numerični približek za rešitev začetnega problema. To prevajalniku omogoča, da za dane podatke
avtomatično uporabi metode glede na vlogo, ki jo imajo v danem kontekstu. Takšna organizacija je zelo
prilagodljiva in omogoča enostavno dodajanje na primer novih numeričnih metod, kot tudi novih
formulacij samega problema.
]


== Hermitova interpolacija

Približne metode za začetni problem NDE izračunajo približke za rešitev zgolj v nekaterih vrednostih
spremenljivke $t$. Vrednosti rešitve diferencialne enačbe lahko interpoliramo s
#link("https://en.wikipedia.org/wiki/Cubic_Hermite_spline")[kubičnim Hermitovim zlepkom], ki smo ga
že spoznali v poglavju o zlepkih (@sec:12-zlepki). Hermitov
zlepek je na intervalu $(x_i, x_(i+1))$ enak kubičnemu polinomu, ki se z rešitvijo ujema v
vrednostih in odvodih v krajiščih intervala $x_i$ in $x_(i+1)$.

== Poševni met z zračnim uporom

$
x(t) =
$

== Rešitve

#figure(
  vaja16("# euler plain"),
  caption: [Eulerjeva metoda za reševanje začetnega problema NDE]
)<pr:16-euler>

#figure(
  vaja16("# Euler"),
  caption: [Metoda za funkcijo #jl("resi"), ki poišče rešitev začetnega problema
  z Eulerjevo metodo z enakimi koraki]
)<pr:16-euler-resi>

#figure(
  vaja16("# RK2"),
  caption: [Metoda za funkcijo #jl("resi"), ki poišče rešitev začetnega problema
  z metodo Runge Kutta reda 2]
)<pr:16-rk2>

#figure(
  vaja16("# RK2Kontrola"),
  caption: [Metoda za funkcijo #jl("resi"), ki poišče rešitev začetnega problema
  z metodo Runge Kutta reda 2 s kontrolo koraka]
)<pr:16-rk2kontrola>

#figure(
  vaja16("# hermite"),
  caption: [Izračun vrednosti Hermitovega kubičnega polinoma]
)<pr:16-hermite>

#figure(
  vaja16("# interpolacija"),
  caption: [Vmesne vrednosti rešitve NDE, izračunamo s Hermitovim kubičnim
  zlepkom]
)<pr:16-vrednost>
