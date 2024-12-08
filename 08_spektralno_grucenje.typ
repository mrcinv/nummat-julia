#import "admonitions.typ": opomba, naloga
#import "Julia.typ": jl, jlfb, code_box, repl
= Spektralno razvrščanje v gruče
<spektralno-razvrščanje-v-gruče>

#link("https://en.wikipedia.org/wiki/Cluster_analysis")[Razvrščanje v gruče ali gručenje] je
postopek, pri katerem množico objektov razdelimo v nekaj skupin ali gruč, v katerih
so objekti, ki so si v nekem smisli podobni.
Ogledali si bomo metodo, ki s
#link("https://sl.wikipedia.org/wiki/Spektralna_teorija_grafov")[spektralno analizo
Laplaceove matrike] podobnostnega grafa podatke
preslika v prostor, v katerem jih nato preprosteje razvrstimo z algoritmi gručenja.
Sledili bomo postopku, imenovanemu
#link("https://en.wikipedia.org/wiki/Spectral_clustering")[spektralno gručenje], kot je
opisan v @Von_Luxburg_tutorial_2007.

== Naloga


- Napiši funkcijo, ki zgradi podobnostni graf za podatke, podane kot oblak točk v
  $RR^d$. V podobnostnem grafu je vsaka točka v oblaku vozlišče, povezani pa so vsi pari
  točk $i$ in $j$, ki so oddaljeni za manj kot $epsilon$ za primerno izbrani $epsilon$.
- Napiši funkcijo, ki za dano simetrično matriko poišče $k$ po absolutni vrednosti najmanjših
  lastnih vrednosti in pripadajoče lastne vektorje.
  Uporabi inverzno iteracijo za $k$ vektorjev in na vsakem koraku s QR razcepom poskrbi, da so
  paroma ortogonalni. Faktor $Q$ v QR razcepu konvergira k lastnim vektorjem,
  diagonala faktorja $R$ pa h $k$ po absolutni vrednosti najmanjšim lastnim vrednostim matrike.
- Funkcijo za iskanje lastnih vektorjev uporabi na Laplaceovi matriki podobnostnega grafa podatkov.
  Za primer podatkov naključno generiraj mešanico treh različnih Gaussovih porazdelitev.
  Komponente lastnih vektorjev uporabi kot nove koordinate in podatke predstavi v novih koordinatah.

== Podobnostni graf in Laplaceova matrika
<podobnostni-graf-in-laplaceova-matrika>

Podatke (množico točk v $RR^d$) želimo razvrstiti v več gruč.
Osnova za spektralno gručenje je #emph[podobnostni uteženi graf], ki povezuje točke, ki
so si v nekem smislu blizu. Podobnostni graf lahko ustvarimo na več
načinov:

- #strong[$epsilon$ okolice]: s točko $x_k$ povežemo vse točke, ki ležijo v
  $epsilon$ okolici te točke,
- #strong[$k$ najbližji sosedi]: $x_k$ povežemo z $x_i$, če je
  $x_i$ med $k$ najbližjimi točkami. Tako dobimo usmerjen graf,
  zato navadno upoštevamo povezavo v obe smeri.
- #strong[poln utežen graf]: povežemo vse točke, vendar povezave utežimo
  glede na razdaljo. Pogosto uporabljena utež je nam znana
  #link("https://en.wikipedia.org/wiki/Radial_basis_function")[radialna bazna funkcija]:

  $ w(x_i , x_k) = exp (-(norm(x_i - x_k)^2)/(2 sigma^2)), $

  pri kateri s parametrom $sigma$ določamo velikost okolic.

Uteženemu grafu podobnosti z matriko uteži:

$ W = [w_(i j)] $

priredimo #link("https://sl.wikipedia.org/wiki/Laplaceova_matrika")[Laplaceovo matriko]:

$ L = D - W, $

