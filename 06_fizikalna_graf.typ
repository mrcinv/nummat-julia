#import "julia.typ": code_box, jl, jlfb
#import "admonitions.typ": opomba
#import "@preview/cetz:0.3.1" as cetz: canvas
#import "@preview/fletcher:0.5.2" as fletcher: diagram, node, edge

= Fizikalna metoda za vložitev grafov
<sec:6-fizikalna-metoda>
#let Fvec = $bold(F)$

Naj bo $G$ neusmerjen povezan graf z množico vozlišč $V(G)$ in povezav $E(G)subset V(G) times V(G)$.
Brez škode predpostavimo, da so vozlišča grafa $G$ kar zaporedna naravna števila
$V(G) = {1, 2, dots n}$. Vložitev grafa $G$ v $RR^d$ je preslikava
$V(G) -> RR^d$, ki je podana z zaporedjem koordinat. Vložitev v $RR^3$ je podana z zaporedjem točk v
$RR^3$

$
(x_1, y_1, z_1), (x_2, y_2, z_2), dots, (x_n, y_n, z_n).
$

Za dani graf $G$ želimo poiskati vložitev v $RR^3$ (ali $RR^2$). Pri fizikalni metodi
grafu $G$ priredimo fizikalni sistem in uporabimo fizikalne zakone za določanje položajev vozlišč.
V tej vaji bomo grafu priredili sistem harmoničnih vzmeti, pri katerem na vsako vozlišče delujejo
sosednja vozlišča s silo, ki je sorazmerna razdalji med vozlišči.

#figure(
    diagram(
      node-stroke: 0.5pt,
      node-shape: "circle",
      {
        node((0, 0), $1$)
        let pts = ((-1.5, -1), (-1, 1), (2, 1), (1,-0.6))
        for (i, pt) in pts.enumerate() {
          node(pt, $#(i+2)$)
          edge((0,0), pt, decorations:"coil")
          edge(pts.at(i - 1), pt, decorations:"coil")
        }
      }
    ),
  caption: [Sistem vzmeti za dani graf]
)

== Naloga

- Izpelji sistem enačb za koordinate vozlišč grafa, tako da so vozlišča v ravnovesju.
- Pokaži, da je matrika sistema diagonalno dominantna in negativno definitna.
- Napiši funkcijo, ki za dani graf in koordinate fiksiranih vozlišč poišče koordinate vseh vozlišč tako, da reši sistem enačb z metodo konjugiranih gradientov.
- V ravnini nariši #link("https://en.wikipedia.org/wiki/Ladder_graph#Circular_ladder_graph")[graf krožno lestev], tako da polovico vozlišč razporediš enakomerno po enotski krožnici.
-  V ravnini nariši pravokotno mrežo. Fiksiraj vogale, nato točke na robu enakomerno razporedi po krožnici.

== Ravnovesje sil

Harmonična vzmet je idealna vzmet dolžine $0$, za katero sila ni sorazmerna spremembi dolžine, pač
pa dolžini vzmeti. Sila harmonične vzmeti, ki je vpeta med točki $(x_1, y_1, z_1)$ in
$(x_2, y_2, z_2)$ in deluje na prvo krajišče, je enaka

$
Fvec_(2 1) = k dot vec(x_2 - x_1, y_2 - y_1, z_2 - z_1),
$

kjer je $k$ koeficient vzmeti.

Koordinate vozlišč določimo tako, da poiščemo ravnovesje sistema. To pomeni, da so v vsakem vozlišču $j$ v ravnovesju sile, s katerimi
sosednja vozlišča delujejo nanj:

$
  sum_(i in N(j)) Fvec_(i j) = bold(0),
$<eq:06-ravnovesje>

kjer je $N(j) = {i: thick (i, j) in E(G)}$ množica sosednjih točk v grafu za točko $j$ in $Fvec_(i j)$
sila, s katero vozlišče $i$ deluje na vozlišče $j$. Iz enačbe @eq:06-ravnovesje lahko izpeljemo
sistem enačb za koordinate $x_j, y_j$ in $z_j$. Iz vektorske enačbe za vozlišče $j$:

$
  sum_(i in N(j)) Fvec_(i j) = sum_(i in N(j)) k vec(x_i - x_j, y_i - y_j, z_i - z_j) = bold(0),
$

dobimo 3 enačbe za posamezne koordinate:

#let st = math.op("st")

$
   -st(j)x_j + x_(i_1) + x_(i_2) + dots + x_(i_(st(i))) &= 0,\
   -st(j)y_j + y_(i_1) + y_(i_2) + dots + y_(i_(st(i))) &= 0,\
   -st(j)z_j + z_(i_1) + z_(i_2) + dots + z_(i_(st(i))) &= 0,
$

