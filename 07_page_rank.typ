#import "julia.typ": code_box, jl, jlfb
#import "admonitions.typ": opomba
#import "@preview/fletcher:0.5.2": diagram, node, edge

= Invariantna porazdelitev Markovske verige

#let Pm = (math.cal[P])
Z #link("https://en.wikipedia.org/wiki/Markov_chain")[Markovskimi verigami] smo se že srečali v
poglavju o tridiagonalnih sistemih (@tridiagonalni-sistemi). Spomnimo se, da je Markovska veriga
zaporedje slučajnih spremenljivk $X_k$, ki opisujejo slučajni sprehod po množici stanj. Stanja Markovske verige bomo označili kar z zaporednimi naravnimi števili $1, 2, med dots med n$. Na vsakem koraku je
Markovska veriga v določenem stanju $X_(k) in {1, 2, med dots med n}$. Porazdelitev na naslednjem koraku $X_(k+1)$
je odvisna zgolj od poradelitve na prejšnjem koraku $X_(k)$ in prehodnih verjetnosti za prehod iz stanja $i$ v stanje $j$:
$
p_(i j) = P(X_(k+1) = j | X_k = i).
$

Matrika $Pm = [p_(i j)]$, katere elementi so prehodne verjetnosti za prehod iz stanja $i$ v stanje $j$, imenujemo #emph[prehodna matrika Markovkse verige].

Naj bo $X_k$ Markovska veriga z $n$ stanji in naj bo
$bold(p)^((k)) = [p_1^((k)), p_2^((k)), dots p_n^((k))]$ porazdelitev po stanjih na $k$-tem koraku
 ($p_i^((k)) = P(X_k = i)$).

 Porazdelitev $bold(p)^(k)$ Markovske verige je #emph[invariantna], če je za vse $k$ enaka:
$
  bold(p)^(k+1) = bold(p)^(k).
$

Porazdelitev na naslednjem koraku $X_(k+1)$ dobimo tako, da
seštejemo verjetnosti po vseh možnih stanjih na prejšnjem koraku, pomnožene s pogojnimi verjetnostmi,
da iz enega stanja preidemo v drugega:

$
 p_i^((k+1)) = sum_(j=1)^n P(X_(k+1)=i| X_k = j) P(X_k = j) = sum_(j=1)^n p_(j i) p_j^((k))\
 bold(p)^((k+1)) = Pm^T bold(p)^((k)).
$

Od tod sledi, da je porazdelitev $bold(p)$ #emph[invariantna porazdelitev] Markovske verige s prehodno matriko $Pm$, če velja:

$
bold(p) = Pm^T bold(p).
$

Povedano drugače: invariatna porazdelitev za Markovsko verigo s prehodno matriko $Pm$ je lastni vektor matrike $Pm$ z lastno vrednostjo $1$.

== Naloga

