#import "julia.typ": code_box, jl, jlfb

= Fizikalna metoda za vložitev grafov

== Naloga

- Izpelji sistem enačb za koordinate vozlišč grafa, tako da so v ravnovesju.
- Pokaži, da je matrika sistema diagonalno dominantna in negativno definitna.
- Napiši funkcijo, ki za dani graf in koordinate fiksiranih vozlišč, poišče koordinate vseh vozlišč, tako da reši sistem enačb z metodo konjugiranih gradientov.
- V ravnini nariši #link("https://en.wikipedia.org/wiki/Ladder_graph#Circular_ladder_graph")[graf krožno lestev], tako da polovico vozlišč razporediš enakomerno po enotski krožnici.
- V ravnini generiraj naključni oblak točk v notranjosti in na robu kvadrata $[0, 1]^2$. Nariši graf, ki ga dobiš z #link("https://sl.wikipedia.org/wiki/Delaunayeva_triangulacija")[Delaunayevo triangulacijo]. Fiksiraj točke na robu.

== Ravnovesje sil

Naj bo $G$ neusmerjen povezan graf z množico vozlišč $V(G)$ in povezav $E(G)subset V(G)^2$.
Brez škode predpostavimo, da so vozlišča grafa $G$ kar zaporedna naravna števila
$V(G) = {1, 2, dots n}$. Vložitev grafa $G$ v $RR^d$ je preslikava 
$V(G) -> RR^d$, ki je podana z zaporedjem koordinat. Vložitev v $RR^3$ je podana z zaporedjem točk v $RR^3$

$
(x_1, y_1, z_1), (x_2, y_2, z_2), dots, (x_n, y_n, z_n).
$

Za dani graf $G$ želimo poiskati vložitev v $RR^3$ (ali $RR^2$). 
V vsakem vozlišču mreže $j$ morajo biti sile v ravnovesju.

#let FF = $arrow(F)$

$
  sum_(i in N(j)) FF_(i j) = 0,
$<eq:06-ravnovesje>

kjer je $N(j) = {j; quad (i, j) in E(G)}$ množica sosednjih točk v grafu za točko $j$ in $FF_(i j)$ sila s katero vozlišče $j$ deluje na vozlišče $i$.

Harmonična vzmet je idealna vzmet dolžine $0$, za katero sila ni sorazmerna spremembi dolžine, pač pa dolžini vzmeti. Sila harmonične vzmeti, ki je vpeta med točki $(x_1, y_1, z_1)$ in $(x_2, y_2, z_2)$ in deluje drugo krajišče,  je enaka

$
FF_(2 1) = k dot vec(x_2 - x_1, y_2 - y_1, z_2 - z_1),
$

kjer je $k$ koeficient vzmeti. Enačbe @eq:06-ravnovesje lahko izpeljemo sistem enačb za koordinate $x_i, y_i$ in $z_i$.

Iz vektorske enačbe

$
  sum_(j in N(1)) k vec(x_j - x_1, y_j - y_1, z_j - z_1) = 0
$

dobimo enačbe za posamezne koordinate

#let st = math.op("st")

$
   -st(1)x_1 + x_(j_1) + x_(j_2) + dots + x_(j_(st(1))) &= 0\
   -st(1)y_1 + y_(j_1) + y_(j_2) + dots + y_(j_(st(1))) &= 0\
   -st(1)z_1 + z_(j_1) + z_(j_2) + dots + z_(j_(st(1))) &= 0\
   dots.v \
   x_(j_1) + x_(j_2) + dots + x_(j_(st(n))) - st(n)x_n&= 0\
   y_(j_1) + y_(j_2) + dots + y_(j_(st(n))) - st(n)y_n &= 0\
   z_(j_1) + z_(j_2) + dots + z_(j_(st(n))) - st(n)z_n &= 0.
$<eq:06-trojni-sistem>