kjer je $st(j)=|N(j)|$ stopnja vozlišča $j$ in $i_1, i_2, med dots, med i_(st(j)) in N(j)$. Ker so koordinate $x$, $y$ in $z$ med seboj neodvisne, dobimo za vsako koordinato en sistem enačb.
Za koordinato $x$ dobimo naslednji sistem:
$
  -st(1)x_1 + sum_(i in N(1)) x_(i) &= 0,\
  -st(2)x_2 + sum_(i in N(2)) x_(i) &= 0,\
  dots.v  \
  -st(n)x_n + sum_(i in N(n)) x_(i) &= 0.
$<eq:06-trojni-sistem>


Enačbe @eq:06-trojni-sistem so homogene, kar pomeni, da ima sistem  le ničelno rešitev#footnote[Rešitev je enolična le, če je matrika sistema @eq:06-trojni-sistem polnega ranga. To velja, če graf nima izoliranih točk]. Če želimo
netrivijalno rešitev, moramo nekatera vozlišča v grafu pritrditi in jim predpisati koordinate. Brez
škode lahko predpostavimo, da so vozlišča, ki jih pritrdimo, na koncu. Označimo z
$F = {m+1, dots, n} subset V(G); quad m<n$ množico vozlišč, ki imajo določene koordinate. Koordinate za
vozlišča iz $F$ niso več spremenljivke, ampak jih moramo prestaviti na drugo stran enačbe.
Sistem enačb @eq:06-trojni-sistem postane nehomogen:

$
 -st(1) x_1 + a_(1 2) x_2 + dots + a_(1 m) x_m = - a_(1 m+1)x_(m+1) - dots - a_(1 n)x_(n),\
 a_(2 1)x_1 - st(2)x_2 + dots + a_(2 m) x_m = - a_(2 m+1)x_(m+1) - dots - a_(2 n)x_(n),\
 dots.v\
 a_(m 1)x_1 - a_(m 2)x_2 + dots  - st(m)x_m = - a_(m m+1)x_(m+1) - dots - a_(m n)x_(n),\
$<eq:06sistem-x>

kjer je vrednost $a_(i j)$ enaka $1$, če sta $i$ in $j$ soseda, in $0$ sicer:

$
  a_(i j) = cases(1","& quad (i, j) in E(G)",", 0","& quad (i, j) in.not E(G).)
$

Matrika sistema @eq:06sistem-x je
odvisna le od povezav v grafu in izbire točk, ki niso pritrjene, medtem ko
so desne stani odvisne od koordinat pritrjenih točk:

$
A = mat(
  -st(1), a_(1 2), dots, a_(1 m);
  a_(2 1), - st(2), dots, a_(2 m);
  dots.v, dots.v, dots.down, dots.v;
  a_(m 1), a_(m 2), dots, - st(m)
)#text[ in ]
bold(b) = -vec(sum_(i=m+1)^n a_(1 i)x_i, sum_(i=m+1)^n a_(2 i)x_i, dots.v,
sum_(i=m+1)^n a_(n i)x_i).
$<eq:06-matrika>
Sistema za $y$ in $z$ imata iste koeficiente kot sistem @eq:06-trojni-sistem, razlikujeta se le v
desnih straneh, ki so odvisne od koordinat pritrjenih točk.

Kakšne posebnosti ima matrika sistema @eq:06-matrika?  Matrika je simetrična in diagonalno dominantna.
Res! Velja namreč $st(i) = |N(i)|$ in zato:

$
  |a_(i i)| = |N(i)| >= |N(i) sect F^C| =  sum_(j eq.not i) |a_(i j)|.
$

Za sosede fiksnih vozlišč je neenakost stroga, zato je matrika diagonalno dominantna in vsaj za
eno vrstico je neenakost stroga. Ker so vsi elementi na diagonali negativni in je matrika diagonalno
dominantna (z vsaj eno vrstico, ki je strogo diagonalno dominantna), je
matrika $A$ negativno definitna in matrika $-A$ pozitivno definitna. Za večino grafov, za katere
uporabimo zgornji postopek, bo matrika sistema $A$ redka.
Zato lahko za reševanje sistema $-A bold(x) = -bold(b)$ uporabimo
#link("https://en.wikipedia.org/wiki/Conjugate_gradient_method")[metodo konjugiranih gradientov], ki deluje za sisteme s pozitivno definitno matriko.
Metoda konjugiranih gradientov in druge iterativne metode so zelo primerne za redke matrike.
Za razliko od eliminacijskih metod, iterativne metode ne izvedejo sprememb na matriki,
ki bi dodale neničelne elemente.

== Rešitev v Julii

Za predstavitev grafa bomo uporabili paket #link("https://juliagraphs.org/Graphs.jl")[Graphs.jl],
ki definira podatkovne tipe in vmesnike za lažje delo z grafi.