- Implementiraj potenčno metodo za iskanje največje lastne vrednosti in lastnega vektorja dane matrike.
- Uporabi potenčno metodo in poišči invariantno porazdelitev Markovske verige z
  dano prehodno matriko $Pm$. Poišči invariantne porazdelitve za naslednja primera:
    - veriga, ki opisuje skakanje konja (skakača) po šahovnici,
    - veriga, ki opisuje brskanje po mini spletu s 5-10 stranmi (podobno spletni iskalniki
      #link("https://en.wikipedia.org/wiki/PageRank")[razvrščajo strani po relevantnosti]).

== Limitna porazdelitev Markovske verige

Porazdelitev $bold(p)$ je #emph[limitna porazdelitev] Markovske verige, če porazdelitve na posameznih korakih $bold(p)^(k)$
konvergirajo k $bold(p)$. Limitna porazdelitev je vedno invariantna in potemtakem lastni vektor $Pm^T$ z lastno vrednostjo $1$:

$
  bold(p)^(oo) = lim_(k->oo) bold(p)^((k)) = lim_(k->oo) bold(p)^((k+1)) =
  lim_(k->oo) Pm^T bold(p)^((k)) =  Pm^T lim_(k->oo) bold(p)^((k)) = Pm^T bold(p)^(oo).
$

Ker so vsote elementov po vrsticah za prehodno matriko $Pm$ enake $1$, je $1$ lastna vrednost
matrike $Pm$ in zato tudi lastna vrednost matrike $Pm^T$. Posledično limitna porazdelitev $bold(p)^(oo)$
vedno obstaja, ni pa nujno enolična.

Da se pokazati, da je $1$ po absolutni vrednosti največja lastna vrednost matrike $Pm$ in $Pm^T$, zato
lahko invariantno porazdelitev poiščemo s
#link("https://en.wikipedia.org/wiki/Power_iteration")[potenčno metodo].

== Potenčna metoda

S potenčno metodo poiščemo lastni vektor matrike $A$ s po absolutni vrednosti največjo lastno
vrednostjo. Izberemo neničelen začetni vektor $bold(p)^((0))eq.not 0$ in
sestavimo zaporedje približkov:

$
bold(x)^((k+1)) = (A bold(x)^((k)))/norm(A bold(x)^((k))).
$<eq:potencna>

Zaporedje $bold(x)^k$ konvergira k lastnemu vektorju matrike $A$ z lastno vrednostjo, ki je po
absolutni vrednosti največja. Če je takih lastnih vrednosti več (npr. $1$ in $-1$), se lahko zgodi, da
potenčna metoda ne konvergira. Za normo, s katero delimo produkt
$A bold(x)^((k))$, lahko izberemo katerokoli vektorsko normo. Navadno je to neskončna norma
$norm(dot)_(oo)$, saj jo lahko najhitreje izračunamo.

Napišimo program #jl("x, it = potencna(A, x0)"), ki poišče lastni vektor za po absolutni vrednosti
največjo lastno vrednost matrike $A$ (@pr:07potencna).

== Razvrščanje spletnih strani

Spletni iskalniki želijo uporabniku prikazati čim relevantnejše rezultate. Zato morajo ugotoviti,
katere spletne strani so pomembnejše od drugih. Brskanje po spletu lahko modeliramo z Markovsko
verigo, kjer na vsakem koraku obiščemo eno spletno stran. Na vsaki spletni strani, ki jo obiščemo,
naključno izberemo povezavo, ki nas vodi do naslednje strani. Če spletna stran nima povezav, se lahko
vrnemo nazaj na prejšnjo stran ali pa naključno izberemo novo stran. Limitna porazdelitev pove,
kolikšen delež vseh obiskov pripada posamezni spletni strani, če se naključno sprehajamo po spletu.
Večji delež obiskov ima spletna stran, pomembnejša je.

Limitno porazdelitev Markovske verige s prehodno matriko $Pm$ poiščemo s potenčno metodo, kot
lastni vektor matrike $Pm^T$ za lastno vrednost $1$.

Približno tako deluje algoritem za razvrščanje spletnih strani po pomembnosti
#link("https://en.wikipedia.org/wiki/PageRank")[Page Rank], ki sta ga prva opisala in uporabila
ustanovitelja podjetja Google Larry Page in Sergey Brin.

#figure(
  diagram(
    node-stroke: 1pt,
    node((1, 0), $1$, name: "1"),
    node((calc.cos(calc.pi/3), calc.sin(calc.pi/3)), $2$, name: "2"),
    node((calc.cos(2*calc.pi/3), calc.sin(2*calc.pi/3)), $3$, name: "3"),
    node((calc.cos(3*calc.pi/3), calc.sin(3*calc.pi/3)), $4$, name: "4"),
    node((calc.cos(4*calc.pi/3), calc.sin(4*calc.pi/3)), $5$, name: "5"),
    node((calc.cos(5*calc.pi/3), calc.sin(5*calc.pi/3)), $6$, name: "6"),
    edge(label("1"), label("2"), "-|>"),
    edge(label("1"), label("4"), "-|>"),
    edge(label("1"), label("6"), "-|>"),
    edge(label("2"), label("3"), "-|>"),
    edge(label("2"), label("4"), "-|>"),
    edge(label("3"), label("5"), "-|>"),
    edge(label("3"), label("4"), "-|>"),
    edge(label("5"), label("6"), "-|>"),
    edge(label("5"), label("6"), "-|>"),
    edge(label("4"), label("3"), "-|>"),
    edge(label("4"), label("1"), "-|>"),
    edge(label("6"), label("2"), "-|>"),
  ),
  caption: [Mini splet s 6 stranmi]
)