kjer je $D = [d_(i j)]$ diagonalna matrika z elementi
$d_(i i) = sum_(j eq.not i) w_(i j)$. Če graf ni utežen, namesto matrike uteži uporabimo
#link("https://sl.wikipedia.org/wiki/Matrika_sosednosti")[matriko sosednosti]. Laplaceova matrika
$L$ je simetrična, nenegativno definitna in ima vedno eno lastno vrednost enako $0$ za lastni
vektor iz samih enic. Laplaceova matrika je pomembna v
#link("https://sl.wikipedia.org/wiki/Spektralna_teorija_grafov")[spektralni teoriji grafov], ki
preučuje lastnosti grafov s pomočjo analize lastnih vrednosti in vektorjev matrik.
Knjižnica #link("http://danspielman.github.io/Laplacians.jl/latest/index.html")[Laplacians.jl] je
namenjena spektralni teoriji grafov.

== Algoritem
<algoritem>
Velja izrek, da ima Laplaceova matrika natanko toliko lastnih
vektorjev za lastno vrednost $0$, kot ima graf komponent za povezanost. Na
prvi pogled se zdi, da bi lahko bile gruče kar komponente grafa, a se
izkaže, da to ni najbolje. Namesto tega bomo gruče poiskali s standardnimi metodami gručenja
v drugem koordinatnem sistemu, ki ga določajo lastni podprostori Laplaceove matrike podobnostnega
grafa. Postopek je naslednji:

- Poiščemo $k$ najmanjših lastnih vrednosti za Laplaceovo matriko
  in izračunamo njihove lastne vektorje.
- Označimo matriko lastnih vektorjev $Q=[v_1, v_2, dots,v_k]$. Stolpci
  $Q^T$ ustrezajo koordinatam točk v novem prostoru.
- Za stolpce matrike $Q^T$ izvedemo izbran algoritem gručenja
  (npr. algoritem #link("https://en.wikipedia.org/wiki/K-means_clustering")[$k$-povprečij]).

V tej vaji bomo zadnji korak izpustili. Grafično si bomo ogledali, kako
je videti oblak točk v novem koordinatnem sistemu, določenem z matriko $Q$.

== Primer
<primer>
Algoritem preverimo na mešanici treh Gaussovih porazdelitev.

#let demo8(koda) = code_box(jlfb("scripts/08_cluster.jl", koda))

#demo8("# gauss mix")

#figure(
  image("img/08_oblak.svg", width: 60%),
  caption: [
    Mešanica treh različnih Gaussovih porazdelitev v ravnini
  ]
)

#naloga[
  Napiši naslednji funkciji:
  - #jl("graf_eps(tocke, r)"), ki za dane točke določi matriko sosednosti za podobnostni graf z $epsilon$ okolicami (rešitev je @pr:9-graf_eps) in
  - #jl("laplace(A)"), ki za dano matriko sosednosti izračuna Laplaceovo
    matriko grafa (rešitev je @pr:9-laplace).
]

Izračunamo graf sosednosti z metodo $epsilon$ okolic in poiščemo
Laplaceovo matriko dobljenega grafa.

#demo8("# laplace")

#figure(
  image("img/08_laplaceova_matrika.svg", width: 60%),
  caption: [
    Neničelni elementi Laplaceove matrike
  ]
)

Izračunamo lastne vrednosti Laplaceove matrike dobljenega
grafa:

#demo8("# eigen")

#figure(
  image("img/08_lastne_vrednosti.svg", width: 60%),
  caption: [
    Lastne vrednosti Laplaceove matrike
  ]
)

Vidimo, da sta peta in šesta lastna vrednost najmanjši vrednosti,
ki sta različni od 0. Komponente lastnih vektorjev za peto in šesto lastno
vrednost uporabimo za nove koordinate.

#demo8("# vlozitev")

#figure(
  image("img/08_vlozitev.svg", width: 60%),
  caption: [
    Vložitev točk v nov prostor, določen z lastnima vektorjema Laplaceove matrike. Slika ilustrira,
    kako lahko s preslikavo v drug prostor gruče postanejo bolj očitne.
  ]
)

Seveda se pri samem algoritmu gručenja ni treba omejiti le na dva lastna
vektorja in iskati, katere kombinacije komponent najbolj ločijo gruče. Preprosto
izberemo lastne vektorje za $k$ najmanjših neničelnih lastnih
vrednosti in algoritem gručenja avtomatsko bolj upošteva dimenzije, v katerih so gruče
najbolj razčlenjene.