Koordinate $x$, $y$ in $z$ so neodvisni druga od druge in tako dobimo po en sistem enačb za vsako koordinato. Enačbe @eq:06-trojni-sistem so homogene, kar pomeni, da ima ničelno rešitev. Če želimo netrivialno rešitev, moramo nekaterim vozliščem v grafu predpisati koordinate. Brez škode lahko predpostavimo, da so vozlišča, ki jih fiksiramo na koncu. Označimo z $F={m+1, dots, n} subset V(G)$ množico vozlišč, ki jih fiksiramo. Koordinate za vozlišča iz $F$ niso več spremenljivke, ampak jih moramo prestaviti na drugo stran enačbe. Za lažji zapis označimo z 

$
  1_A(k) = cases(1 med k in A, 0 med k in.not A)
$

indikatorsko funkcijo za množico $A$. Sistem enačb @eq:06-trojni-sistem postane nehomogen sistem:

$
  -st(1)x_1 + 1_(N(1))(2)x_2 + dots + 1_(N(1))(m)x_m = -sum_(j=m+1)^n 1_(N(1))(j)x_j\
  1_(N(2))(1)x_1 - st(2)x_2 + dots + 1_(N(2))(m)x_m = -sum_(j=m+1)^n 1_(N(2))(j)x_j\
  dots.v\
  1_(N(m))(1)x_1 + 1_(N(m))(2)x_2 + dots - st(m)x_m  = -sum_(j=m+1)^n 1_(N(m))(j)x_j
$<eq:06sistem-x>

in podobno za koordinati $y$ in $z$. Matrika sistema @eq:06sistem-x je odvisna le od grafa in
izbire točk, ki so proste. 

$
A = mat(
  -st(1), 1_(N(1))(2), dots, 1_(N(1))(m);
  1_(N(2))(1), - st(2), dots, 1_(N(2))(m);
  dots.v, dots.v, dots.down, dots.v;
  1_(N(m))(1), 1_(N(m))(2), dots, - st(m)
)
$<eq:06-matrika>

Za predstavitev grafa bomo uporabili paket #link("https://juliagraphs.org/Graphs.jl")[Graphs.jl],
ki definira podatkovne tipe in vmesnike za lažje delo z grafi.

== Metoda konjugiranih gradientov

Matrika @eq:06-matrika je simetrična in diagonalno dominantna. Res! Velja $st(i) = |N(i)|$ in je zato

$
  |a_(i i)| = |N(i)| >= |N(i) sect F^C| =  sum |a_(i j)|. 
$ 

Za sosede fiksnih vozlišč je neenakost stroga. Ker so vsi elementi na diagonali negativni, je
matrika $A$ negativno definitna. Zato lahko za reševanje sistema $-A x = -b$ uporabimo 
#link("https://en.wikipedia.org/wiki/Conjugate_gradient_method")[metodo konjugiranih gradientov].

Za večino grafov, za katere uporabimo zgornji postopek bo matrika sistema $A$ redka.   


== Rešitve

#let vaja06(koda) = jlfb(
  "Vaja06/src/Vaja06.jl", koda
)

#figure(
  code_box(
    vaja06("# matrika")
  ),
  caption: [Ustvari matriko sistema za ravnovesje sil v grafu]
)<pr:06-matrika>

#figure(
  code_box(
    vaja06("# desne strani")
  ),
  caption: [Izračunaj desne strani sistema za ravnovesje sil v grafu na 
  podlagi koordinat vozlišč, ki so fiksirana]
)<pr:06-desne-strani>

#figure(
  code_box(
    vaja06("# vlozitev")
  ),
  caption: [Poišči koordinate vložitve grafa v $RR^d$ s fizikalno metodo]
)<pr:06-vlozitev>

#figure(
  code_box(
    vaja06("# cg")
  ),
  caption: [Metoda konjugiranih gradientov za reševanje sistema $A x=b$
  za pozitivno definitno matriko $A$]
)<pr:06-cg>