Prehodna matrika verige je

$
Pm = mat(
  0, 1/3, 0, 1/3, 0, 1/3;
  0, 0, 1/2, 1/2, 0, 0;
  0, 0, 0, 1/2, 1/2, 0;
  1/2, 0, 1/2, 0, 0, 0;
  0, 0, 0, 0, 0, 1;
  0, 1, 0, 0, 0, 0;
)
$
Poiščimo invariantno porazdelitev s potenčno metodo:

#code_box(
  jlfb("scripts/07_page_rank.jl", "# splet 1")
)

Preverimo, ali je dobljeni vektor res lastni vektor za lastno vrednost $1$, tako da izračunamo razliko $Pm^T bold(x) - bold(x)$ in preverimo, da je razlika blizu $0$:

#code_box[
  #jlfb("scripts/07_page_rank.jl", "# splet 2")
  #raw(read("out/07_splet.out"))
]

Invariantno porazdelitev predstavimo s stolpčnim diagramom:

#code_box(
  jlfb("scripts/07_page_rank.jl", "# splet 3")
)
#figure(
  image("img/07-rang.svg", width: 60%),
  caption: [Delež obiskov posamezne strani v limitni porazdelitvi]
)

Iz diagrama vidimo, da je najpogosteje obiskana spletna stran $4$, najredkeje pa spletna stran $5$.

== Skakanje konja po šahovnici

Tudi naključno skakanje konja po šahovnici lahko opišemo z Markovsko verigo. Stanja Markovske
verige so polja na šahovnici, prehodne verjetnosti pa določimo tako, da konj v naslednji potezi
naključno skoči na eno od polj, ki so mu dostopna. Predpostavimo, da so vsa dostopna polja enako
verjetna.

#figure(
  image("img/07poteze_konja.png", width: 40%),
  caption: [Možne poteze, ki jih lahko naredita beli in črni konj na $5 times 5$ šahovnici]
)
Stanja označimo s pari
indeksov $(i, j)$, ki označujejo posamezno polje. Invariantna porazdelitev je podana z matriko, katere elementi $p_(i j)$ so enaki verjetnosti, da je konj na polju $(i, j)$.
Ponovno se srečamo s problemom iz prejšnjega poglavja (@minimalne-ploskve), kako elemente matrike
postaviti v vektor. Elemente matrike zložimo v vektor po stolpcih. Preslikava med indeksi $i, j$ v
matriki in indeksom $k$ v vektorju je podana s formulami

$
  k &= i + (j-1)m\
  j &= floor((k -1)\/ m)\
  i &= ((k -1) mod m) + 1.
$

Za lažje delo napišimo funkciji

- #jl("k = ij_v_k(i, j, m)") in
- #jl("i, j = k_v_ij(k, m)"),

ki izračunata preslikavo med indeksi $i, j$ v matriki in indeksom $k$ v vektorju (@pr:07indeksi).

Nato definirajmo:
- podatkovno strukturo #jl("Konj(m, n)"), ki predstavlja Markovsko verigo za konja na
  $m times n$ šahovnici (@pr:07konj) in
- funkcijo #jl("prehodna_matrika(k::Konj)"), ki vrne
  prehodno matriko za Markovsko verigo za konja (@pr:07prehodna).
