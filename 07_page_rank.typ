#import "julia.typ": code_box, jl, jlfb

= Invariantna porazdelitev Markovske verige

== Naloga

- Implementiraj potenčno metodo za iskanje največje lastne vrednosti.
- Uporabi potenčno metodo in poišči invariantno porazdelitev Markovske verige z
  dano prehodno matriko $P$. Poišči invariantne porazdelitve za naslednja primera:
    - veriga, ki opisuje skakanje konja (skakača) po šahovnici,
    - veriga, ki opisuje brskanje po mini spletu z 5-10 stranmi (podobno spletni iskalniki 
    #link("https://en.wikipedia.org/wiki/PageRank")[razvrščajo strani po relevantnosti]).

== Invariantna porazdelitev Markovske verige

Z #link("https://en.wikipedia.org/wiki/Markov_chain")[Markovskimi verigami] smo se že srečali v 
poglavju o tridiagonalnih sistemih @tridiagonalni-sistemi. Porazdelitev Markovske verige $X_k$ je
podana z matriko $P$, katere elementi so prehodne verjetnosti:

$
p_(i j) = P(X_(k+1) = j | X_k = i).
$

Naj bo $X_k$ Markovska veriga z $n$ stanji in naj bo 
$bold(p)^((k)) = [p_1^((k)), p_2^((k)), dots p_n^((k))]$ porazdelitev po stanjih na $k$-tem koraku 
$X_k$ ($p_i^((k)) = P(X_k = i)$). Porazdelitev na naslednjem koraku $X_(k+1)$ dobimo tako, da
seštejemo verjetnosti po vseh možnih stanjih na prejšnjem koraku pomnožene s pogojnimi verjetnostmi, 
da iz enega stanja preidemo v drugega

$
 p_i^((k+1)) = sum_(j=1)^n P(X_(k+1)=i| X_k = j) P(X_k = j) = sum_(j=1)^n p_(j i) p_j^((k))\
 bold(p)^((k+1)) = P^T bold(p)^((k)).
$

Če zaporedje porazdelitev $p^((k))$ konvergira k limitni porazdelitvi $bold(p)^(oo)$, potem je 
limitna porazdelitev lastni vektor za $P^T$ za lastno vrednost $1$:
$
  bold(p)^(oo) = lim_(k->oo) bold(p)^((k)) = lim_(k->oo) bold(p)^((k+1)) =
  lim_(k->oo) P^T bold(p)^((k)) =  P^T lim_(k->oo) bold(p)^((k)) = P^T bold(p)^(oo).  
$

Ker so vsote elementov po vrsticah za prehodno matriko $P$ enake $1$, je $1$ lastna vrednost 
matrike $P$ in zato tudi lastna vrednost matrike $P^T$. Zato limitna porazdelitev $bold(p)^(oo)$
vedno obstaja, ni pa nujno enolična. Ker matrika $P^T$ ne spremeni limitne porazdelitve
$bold(p)^(oo)$, limitno porazdelitve imenujemo tudi #emph[invariantna porazdelitev].

Da se pokazati, da je $1$ po absolutni vrednosti največja lastna vrednost matrike $P$ in $P^T$, zato
lahko lastni vektor poiščemo s 
#link("https://en.wikipedia.org/wiki/Power_iteration")[potenčno metodo]. 

== Potenčna metoda
S potenčno metodo poiščemo lastni vektor dane matrike $A$ za po absolutni vrednosti največjo lastno
vrednost matrike $A$. Če je takih lastnih vrednosti več (npr. $1$ in $-1$), se lahko zgodi, da 
potenčna metoda ne konvergira. Izberemo neničelen začetni vektor $bold(p)^((0))eq.not 0$ in 
sestavimo zaporedje približkov

$
bold(x)^((k+1)) = (A bold(x)^((k)))/norm(A bold(x)^((k))),
$<eq:potencna>

ki konvergira k lastnemu vektorju za največjo lastno vrednost. Za normo, s katero delimo produkt 
$A bold(x)^((k))$, lahko izberemo katerakoli vektorsko normo. Ponavadi je to neskončna norma
$norm(dot)_(oo)$, saj jo lahko najhitreje določimo.

Napišimo program #jl("x, it = potencna(A, x0)"), ki poišče lastni vektor za po absolutni vrednosti
največjo lastno vrednost matrike $A$ (@pr:07potencna). 

== Razvrščanje spletnih strani

Spletni iskalniki želijo uporabniku prikazati čim bolj relevantne rezultate. Zato morajo ugotoviti,
katere spletne strani so bolj pomembne od drugih. Brskanje po spletu lahko modeliram z Markovsko
verigo, kjer na vsakem koraku obiščemo eno spletno stran. Na vsaki spletne strani, ki jo obiščemo,
naključno izberemo povezavo, ki nas vodi do naslednje strani. Če spletna stran nima povezav, lahko 
gremo nazaj na prejšnjo stran ali pa naključno izberemo drugo stran. Limitna porazdelitev pove, 
kolikšen delež vseh obiskov pripada posamezni spletni strani, če se naključno sprehajamo po spletu. 
Večji delež obiskov ima spletna stran, bolj je pomembna.

Limitno porazdelitev Markovske verige s prehodno matriko $P$ poiščemo s potenčno metodo, kot 
lastni vektor matrike $P^T$ za lastno vrednost $1$.

Približno tako deluje algoritem za razvrščanje spletnih strani po pomembnosti 
#link("https://en.wikipedia.org/wiki/PageRank")[Page Rank], ki sta ga prva opisala in uporabila 
ustanovitelja podjetja Google Larry Page in Sergey Brin.

== Skakanje konja po šahovnici

Naključno skakanje konja po šahovnici lahko opišemo z Markovsko verigo. Stanja Markovske 
verige so polja na šahovnici, prehodne verjetnosti pa določimo tako, da konj v naslednji potezi 
naključno skoči na eno od polj, ki so mu dostopna. Predpostavimo, da so vsa dostopna polja enako 
verjetna. 

#figure(
  image("img/07poteze_konja.png", width: 40%),
  caption: [Možne poteze, ki jih lahko naredi konj.]
)
Stanja označimo s pari 
indeksov, ki označujejo posamezno polje. Invariantna porazdelitev je podana z matriko verjetnosti, 
tako elementi matrike ustrezajo poljem na šahovnici. 
Zopet se srečamo s problemom iz prejšnjega poglavja @minimalne-ploskve, kako elemente matrike
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