== Inverzna iteracija
<inverzna-potenčna-metoda>
Ker nas zanima le nekaj najmanjših lastnih vrednosti, lahko za njihov izračun uporabimo
#link("https://en.wikipedia.org/wiki/Inverse_iteration")[inverzno iteracijo].
Pri tej metodi zgradimo zaporedje približkov z rekurzivno
formulo:

$ bold(x)^((k + 1)) = (A^(- 1) bold(x)^((k)))/norm(A^(- 1) bold(x)^((k))), quad k=0, 1, dots $<eq:9-inviter>

Zaporedje približkov $bold(x^((k)))$ konvergira k lastnemu vektorju za najmanjšo
lastno vrednost matrike $A$ za skoraj vse izbire začetnega približka $bold(x)^((0))$.

#opomba(naslov:
[Namesto inverza uporabite LU razcep ali drugo metodo za reševanje sistema linearnih enačb])[
V inverzni iteraciji moramo večkrat zaporedoma izračunati vrednost:
$ A^(-1) bold(x^((k))). $

Za izračun te vrednosti v resnici ne potrebujemo inverzne matrike $A^(-1)$.
Računanje inverzne matrike je namreč časovno zelo zahtevna operacija, zato se ji, razen v nizkih
dimenzijah, če je le mogoče, izognemo. Produkt $bold(x) = A^(-1)bold(b)$ je rešitev
sistema linearnih enačb $A bold(x) = bold(b)$ in metode za reševanje sistema so učinkovitejše od računanja
inverza $A^(-1)$ in množenja z vektorjem $bold(x)$.

Inverz $A^(-1)$ matrike $A$ lahko nadomestimo tudi z razcepom matrike $A$.
Če na primer uporabimo LU razcep $A=L U$, lahko $A^(-1) bold(b)$ izračunamo tako, da rešimo
 sistem $A bold(x) = bold(b)$ oziroma $L U bold(x) = bold(b)$ v dveh korakih:

 $
 L bold(y)& = bold(b) quad #text[ in]\
 U bold(x)& = bold(y),
 $

 ki sta časovno toliko zahtevna, kot je množenje z matriko $A^(-1)$.
 Programski jezik `julia` ima za ta namen posebno metodo
 #link("https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#LinearAlgebra.factorize")[factorize],
 ki za različne vrste matrik izračuna najprimernejši razcep. Rezultat metode `factorize` je
 vrednost posebnega tipa, za katero lahko uporabimo operator `\`, da učinkovito izračunamo rešitev sistema:

 #code_box[
 #repl("F = factorize(A)", none)
 #repl("x = F\\b # ekvivalentno A\\b, a učinkovitejše", none)
 ]
]

#naloga[
Napiši funkcijo #jl("inviter(resi, x0)"), ki poišče lastni par za najmanjšo lastno vrednost matrike
(rešitev je @pr:9-inviter). Matrika ni podana eksplicitno, ampak je podana le funkcija `resi`, ki
reši sistem $A bold(x) = bold(b)$ za dani vektor $bold(b)$.
]
== Inverzna iteracija s QR razcepom

Laplaceova matrika je simetrična, zato so lastni vektorji ortogonalni.
Lastne vektorje lahko poiščemo tako, da iteracijo izvajamo na več
vektorjih hkrati in nato na dobljeni bazi izvedemo ortogonalizacijo s QR
razcepom. Tako dobljeno zaporedje lastnih vektorjev konvergira  k lastnim vektorjem za po absolutni
vrednosti najmanjše lastne vrednosti. Priredimo sedaj funkcijo #jl("inviter"), da za začetni
približek sprejme $k times n$ matriko in izvede inverzno iteracijo s QR razcepom.
#naloga[
Napiši funkcijo
#jl("inviterqr(resi, X0)"), ki poišče lastne vektorje za prvih nekaj najmanjših lastnih vrednosti
(rešitev je @pr:9-inviterqr).
Število lastnih vektorjev, ki jih metoda poišče, naj bo določeno z dimenzijami začetnega
približka `X0`.
]

Laplaceova matrika grafa je pogosto redka, zato se splača uporabiti eno izmed iterativnih metod.
Poleg tega je Laplaceova matrika simetrična in pozitivno semidefinitna,
zato za rešitev sistema uporabimo
#link("https://en.wikipedia.org/wiki/Conjugate_gradient_method")[metodo konjugiranih gradientov].
Težava je, ker ima Laplaceova matrika grafa tudi lastno vrednost $0$, zato metoda konjugiranih
gradientov ne konvergira, če jo uporabimo na njej. To lahko rešimo s preprostim
premikom Laplaceove matrike za $epsilon I$.

== Premik

Inverzna iteracija @eq:9-inviter konvergira k lastnemu vektorju za najmanjšo lastno vrednost.
Lastne vektorje za druge lastne vrednosti poiščemo s premikom.
Če ima matrika $A$ lastne vrednosti $lambda_1, lambda_2, med dots, med lambda_n$, potem ima matrika:

$ A - delta I $

lastne vrednosti $lambda_1 - delta, lambda_2 - delta, med dots, med lambda_n - delta$. Če izberemo
$delta$ dovolj blizu $lambda_k$, lahko poskrbimo, da je $lambda_k - delta$ najmanjša lastna vrednost
matrike $A - delta I$. Tako z inverzno iteracijo za matriko $A - delta I$ poiščemo lastni vektor za poljubno lastno
vrednost.

Podobno premaknemo Laplaceovo matriko, da postane strogo pozitivno definitna. Potem
lahko za reševanje sistema uporabimo metodo konjugiranih gradientov. Namesto lastnih
vrednosti in vektorjev matrike $L$, iščemo lastne vrednosti in vektorje malce premaknjene matrike
$L + epsilon I$ z enakimi lastnimi vektorji kot $L$.

#demo8("# inviter")

#code_box(
raw(read("out/08_inviterqr.out").split("\n").slice(-5).join("\n"))
)

Vidimo, da metoda konjugiranih gradientov za naš primer zelo hitro konvergira. Z inverzno iteracijo
s QR razcepom smo učinkovito poiskali lastne vektorje Laplaceove matrike za najmanjše lastne
vrednosti. Ti lastni vektorji pa izboljšajo proces gručenja.

#opomba(naslov: [Velike količine podatkov zahtevajo učinkovite algoritme])[
V našem primeru je bila količina podatkov majhna. Vendar bi z inverzno
iteracijo s QR razcepom in metodo konjugiranih gradientov lahko obdelali tudi bistveno
večje količine podatkov, pri katerih bi splošne metode, kot
na primer QR iteracija za iskanje lastnih parov ali LU razcep za reševanje
sistema, odpovedale.

Z naraščanjem količine podatkov je nujno
izbrati učinkovite metode. V praksi se količine podatkov merijo v milijonih in
milijardah. Metode s kvadratno ali višjo časovno ali prostorsko zahtevnostjo so
pri tako velikih količinah podatkov neuporabne. V tem primeru
je mogoče izvesti spektralno gručenje le, če
uporabimo učinkovite metode, kot sta #emph[inverzna iteracija s
QR razcepom]
in #emph[metoda konjugiranih gradientov].
]

#pagebreak()
== Rešitve

#let vaja8(koda) = code_box(jlfb("Vaja08/src/Vaja08.jl", koda))

#figure(
  vaja8("# inviter"),
  caption: [Funkcija, ki z inverzno iteracijo poišče lastni par za po absolutni vrednosti
    najmanjšo lastno vrednost matrike.]
  )<pr:9-inviter>

#figure(
  vaja8("# inviterqr"),
  caption: [Funkcija, ki z inverzno iteracijo in QR razcepom poišče $k$ lastnih parov za
    $k$ po absolutni vrednosti najmanjših lastnih vrednosti matrike.]
  )<pr:9-inviterqr>

#figure(
  vaja8("# graf_eps"),
  caption: [Funkcija, ki ustvari matriko sosednosti za graf podobnosti z $epsilon$ okolicami za dane podatke.]
  )<pr:9-graf_eps>

#figure(
  vaja8("# laplace"),
  caption: [Funkcija, ki izračuna Laplaceovo matriko grafa.]
  )<pr:9-laplace>

== Testi

#let test8(koda, caption) = figure(
  caption: caption, code_box(jlfb("Vaja08/test/runtests.jl", koda)))

#test8("# inviter")[Test za inverzno iteracijo]

#test8("# inviterqr")[Test za inverzno iteracijo s QR razcepom]

#test8("# graf eps")[Test za matriko sosednosti z $epsilon$ okolicami]
