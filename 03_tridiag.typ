#import "admonitions.typ": opomba, naloga
#import "Julia.typ": jlfb, jl, pkg, code_box, repl, out
#import "simboli.typ": Pm

= Tridiagonalni sistemi
<tridiagonalni-sistemi>

== Naloga
<naloga>

- Ustvari podatkovni tip za tridiagonalno matriko in implementiraj operacije množenja `*` z
  vektorjem ter reševanja sistema  $A bold(x)=bold(b)$ z operatorjem `\`.
- Za slučajni sprehod v eni dimenziji izračunaj povprečno število korakov, ki jih potrebujemo, da
  se od izhodišča oddaljimo za $k$ korakov.
  - Zapiši fundamentalno matriko za #link("https://en.wikipedia.org/wiki/Markov_chain")[Markovsko verigo], ki modelira slučajni sprehod, ki se lahko od izhodišča oddalji le za $k$ korakov.
  - Reši sistem s fundamentalno matriko in vektorjem enic.
  - Povprečno število korakov oceni še z vzorčenjem velikega števila simulacij slučajnega sprehoda.
  - Primerjaj oceno z rešitvijo sistema.

== Tridiagonalne matrike

Matrika je #emph[tridiagonalna], če ima neničelne elemente le na glavni diagonali in na dveh
najbližjih diagonalah. Primer $5 times 5$ tridiagonalne matrike:

$
  mat(
    1, 2, 0, 0, 0;
    3, 4, 5, 0, 0;
    0, 6, 7, 6, 0;
    0, 0, 5, 4, 3;
    0, 0, 0, 2, 1
  ).
$

Elementi tridiagonalne matrike, za katere se indeksa razlikujeta za več kot 1, so vsi
enaki 0:
$ |i-j| > 1 => a_(i j) = 0. $

Z implementacijo posebnega podatkovnega tipa za tridiagonalno matriko prihranimo tako na
prostoru kot tudi pri časovni zahtevnosti algoritmov, saj jih lahko prilagodimo posebnim lastnostim
tridiagonalnih matrik.

Preden se lotimo naloge, ustvarimo nov paket `Vaja03`, kamor bomo postavili kodo:

#code_box[
  #pkg("generate Vaja03", none, env: "num_mat")
  #pkg("develop Vaja03/", none, env: "num_mat")
]

Podatkovni tip za tridiagonalne matrike imenujemo `Tridiag` in vsebuje tri polja z elementi na posameznih diagonalah. Definicijo postavimo v `Vaja03/src/Vaja03.jl`:

#code_box[
  #jlfb("Vaja03/src/Vaja03.jl", "# Tridiagonalna")
]

Zgornja definicija omogoča, da ustvarimo nove objekte tipa `Tridiag`:

#code_box[
  #repl("using Vaja03", none)
  #repl("Tridiag([3, 6, 5, 2], [1, 4, 7, 4, 1], [2, 5, 6, 3])", none)
]

#opomba(naslov: [Preverjanje skladnosti polj v objektu])[
V zgornji definiciji `Tridiag` smo poleg deklaracije polj dodali tudi
#link("https://docs.julialang.org/en/v1/manual/constructors/#man-inner-constructor-methods")[notranji konstruktor]
v obliki funkcije `Tridiag`. Vemo, da mora biti dolžina vektorjev `sd` in `zd` za ena
manjša od dolžine vektorja `d`. Zato je pogoj najbolje preveriti, ko ustvarimo objekt, in
se nam s tem v nadaljevanju ni več treba ukvarjati. Z notranjim konstruktorjem te
pogoje uveljavimo ob nastanku objekta in preprečimo ustvarjanje objektov z nekonsistentnimi podatki.
]

Želimo, da se matrike tipa `Tridiag` obnašajo podobno kot generične matrike vgrajenega tipa `Matrix`. Zato funkcijam, ki delajo z matrikami, dodamo specifične metode za podatkovni tip `Tridiag`.
Argumentu funkcije lahko dodamo informacijo o tipu, tako da dodamo `::Tip`
in na ta način definiramo specifično metodo, ki deluje le za dan podatkovni tip. Če želimo, da
metoda deluje za argumente tipa `Tridiag`, argumentu dodamo `::Tridiag`. Več informacij o
#link("https://docs.julialang.org/en/v1/manual/types/")[tipih] in
#link("https://docs.julialang.org/en/v1/manual/interfaces/")[vmesnikih].

#naloga[
Implementiraj naslednje metode, specifične za tip `Tridiag` (rešitve so na koncu poglavja):

- #jl("size(T::Tridiag)") vrne dimenzije matrike (@pr:03-size),
- #jl("getindex(T::Tridiag, i, j)") vrne element `T[i,j]` (@pr:03-getindex),
- #jl("setindex!(T::Tridiag, x, i, j)") nastavi element `T[i,j]` (@pr:03-setindex) in
- #jl("*(T::Tridiag, x::Vector)") izračuna produkt matrike `T` z vektorjem `x` (@pr:03-produkt).

Za tridiagonalne matrike je časovna zahtevnost množenja matrike z vektorjem bistveno manjša kot v splošnem ($cal(O)(n)$ namesto $cal(O)(n^2)$).
]

Preden nadaljujemo, preverimo, ali so funkcije pravilno implementirane. Napišemo avtomatske teste, ki jih lahko kadarkoli poženemo. V projektu `Vaja03` ustvarimo datoteko `Vaja03/test/runtests.jl` in vanjo zapišemo kodo, ki preveri pravilnost zgoraj definiranih funkcij.

#code_box[
  #jlfb("Vaja03/test/runtests.jl", "# glava")
]

V paket `Vaja03` moramo dodati še paket `Test`:

#code_box[
  #pkg("activate Vaja03", none, env: "num_mat")
  #pkg("add Test", none, env: "Vaja03")
]

Teste poženemo v paketnem načinu z ukazom `test Vaja03`:

#code_box[
  #pkg("activate .", none, env: "Vaja03")
  #pkg("test Vaja03",
  "...
     Testing Running tests...
Test Summary: | Pass  Total  Time
Velikost      |    1      1  0.0s"
  , env: "num_mat")
]

#naloga[
  Napiši teste za ostale funkcije (rešitve so v @sec:03-testi[podpoglavju]).
]

== Reševanje tridiagonalnega sistema

Poiskali bomo rešitev sistema linearnih enačb $T bold(x) = bold(b)$, kjer je matrika sistema $T$
tridiagonalna. Sistem lahko rešimo z Gaussovo eliminacijo in obratnim vstavljanjem @Orel_2004. Ker je v tridiagonalni matriki bistveno manj elementov, se število potrebnih
operacij tako za Gaussovo eliminacijo kot za obratno vstavljanje bistveno zmanjša. Dodatno
predpostavimo, da je matrika $T$ takšna, da med eliminacijo ni treba delati delnega pivotiranja
(glej poglavje 2.5 v @Orel_2004).
V nasprotnem primeru se tridiagonalna oblika matrike med Gaussovo eliminacijo podre in se algoritem
nekoliko zakomplicira. Časovna zahtevnost Gaussove eliminacije brez pivotiranja je za
tridiagonalni sistem $T bold(x) = bold(b)$ linearna $cal(O)(n)$ namesto kubična $cal(O)(n^3)$. Za
obratno vstavljanje pa se časovna zahtevnost s kvadratne $cal(O)(n^2)$ zmanjša na linearno
$cal(O)(n)$.

#naloga[
Priredi splošna algoritma Gaussove eliminacije in obratnega vstavljanja, da bosta upoštevala
lastnosti tridiagonalnih matrik. Napiši funkcijo `\`:

#code_box[ #jl("function \(T::Tridiag, b::Vector),")]

ki poišče rešitev sistema $T bold(x) = bold(b)$ (rešitev je @pr:03-backslash).

V datoteko
`Vaja03/test/runtests.jl` dodaj test, ki na primeru preveri pravilnost funkcije `\`.
]
== Slučajni sprehod
<slučajni-sprehod>
Metodo za reševanje tridiagonalnega sistema bomo uporabili na primeru
#link("https://en.wikipedia.org/wiki/Random_walk")[slučajnega sprehoda]
v eni dimenziji. Slučajni sprehod je vrsta
#link("https://en.wikipedia.org/wiki/Stochastic_process")[stohastičnega procesa],
ki ga lahko opišemo z
#link("https://en.wikipedia.org/wiki/Markov_chain")[Markovsko verigo] z
množico stanj, ki je enaka množici celih števil $ZZ$. Če se na nekem koraku slučajni sprehod nahaja
v stanju $n$, se lahko v naslednjem koraku z verjetnostjo $p in [0, 1]$ premakne v stanje $n - 1$
ali z verjetnostjo $q = 1 - p$ v stanje $n + 1$. Prehodni verjetnosti slučajnega sprehoda sta enaki:

$
  P(X_(i+1) = n - 1 | X_i = n) &= p\
  P(X_(i+1) = n + 1 | X_i = n) &= q.
$

#opomba(naslov: [Definicija Markovske verige])[
Markovska veriga je zaporedje slučajnih spremenljivk
$ X_1, X_2, X_3, med dots $
z vrednostmi v množici stanj ($ZZ$ za slučajni sprehod), za katere velja Markovska lastnost:

$
 P(X_(i+1) = x | X_1 = x_1, X_2 = x_2, med dots, med X_i = x_i) = P(X_(i+1) = x | X_i = x_i).
$

Ta pove, da je verjetnost za prehod v naslednje stanje odvisna le od prejšnjega stanja
in ne od starejše zgodovine stanj. V Markovski verigi tako zgodovina, kako je proces prišel v neko stanje, ne odloča o naslednjem stanju, odloča le stanje, v katerem se proces trenutno nahaja.

Verjetnosti $P(X_(i+1) = x | X_i = x_i)$ imenujemo #emph[prehodne verjetnosti] Markovske verige. V nadaljevanju bomo privzeli, da so prehodne verjetnosti enake za vse korake $k$:
$
 P(X_(k+1) = x | X_k = y) = P(X_2 = x | X_1 = y).
$
]

Simulirajmo prvih 100 korakov slučajnega sprehoda:

#jlfb(
  "scripts/03_Tridiag.jl",
  "# sprehod"
  )

#figure(
  image("img/03a_sprehod.svg", width: 80%),
  caption: [Simulacija slučajnega sprehoda]
)

#opomba(naslov: [Prehodna matrika Markovske verige])[
Za Markovsko verigo s končno množico stanj ${x_1, x_2, dots, x_n}$, lahko prehodne verjetnosti
zložimo v matriko. Brez škode lahko stanja ${x_1, x_2, dots, x_n}$ nadomestimo z naravnimi
števili ${1, 2, dots, n}$. Matriko $Pm=[p_(i j)]$, katere elementi so prehodne verjetnosti prehodov med
stanji Markovske verige

$
p_(i j) = P(X_n = j| X_(n-1) = i),
$

imenujemo #link("https://sl.wikipedia.org/wiki/Stohasti%C4%8Dna_matrika")[prehodna matrika]
Markovske verige. Za prehodno matriko velja, da vsi elementi ležijo na $[0,1]$
in da je vsota elementov po vrsticah enaka $1$:

$
sum_(j=1)^n p_(i j) = 1.
$

Posledično je vektor samih enic $bold(1)=[1, 1, dots, 1]^T$ lastni vektor matrike $Pm$ za lastno
vrednost $1$:

$
Pm bold(1) = bold(1).
$

Prehodna matrika povsem opiše porazdelitev Markovske verige. Potence prehodne matrike $Pm^m$
na primer določajo prehodne verjetnosti po $m$ korakih:
$
[Pm^m]_(i j) = P(X_m=j|X_1=i).
$
]

== Pričakovano število korakov
Poiskati želimo pričakovano število korakov, po katerem se slučajni sprehod prvič pojavi v stanju $k$ ali
$-k$. Zato bomo privzeli, da se sprehod v stanjih $-k$ in $k$ ustavi in se ne premakne več.

Stanje, iz katerega se veriga ne premakne več, imenujemo #emph[absorbirajoče stanje]. Za
absorbirajoče stanje $k$ je diagonalni element prehodne matrike enak $1$, vsi ostali elementi v
vrstici pa $0$:

$
p_(k k) & = P(X_(i+1)=k | X_i = k) = 1\
p_(k l) & = P(X_(i+1)=l | X_i = k) = 0.
$

Stanje, ki ni absorbirajoče, imenujemo #emph[prehodno stanje]. Markovsko verigo, ki vsebujejo vsaj
eno absorbirajoče stanje, imenujemo
#link("https://en.wikipedia.org/wiki/Absorbing_Markov_chain")[absorbirajoča Markovska veriga].

Privzamemo, da je začetno stanje enako $0$. Iščemo pričakovano število korakov, po katerem se
slučajni sprehod prvič pojavi v stanju $k$ ali $-k$. Stanji $k$ in $-k$ spremenimo v absorbirajoči stanji, saj stanj, ki so več kot $k$ oddaljena
od izhodišča, ni treba upoštevati. Obravnavamo torej
absorbirajočo verigo z #linebreak(justify: true) $2k+1$ stanji, pri kateri sta stanji $-k$ in $k$ absorbirajoči, ostala
stanja pa ne. Iščemo pričakovano število korakov, da iz začetnega stanja pridemo v eno od
absorbirajočih stanj.

Za izračun iskane pričakovane vrednosti uporabimo #link("https://en.wikipedia.org/wiki/Absorbing_Markov_chain#Canonical_form")[kanonično obliko prehodne matrike].

#opomba(naslov: [Kanonična oblika prehodne matrike])[

Če ima Markovska veriga absorbirajoča stanja, lahko prehodno matriko
zapišemo v bločni obliki:
$
Pm  = mat(
  Q, T;
  0, I),
$
kjer vrstice $[Q, T]$ ustrezajo prehodnim, vrstice $[0, I]$ pa absorbirajočim stanjem. Matrika $Q$
opiše prehodne verjetnosti za sprehod med prehodnimi stanji, matrika $Q^m$ pa prehodne
verjetnosti po $m$ korakih, če se sprehajamo le po prehodnih stanjih.

Vsoto vseh potenc matrike $Q$:
$
N = sum_(m=0)^infinity Q^m = (I-Q)^(-1)
$

imenujemo #emph[fundamentalna matrika] absorbirajoče Markovske verige. Element
$n_(i j)$ predstavlja pričakovano število obiskov stanja $j$, če začnemo
v stanju $i$.
]

Pričakovano število korakov, da dosežemo absorbirajoče stanje iz
začetnega stanja $i$, je $i$-ta komponenta produkta matrike
$N$ z vektorjem samih enic:

$ bold(m) = N bold(1) = (I - Q)^(- 1) bold(1). $

Če želimo poiskati pričakovano število korakov $bold(m)$, moramo rešiti sistem
linearnih enačb:

$ (I - Q) bold(m) = bold(1). $


Če nas zanima, kdaj bo sprehod prvič za $k$ oddaljen od izhodišča, lahko
začnemo v $0$ in stanji $k$ in $-k$ proglasimo za absorbirajoča
stanja. Prehodna matrika, ki jo dobimo, je tridiagonalna z $0$ na
diagonali. Matrika $I - Q$ je prav tako tridiagonalna z $1$ na
diagonali in z negativnimi verjetnostmi $-p$ na prvi poddiagonali
in $-q = p - 1$ na prvi naddiagonali:

$ I - Q = mat(delim: "(", 1, - q, 0, dots.h, 0; - p, 1, - q, dots.h, 0; dots.v, dots.down, dots.down, dots.down, dots.v; 0, dots.h, - p, 1, - q; 0, dots.h, 0, - p, 1). $

Matrika $I - Q$ je tridiagonalna. Poleg tega je po stolpcih diagonalno dominantna in v prvem in
zadnjem stolpcu strogo diagonalno dominantna#footnote[
Matrika je po stolpcih _diagonalno dominantna_, če za vsak stolpec velja, da je
absolutna vrednost diagonalnega elementa večja ali enaka vsoti absolutnih vrednosti vseh ostalih
elementov v stolpcu: $|a_(i i)|>=sum_(i eq.not j) |a_(j i)|$. Če je matrika strogo diagonalno
dominantna vsaj v enem stolpcu, potem je Gaussova eliminacija brez pivotiranja numerično
stabilna @Plestenjak2015.], zato lahko
uporabimo Gaussovo eliminacijo brez pivotiranja. Najprej napišemo funkcijo, ki zgradi
matriko $I - Q$:

#figure(
code_box(
  jlfb("scripts/03_Tridiag.jl", "# matrika_sprehod")
),
caption: [Funkcija, ki sestavi tridiagonalno matriko $I-Q$ za slučajni sprehod.
  Slučajni sprehod se konča, ko se prvič oddalji za $k$ korakov od izhodišča.]
)<pr:03-matrika-sprehod>

Pričakovano število korakov izračunamo kot rešitev sistema $(I-Q) bold(k) = bold(1)$.
Uporabimo operator `\` za tridiagonalno matriko:

#figure(
code_box[
  #jlfb("scripts/03_Tridiag.jl", "# koraki")
],
caption: [Funkcija, ki izračuna vektor pričakovanih števil korakov, ki jih potrebuje slučajni
sprehod, da se iz začetnega stanja med $1$ in $2k-1$ premakne v stanje $0$ ali $2k$.]
)
V matriki $Q$ so stanja označena z indeksi matrike od $1$ do $2k-1$. Zato stanja premaknemo za $-k$, dobimo stanja $-k, -k+1, med dots, med 0, med dots, k$. Komponente vektorja $bold(k)$ tako predstavljajo pričakovano število korakov, ki jih slučajni sprehod potrebuje, da prvič doseže stanji $-k$ ali $k$, če začnemo v stanju $i in {-k+1, -k+2, med dots, 0, 1, med dots, med k-1}$.

#code_box[
  #jlfb("scripts/03_Tridiag.jl", "# koraki slika")
]

#figure(
  image("img/03a_koraki.svg", width:60%),
  caption: [Pričakovano število korakov, da slučajni sprehod prvič doseže stanji $-10$ ali $10$,
    v odvisnosti od začetnega stanja $i in {-9, -8 dots, -1, 0, 1, dots, 8, 9}$.]
)

Za konec se prepričajmo še s
#link("https://sl.wikipedia.org/wiki/Metoda_Monte_Carlo")[simulacijo Monte Carlo], da so
rešitve, ki jih dobimo kot rešitev sistema, res prave. Slučajni sprehod simuliramo z generatorjem
naključnih števil in izračunamo
#link("https://en.wikipedia.org/wiki/Sample_mean_and_covariance")[vzorčno povprečje] za število
korakov $m$.

#let demo03(koda) = code_box(jlfb("scripts/03_Tridiag.jl", koda))
#figure(
demo03("# simulacija"),
caption: [Simulacija z generatorjem naključnih števil. Vzorčno povprečje da oceno za pričakovano
število korakov.]
)

#pagebreak()
Za $k = 10$ je pričakovano število korakov enako $100$. Poglejmo, kako
se izračunani rezultat ujema z vrednostjo, ki jo dobimo, če slučajni sprehod velikokrat
($n=100 thin 000$) ponovimo in izračunamo vzorčno povprečje:

#demo03("# poskus")
#code_box(
  out("out/03_Tridiag_1.out")
)

#opomba(naslov: [Kaj smo se naučili?])[
- Z upoštevanjem lastnosti sistemov linearnih enačb prihranimo veliko prostora in časa.
- Sistemi linearnih enačb se pogosto pojavijo, ko rešujemo matematične probleme, čeprav na
  prvi pogled nimajo nobene zveze z linearno algebro.
]

== Rešitve

#figure(
code_box(
  jlfb("Vaja03/src/Vaja03.jl", "# size")
),
caption: [Metoda `size` za tridiagonalno matriko, ki vrne dimenzije matrike.]
)<pr:03-size>

#figure(code_box(
  jlfb("Vaja03/src/Vaja03.jl", "# getindex")
),
caption: [Metoda `getindex` za tridiagonalno matriko, ki se pokliče, ko uporabimo izraz `T[i,j]`.]
)<pr:03-getindex>

#figure(
  code_box(jlfb("Vaja03/src/Vaja03.jl", "# setindex")),
  caption:[Metoda `setindex!` se pokliče, ko uporabimo izraz `T[i,j]=x`.]
)<pr:03-setindex>

#figure(
  code_box(jlfb("Vaja03/src/Vaja03.jl", "# množenje")),
  caption: [Metoda `*` za množenje tridiagonalne matrike z vektorjem]
)<pr:03-produkt>

#figure(
code_box(
  jlfb("Vaja03/src/Vaja03.jl", "# deljenje")
),
caption: [Metoda `\` za reševanje tridiagonalnega sistema linearnih enačb]
)<pr:03-backslash>

=== Testi<sec:03-testi>

#figure(
code_box(
  jlfb("Vaja03/test/runtests.jl", "# getindex")
),
caption: [Testi za funkcijo `getindex`]
)

#figure(
code_box(
  jlfb("Vaja03/test/runtests.jl", "# setindex")
),
caption: [Testi za funkcijo `setindex!`]
)

#figure(
code_box(
  jlfb("Vaja03/test/runtests.jl", "# množenje")
),
caption: [Testi za množenje]
)

#figure(
code_box(
  jlfb("Vaja03/test/runtests.jl", "# deljenje")
),
caption: [Testi za operator `\` (reševanje tridiagonalnega sistema)]
)
