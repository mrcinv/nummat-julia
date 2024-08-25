#import "admonitions.typ": opomba
#import "julia.typ": jl, jlfb, code_box, repl
= Spektralno razvrščanje v gruče
<spektralno-razvrščanje-v-gruče>

== Naloga


Pokazali bomo metodo razvrščanja v gruče, ki uporabi spektralno analizo
Laplaceove matrike podobnostnega grafa, tako da podatke
preslika v prostor, kjer jih je lažje razvrstiti.
- Napiši funkcijo, ki zgradi podobnostni graf za dane podatke. Podatki so dani kot oblak točk v
  $RR^d$. V podobnostnem grafu je vsak točka v oblaku vozlišče, s točko $k$ pa povežemo vse točke,
  ki ležijo v $epsilon$ okolici te točke za primerno izbrani $epsilon$.
- Napiši funkcijo, ki za dano simetrično matriko poišče najmanjših $k$ lastnih parov.
  Če inverzno iteracijo uporabimo na $n times k$ matriki približkov in s
  QR razcepom poskrbimo, da so stolpci ortogonalni, potem faktor $Q$ konvergira k lastnim vektorjem,
  diagonala faktorja $R$ pa k $k$ najmanjšim lastnim vrednostim matrike.
- Funkcijo za iskanje lastnih vektorjev uporabi za Laplaceovo matriko podobnostnega grafa podatkov.
  Za primer podatkov naključno generiraj mešanico 3 Gaussovih porazdelitev.
  Komponente lastnih vektorjev uporabi kot nove koordinate in podatke predstavi v novih koordinatah.

== Podobnostni graf in Laplaceova matrika
<podobnostni-graf-in-laplaceova-matrika>

Podatke (množico točk v $RR^n$) želimo razvrstiti v več gruč. V nadaljevanju bomo opisali postopek
imenovan #link("https://en.wikipedia.org/wiki/Spectral_clustering")[spektralno gručenje], kot je
opisan v @von_luxburg_tutorial_2007.

Osnova za spektralno gručenje je #emph[podobnostni uteženi graf], ki povezuje točke, ki
so si v nekem smislu blizu. Podobnostni graf lahko ustvarimo na več
načinov:

- #strong[$ε$-okolice]: s točko $x_k$ povežemo vse točke, ki ležijo v
  ε-okolici te točke
- #strong[$k$ najbližji sosedi]: $x_k$ povežemo z $x_i$, če je
  $x_i$ med $k$ najbližjimi točkami. Tako dobimo usmerjen graf,
  zato ponavadi upoštevmo povezavo v obe smeri.
- #strong[poln utežen graf]: povežemo vse točke, vendar povezave utežimo
  glede na razdaljo. Pogosto uporabljena utež je nam znana
  #link("https://en.wikipedia.org/wiki/Radial_basis_function")[radialna bazna funkcija]:

  $ w(x_i , x_k) = exp (-(norm(x_i - x_k)^2)/(2 sigma^2)) $

  pri kateri s parametrom $sigma$ lahko določamo velikost okolic.

Uteženemu grafu podobnosti z matriko uteži

$ W = [w_(i j)] $

priredimo #link("https://sl.wikipedia.org/wiki/Laplaceova_matrika")[Laplaceovo matriko]

$ L = D - W, $

kjer je $D = [d_(i j)]$ diagonalna matrika z elementi
$d_(i i) = sum_(j eq.not i) w_(i j)$. Če graf ni utežen, namesto matrike uteži uporabimo
#link("https://sl.wikipedia.org/wiki/Matrika_sosednosti")[matriko sosednosti]. Laplaceova matrika
$L$ je simetrična, nenegativno definitna in ima vedno eno lastno vrednost $0$ za lastni
vektor iz samih enic. Laplaceova matrika je pomembna v
#link("https://sl.wikipedia.org/wiki/Spektralna_teorija_grafov")[spektralni teoriji grafov], ki
preučuje lastnosti grafov s pomočjo analize lastnih vrednosti in vektorjev matrik.

== Algoritem
<algoritem>
Velja naslednji izrek, da ima Laplaceova matrika natanko toliko lastnih
vektorjev za lastno vrednost 0, kot ima graf komponent za povezanost. Na
prvi pogled se zdi, da bi lahko bile gruče kar komponente grafa, a se
izkaže, da to ni najbolje. Namesto tega bomo gruče poskali v drugem koordinatnem sistemu,
ki ga določajo lastni podprostori Laplaceove matrike podobnostnega grafa. Postopek je naslednji:

- Poiščemo $k$ najmanjših lastnih vrednosti za Laplaceovo matriko
  in izračunamo njihove lastne vektorje.
- Označimo matriko lastnih vektorjev $Q=[v_1, v_2, dots,v_k]$. Stolpci
  $Q^T$ ustrezajo koordinatam točk v novem prostoru.