Invariantno porazdelitev poskusimo poiskati s potenčno metodo:

#code_box(
  jlfb("scripts/07_page_rank.jl", "# konj")
)

Potenčna metoda ne konvergira, saj ima matrika $Pm^T$ dve dominantni lastni vrednosti $1$ in $-1$.
Skoraj vsi začetni približki vsebujejo tako komponento v smeri lastnega vektorja za $1$ kot tudi
komponento v smeri lastnega vektorja za $-1$. Zaporedje približkov v limiti začne preskakovati med
dvema vrednostima:

$
  &(bold(v_1) + bold(v)_(-1))/norm(bold(v)_1 + bold(v)_(-1)) " in "
  &(bold(v_1) - bold(v)_(-1))/norm(bold(v)_1 + bold(v)_(-1)),
$

kjer je $v_1$ lastni vektor za $1$ in $v_(-1)$ lastni vektor za $-1$.

#code_box[
  #jlfb("scripts/07_page_rank.jl", "# lastne")
  #raw(read("out/07_lastne.out"))
]

Težavo rešimo s preprostim premikom. Če matriki prištejemo večkratnik identitete, se lastni vektorji
ne spremenijo, le lastne vrednosti se premaknejo. Če so
$(lambda_1, bold(v)_1), (lambda_2, bold(v)_2), dots$ lastni pari matrike $A$, so:

$ (lambda_1 + delta, bold(v)_1), (lambda_2 + delta, bold(v)_2) med dots $

lastni pari matrike

$ A + delta I. $

S premikom $Pm^T + I$ dosežemo, da se lastne vrednosti premaknejo za $1$ v pozitivni smeri in se
lastna vrednost $-1$ premakne v $0$, lastna vrednost $1$ pa v $2$. Tako lastna vrednost $2$ postane edina
dominantna lastna vrednost. Za matriko $Pm^T + I$ potenčna metoda konvergira k lastnemu vektorju
za lastno vrednost $2$, ki je hkrati lastni vektor matrike $Pm^T$ za lastno
vrednost $1$.

#code_box(
  jlfb("scripts/07_page_rank.jl", "# premik")
)

#figure(
  image("img/07-konj.svg", width:60%),
  caption: [Limitna porazdelitev za konja na standardni $8 times 8$ šahovnici. Svetlejša polja so pogosteje obiskana. Limitna porazdelitev je ena sama in ni odvisna od porazdelitve na začetku.]
)

#opomba(naslov: [Kaj smo se naučili?])[
- Tudi pri iskanju lastnih vektorjev in vrednosti se iterativne metode dobro obnesejo.
- Potenčna metoda se obnese tudi pri matrikah zelo velikih dimenzij.
- Problem lastnih vrednosti se pojavi pri študiju Markovskih verig.
]

== Rešitve

#figure(
  code_box(
    jlfb("Vaja07/src/Vaja07.jl", "# potencna")
  ),
  caption: [Potenčna metoda poišče lastni vektor za po absolutni vrednosti
  največjo lastno vrednost dane matrike.]
)<pr:07potencna>

#figure(
  code_box(
    jlfb("Vaja07/src/Vaja07.jl", "# indeksi")
  ),
  caption: [Preslikave med indeksi v matriki in indeksi v vektorju, ki je sestavljen iz
  stolpcev matrike]
)<pr:07indeksi>

#figure(
  code_box(
    jlfb("Vaja07/src/Vaja07.jl", "# konj")
  ),
  caption: [Podatkovni tip, ki predstavlja  Markovsko verigo za konja na
  šahovnici]
)<pr:07konj>

#figure(
  code_box(
    jlfb("Vaja07/src/Vaja07.jl", "# prehodna_matrika")
  ),
  caption: [Funkcija, ki ustvari prehodno matriko za Markovsko verigo za konja na
  šahovnici]
)<pr:07prehodna>
