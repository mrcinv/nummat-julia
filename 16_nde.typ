#import "julia.typ": code_box, jl, jlfb

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
4. Funkcijo `vrednost`, ki za dano rešitev začetnega problema izračuna vrednost rešitve v vmesnih točkah s #link("https://en.wikipedia.org/wiki/Cubic_Hermite_spline")[Hermitovim kubičnim zlepkom]. Uporabite Hermitovo bazo kubičnih polinomov, ki zadoščajo pogojem v tabeli
#figure(
table(
  columns: 5,
  [], [$p(0)$], [$p(1)$], [$p'(0)$], [$p'(1)$],
  [$h_(00)$], [$1$], [$0$], [$0$], [$0$],
  [$h_(01)$], [$0$], [$1$], [$0$], [$0$],
  [$h_(10)$], [$0$], [$0$], [$1$], [$0$],
  [$h_(11)$], [$0$], [$0$], [$0$], [$1$]

),
caption: [Vrednosti baznih polinomov $h_(i j)(t)$ in njihovih odvodov v točkah $t=0$ in $t=1$.]
)
5. Napisane funkcije uporabite, da poiščete rešitev začetnega problema za poševni met z zračnim uporom. Kako daleč leti telo preden pade na tla? Koliko časa leti? 
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

#figure(
  image("img/16-polje.svg", width: 60%),
  caption: [Polje smeri za enačbo $u'(t) = -2t u(t)$. V vsaki točki ravnine $t, u$ enačba definira odvod $u'(t) = f(t, u)$ in s tem tudi tangento na rešitev enačbe $u(t)$. ]
)


Narišimo še nekaj začetnih pogojev in rešitev, ki gredo skoznje. Vsak začetni pogoj je točka v $t, u$ ravnini.

#demo16("# zacetni pogoj")

#figure(
  image("img/16-resitve.svg", width: 60%),
  caption: [Vsaka točka $(t_0, u_0)$ v ravnini $t, u$ določa začetni pogoj.. Za različne začetne pogoje dobimo različne rešitve. Rešitev NDE se v vsaki točki dotika tangente določene z NDE $u'(t) = f(t, u)$.]
)

Diferencialne enačba @eq:16-nde1 ima neskončno rešitev. Če pa določimo vrednost v neki
točki $u(t_0)=u_0$, ima enačba @eq:16-nde1 enolično rešitev $u(t)$. Pogoj $u(t_0)=u_0$ imenujemo
#emph[začetni pogoj], diferencialno enačbo skupaj z začetnim pogojem 

$
  u'(t) &= f(t, u)\
  u(t_0) &= u_0
$<eq:16-zacetni-problem>

pa #emph[začetni problem]. Rešitev začetnega problema @eq:16-nde1 je funkcija $u(x)$. Funkcijo lahko 
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



== Hermitova interpolacija

Približne metode za začetni problem NDE izračunajo približke za rešitev zgolj v nekaterih vrednostih spremenljivke $t$. Vrednosti rešitve diferencialne enačbe lahko interpoliramo s #link("https://en.wikipedia.org/wiki/Cubic_Hermite_spline")[kubičnim Hermitovim zlepkom]. Hermitov zlepek je na intervalu $(x_i, x_(i+1))$ enak kubičnemu polinomu, ki se z rešitvijo ujema v vrednostih in odvodih v krajiščih intervala $x_i$ in $x_(i+1)$.

== Poševni met z zračnim uporom

$
x(t) = 
$

== Rešitve

#let vaja16(koda) = code_box(jlfb("Vaja16/src/Vaja16.jl", koda))

#figure(
  vaja16("# euler plain"),
  caption: [Eulerjeva metoda za reševanje začetnega problema NDE]
)<pr:16-euler>