- Za stolpce matrike $Q^T$ izvedemo izbran algoritem gručenja
  (npr. algoritem $k$ povprečij).

#opomba(naslov: [Algoritem $k$ povprečij])[

Izberemo si število gruč $k$. Najprej točke naključno razdelimo v $k$ gruč.
Nato naslednji postopek ponavljamo, dokler se rezultat ne spreminja več
- izračunamo center posamezne gruče $bold(c)_i= 1/(|G_i|)sum_(j in G_i) bold(x)_i$,
- vsako točko razvrstimo v gručo, ki ima najbližji center.

]

== Primer
<primer>
Algoritem preverimo na mešanici treh Gaussovih porazdelitev.

#let demo8(koda) = code_box(jlfb("scripts/08_cluster.jl", koda))

#demo8("# gauss mix")

#figure(
  image("img/08_oblak.svg", width: 60%),
  caption: [
    Mešanica 3 gaussovih porazdelitev v ravnini
  ]
)

Izračunamo graf sosednosti z metodo $epsilon$-okolic in poiščemo
Laplaceovo matriko dobljenega grafa.

#demo8("# laplace")

#figure(
  image("img/08_laplaceova_matrika.svg", width: 60%),
  caption: [
    Neničelni elementi Laplaceove matrike
  ]
)

Če izračunamo lastne vrednosti Laplaceove matrike dobljenega
grafa, vidimo, da sta 5. in 6. lastna vrednost najmanjši vrednosti, ki sta bistveno večji od 0.

#demo8("# eigen")

#figure(
  image("img/08_lastne_vrednosti.svg", width: 60%),
  caption: [
    Lastne vrednosti Laplaceove matrike
  ]
)

Komponente lastnih vektorjev za 5. in 6. lastno vrednost uporabimo za nove koordinate.

#demo8("# vlozitev")

#figure(
  image("img/08_vlozitev.svg", width: 60%),
  caption: [
    Vložitev točk v nov prostor določen z lastnima vektorjema Laplaceove matrike. Slika ilustrira,
    kako lahko s preslikavo v drug prostor gruče postanejo bolj očitne.
  ]
)

Seveda se pri samem algoritmu gručenja ni treba omejiti le na dva lastna vaektorja, ampak se izbere
lastne vektorje za $k$ najmanjših neničelnih lastnih vrednosti.

== Inverzna potenčna metoda
<inverzna-potenčna-metoda>
Ker nas zanima le najmanjših nekaj lastnih vrednosti, lahko njihov
izračun in za izračun lastnih vektrojev uporabimo
#link("https://en.wikipedia.org/wiki/Inverse_iteration")[inverzno potenčno metodo].
Pri inverzni potenčni metodi zgradimo zaporedje približkov z rekurzivno
formulo

$ bold(x)^((k + 1)) = (A^(- 1) bold(x)^((n)))/norm(A^(- 1) bold(x)^((n))). $<eq:9-inviter>

Zaporedje približkov $bold(x^((k)))$ konvergira k lastnemu vektorju za najmanjšo
lastno vrednost matrike $A$ za skoraj vse izbire začetnega približka.