ki izračunata preslikavo med indeksi $i, j$ v matriki in indeksu $k$ v vektorju (@pr:07indeksi). 

Nato definirajmo 
- podatkovno strukturo #jl("Konj(m, n)"), ki predstavlja Markovsko verigo za konja na 
  $m times n$ šahovnici (@pr:07konj) in 
- funkcijo #jl("prehodna_matrika(k::Konj)"), ki vrne
  prehodno matriko za Markovsko verigo za konja (@pr:07prehodna). 
Invariantno porazdelitev poskusimo poiskati s potenčno metodo:

#code_box(
  jlfb("scripts/07_page_rank.jl", "# konj")
)

Potenčna metoda ne konvergira, saj ima matrika $P^T$ dve dominantni lastni vrednosti $1$ in $-1$. 
Skoraj vsi začetni približki vsebujejo tako komponento v smeri lastnega vektorja za $1$ kot tudi 
komponento v smeri lastnega vektorja za $-1$. Zaporedje približkov v limiti začne preskakovati med
dvema vrednostima 

$
  &(bold(v_1) + bold(v)_(-1))/norm(bold(v)_1 + bold(v)_(-1)) " in "\
  &(bold(v_1) - bold(v)_(-1))/norm(bold(v)_1 + bold(v)_(-1)),
$

kjer je $v_1$ lastni vektor za $1$ in $v_(-1)$ lastni vektor za $-1$.

#code_box[
  #jlfb("scripts/07_page_rank.jl", "# lastne")
  #raw(read("out/07_lastne.out"))
]

Težavo rešimo s preprostim premikom. Če matriki prištejemo večkratnik identitete, se lastni vektorji
ne spremenijo, le lastne vrednosti se premaknejo. Če so 
$(lambda_1, bold(v)_1), (lambda_2, bold(v)_2), dots$ lastni pari matrike $A$, potem so

$ (lambda_1 + delta, bold(v)_1), (lambda_2 + delta, bold(v)_2), dots $

lastni pari matrike 

$ A + delta I. $

S premikom $P^T + I$ dosežemo, da se lastne vrednosti premaknejo za $1$ v pozitivni smeri in se 
lastna vrednost $-1$ premakne v $0$, lastna vrednost $1$ pa v $2$. Lastna vrednost $2$ postane edina
dominantna lastna vrednost. Za matriko $P^T + I$ potenčna metoda konvergira k lastnemu vektorju 
matrike $P^T + I$ za lastno vrednost $2$, ki je hkrati lastni vektor matrike $P^T$ za lastno
vrednost $1$.

#code_box(
  jlfb("scripts/07_page_rank.jl", "# premik")
)

#figure(
  image("img/07-konj.svg", width:60%),
  caption: [Invariantna porazdelitev za konja na standardni $8 times 8$ šahovnici. Svetlejša polja so pogosteje obiskana.]
)
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
  stolpcev matrike.]
)<pr:07indeksi>

#figure(
  code_box(
    jlfb("Vaja07/src/Vaja07.jl", "# konj")
  ),
  caption: [Podatkovni tip, ki predstavlja  Markovsko verigo za konja, ki skače po
  šahovnici.]
)<pr:07konj>

#figure(
  code_box(
    jlfb("Vaja07/src/Vaja07.jl", "# prehodna_matrika")
  ),
  caption: [Funkcija, ki ustvari prehodno matriko za Markovsko verigo za konja, ki skače po
  šahovnici.]
)<pr:07prehodna>