Napišimo naslednje funkcije:
- #jl("krozna_lestev(n)"), ki ustvari graf krožne lestve z $2n$ vozlišči (rešitev @pr:06-lestev).
- #jl("matrika(G::AbstractGraph, sprem)"), ki vrne matriko sistema @eq:06-matrika za
  dani graf `G` in seznam vozlišč, ki niso pritrjena `sprem` (rešitev @pr:06-matrika),
- #jl("desne_strani(G::AbstractGraph, sprem, koordinate)"), ki vrne vektor desnih strani za
  sistem @eq:06sistem-x (rešitev @pr:06-desne-strani),
- #jl("cg(A, b; atol=1e-8)"), ki poišče rešitev sistema $A bold(x) = bold(b)$ z metodo konjugiranih gradientov
  (rešitev @pr:06-cg) in
- #jl("vlozi!(G::AbstractGraph, fix, tocke)"), ki poišče vložitev grafa `G` v $RR^d$ s fizikalno
  metodo.  Argument `fix` naj bo seznam fiksnih vozlišč, argument `tocke` pa matrika s koordinatami
  točk. Metoda naj ne vrne ničesar, ampak naj vložitev zapiše kar v matriko `tocke`
  (rešitev @pr:06-vlozitev).

== Krožna lestev

Uporabimo napisano kodo za primer grafa krožna lestev. Graf je sestavljen iz dveh ciklov enake
dolžine $n$, ki sta med seboj povezana z $n$ povezavami. Za grafično predstavitev grafov bomo
uporabili paket #link("https://docs.juliaplots.org/stable/GraphRecipes/introduction/")[GraphRecipes.jl].

#let svaja06(koda) = jlfb("scripts/06_graf.jl", koda)

#code_box(
  svaja06("# lestev")
)

#figure(
  image("img/06-lestev.svg", width: 60%),
  caption: [Graf krožna lestev s 16 vozlišči]
)

Poiščimo drugačno vložitev s fizikalno metodo, tako da vozlišča enega cikla enakomerno razporedimo
po krožnici.

#code_box(
  svaja06("# lestev fiz")
)

#figure(
  image("img/06-lestev-fiz.svg", width: 60%),
  caption: [Graf krožna lestev s 16 vozlišči vložen s fizikalno metodo. Zunanja
  vozlišča so fiksna, notranja pa postavljena tako, da so sile vzmeti na povezavah v ravnovesju.]
)

== Dvodimenzionalna mreža

Preizkusimo algoritem na dvodimenzionalni mreži. Dvodimenzionalna mreža je graf, ki ga dobimo,
če v ravnini pravokotnik razdelimo v pravokotno mrežo. Najprej pritrdimo štiri točke druge stopnje,
ki ustrezajo ogliščem pravokotnika.

#code_box(
  svaja06("# mreža")
)

#figure(
  image("img/06-mreza.svg", width: 60%),
  caption: [Dvodimenzionalna mreža, vložena s fizikalno metodo. Pritrjeni so le vogali.]
)

Sedaj pritrdimo cel rob in ga enakomerno razporedimo po krožnici.

#code_box(
  svaja06("# krožna")
)

#figure(
  image("img/06-mreza-krog.svg", width: 60%),
  caption: [Dvodimenzionalna mreža, vložena s fizikalno metodo. Rob mreže je enakomerno razporejen
    po krožnici.]
)

#opomba(naslov:[Kaj smo se naučili?])[
- Kako zapisati sistem linearnih enačb za spremenljivke, ki ustrezajo vozliščem grafa.
- Spoznali smo še eno iterativno metodo, ki deluje za pozitivno definitne matrike.
]

== Rešitve

#let vaja06(koda) = jlfb(
  "Vaja06/src/Vaja06.jl", koda
)
#figure(
  code_box(
    vaja06("# lestev")
  ),
  caption: [Funkcija, ki ustvari graf krožna lestev.]
)<pr:06-lestev>

#figure(
  code_box(
    vaja06("# matrika")
  ),
  caption: [Funkcija, ki ustvari matriko sistema za ravnovesje sil v grafu.]
)<pr:06-matrika>

#figure(
  code_box(
    vaja06("# desne strani")
  ),
  caption: [Funkcija, ki izračuna desne strani sistema za ravnovesje sil v grafu na
  podlagi koordinat pritrjenih vozlišč.]
)<pr:06-desne-strani>

#figure(
  code_box(
    vaja06("# cg")
  ),
  caption: [Funkcija, ki reši sistem linearnih enačb $A bold(x)=bold(b)$ z metodo konjugiranih gradientov.]
)<pr:06-cg>

#figure(
  code_box(
    vaja06("# vlozitev")
  ),
  caption: [Funkcija, ki poišče koordinate vložitve grafa v $RR^d$ s fizikalno metodo.]
)<pr:06-vlozitev>