#opomba(naslov:
[Namesto inverza uporabite LU razcep ali drugo metodo za reševanje linearnega sistema])[
V inverzni iteraciji moramo večkrat zaporedoma izračunati vrednost
$ A^(-1) bold(x^((k))). $

Za izračun te vrednosti pa v resnici ne potrebujemo inverzne matrike $A^(-1)$.
Računanje inverzne matrike je namreč časovno zelo zahtevna operacija, zato se ji, razen v nizkih
dimenzijah, če je le mogoče izognemo. Produkt $bold(x) = A^(-1)bold(b)$ je rešitev linearnega
sistema $A bold(x) = bold(b)$ in metode za reševanje sistema so bolj učinkovite kot
računanje inverza $A^(-1)$.

Inverz $A^(-1)$ matrike $A$ lahko nadomestimo z razcepom matrike $A$.
Če na primer uporabimo LU razcep $A=L U$, lahko $A^(-1) bold(b)$ izračunamo tako, da rešimo
 sistem $A bold(x) = bold(b)$ oziroma $L U bold(x) = bold(b)$ v dveh korakih

 $
 L bold(y)& = bold(b)\
 U bold(x)& = bold(y),
 $

 ki sta časovno toliko zahtevna, kot je množenje z matriko $A^(-1)$.
 Programski jezik `julia` ima za ta namen prav posebno metodo
 #link("https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#LinearAlgebra.factorize")[factorize],
 ki za različne vrste matrik, izračuna najbolj primeren razcep. Rezultat metode `factorize` je
 vrednost za katero lahko uporabimo operator `\`, da učinkovito izračunamo rešitev sistema:

 #code_box[
 #repl("F = factorize(A)", none)
 #repl("x = F\\b # ekvivalentno A\\b ampak bolj učinkovito", none)
 ]
]

Napišimo funkcijo #jl("inviter(resi, x0)"), ki poišče lastni par za najmanjšo lastno vrednost matrike
(rešitev je @pr:9-inviter). Matrika ni podana eksplicitno, ampak je podana le funkcija `resi`, ki
reši sistem $A x = b$ za dani vektor $b$.

== Inverzna iteracija s QR razcepom

Laplaceova matrika je simetrična, zato so lastni vektorji ortogonalni.
Lastne vektorje lahko poiščemo tako, da iteracijo izvajamo na več
vektorjih hkrati in nato na dobljeni bazi izvedemo ortogonalizacijo s QR
razcepom. Tako dobljeno zaporedje lastnih vektorjev konvergira  k lastnim vektorjem za po absolutni
vrednosti najmanjše lastne vrednosti. Priredimo sedaj funkcijo #jl("inviter"), da za začetni
približek sprejme $k times n$ matriko in izvede inverzno iteracijo s QR razcepom. Napišimo funkcijo
#jl("inviterqr(resi, )")


Laplaceova matrika grafa je simetrična in negativno semi definitna.
Poleg tega je zelo veliko elementov enakih 0. Zato za rešitev sistema
uporabimo iterativno
#link("https://en.wikipedia.org/wiki/Conjugate_gradient_method")[metodo konjugiranih gradientov].
Za uporabo metode konjugiranih gradientov zadošča, da učinkovito
izračunamo množenje matrike z vektorjem. Težava je, ker ima Laplaceova
matrika grafa tudi lastno vrednost $0$, zato metoda konjugiranih gradientov ne
konvergira ,če ju uporabimo direktno za laplaceovo matriko. Težavo lahko rešimo s preprostim
premikom.

== Premik

Inverzna iteracija @eq:9-inviter konvergira k lastnemu vektorju za najmanjšo lastno vrednost. Če
želimo poiskati lastne vektorje za kakšno drugo lastno vrednost, lahko uporabimo preprost premik.
Če ima matrika $A$ lastne vrednosti $lambda_1, lambda_2, dots lambda_n$, potem ima matrika

$A - delta I$

lastne vrednosti $lambda_1 - delta, lambda_2 - delta, dots lambda_n - delta$. Če izberemo
$delta$ dovolj blizu $lambda_k$ lahko poskrbimo, da je $lambda_k -delta$ najmanjša lastna vrednost
matrike $A - delta I$. Tako lahko z inverzno

Namesto, da računamo lastne
vrednosti in vektorje matrike $L$, iščemo lastne vrednosti in vektorje
malce premaknjene matrike $L + epsilon I$, ki ima enake lastne
vektorje, kot $L$.

#opomba()[
Programski jezik julia omogoča polimorfizem v obliki
#link("https://docs.julialang.org/en/v1/manual/methods/index.html")[večlične
dodelitve]. Tako
lahko za isto funkcijo definiramo različne metode. Za razliko od polmorfizma
v objektno orientiranih jezikih, se metoda izbere ne le na podlagi tipa
objekta, ki to metodo kliče, ampak na podlagi tipov vseh vhodnih argumentov.
To lastnost lahko s pridom uporabimo, da lahko pišemo generično kodo, ki
deluje za veliko različnih vhodnih argumentov. Primer je funkcija
#jl("conjgrad"), ki jo lahko uporabimo tako za polne matrike, matrike tipa
`SparseArray` ali pa tipa `LaplaceovaMatrika` za katerega smo posebej
definirali operator množenja #jl("*").
]

$ L bold(x^(lr((k + 1)))) = bold(x^(lr((k)))) $

Primerjajmo inverzno potenčno metodo z vgrajeno metodo za iskanje
lastnih vrednosti s polno matriko

```julia
import Base:*, size
struct PremikMatrike
   premik
   matrika
end
*(p::PremikMatrike, x) = p.matrika*x + p.premik.*x
size(p::PremikMatrike) = size(p.matrika)

Lp = PremikMatrike(0.01, L)
l, v = inverzna_iteracija(Lp, 5, (Lp, x) -> conjgrad(Lp, x)[1])
```

== Algoritem k-povprečij
<algoritem-k-povprečij>


== Literatura
<literatura>
- A tutorial on spectral clustering @von_luxburg_tutorial_2007
- Knjižnica
  #link("http://danspielman.github.io/Laplacians.jl/latest/index.html")[Laplacians.jl]

== Rešitve

#let vaja8(koda) = code_box(jlfb("Vaja08/src/Vaja08.jl", koda))

#figure(
  vaja8("# inviter"),
  caption: [Inverzna iteracija]
  )<pr:9-inviter>

#figure(
  vaja8("# inviterqr"),
  caption: [Inverzna iteracija s QR razcepom]
  )

#figure(
  vaja8("# graf_eps"),
  caption: [Graf podobnosti z $epsilon$ okolicami]
  )

#figure(
  vaja8("# laplace"),
  caption: [Laplaceova matrika grafa]
  )
