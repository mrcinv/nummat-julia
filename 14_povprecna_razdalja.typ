#import "julia.typ": code_box, jlfb, jl
#import "admonitions.typ": opomba

= Povprečna razdalja med dvema točkama na kvadratu

== Naloga

- Izpeljite algoritem, ki izračuna integral na več dimenzionalnem kvadru kot
  večkratni integral tako, da za vsako dimenzijo uporabite isto kvadraturno formulo za enkratni integral.
- Pri implementaciji pazite, da ne delate nepotrebnih dodelitev pomnilnika.
- Uporabite algoritem za izračun povprečne razdalje med dvema točkama na enotskem
  kvadratu $[0, 1]^2$ in enotski kocki $[0, 1]^3$.
- Za sestavljeno Simpsonovo formulo in Gauss-Legendrove kvadrature ugotovite, kako napaka
  pada s številom izračunov funkcije, ki jo integriramo. Primerjajte rezultate s preprosto
  Monte-Carlo metodo (računanje vzorčnega povprečja za enostaven slučajni vzorec).

== Kvadrature za večkratni integral

V poglavju o enojnih integralis smo spoznali, da je večina kvadraturnih
formul preprosta utežena vsota

$ integral_a^b f (x) d x approx sum w_k f (x_k), $

kjer so uteži $w_k$ in vozlišča $x_k$ primerno izbrana, da je formula čim bolje zadene pravo
vrednost.

Pri večkratnih integralih se stvari nekoliko zakomplicirajo, a v bistvu
ostanejo enake. Kvadrature so tudi za večkratne integrale večinoma
navadne utežene vsote vrednosti v izbranih točkah na območju.

== Dvojni integral in integral integrala
<dvojni-integral-in-integral-integrala>

Oglejmo si najbolj enostaven primer, ko integriramo funkcijo na kocki
$[a , b]^2$. Dvojni integral lahko zapišemo kot dva gnezdena enojna
integrala #footnote[Več o tem, kdaj je mogoče večkratni integral
zamenjati z gnezdenimi enojnimi integrali pove
#link("https://en.wikipedia.org/wiki/Fubini's_theorem")[Fubinijev izrek];.]

$
integral integral_([a , b]^2) f (x , y) d x d y =
integral_a^b (integral_a^b f (x , y) d y) d x = integral_a^b (integral_a^b f (x , y) d x) d y
$

Najbolj enostavno je izpeljati kvadrature za večkratni integral, če za
vsak od gnezdenih enojnih integralov uporabimo isto kvadraturno formulo

$ integral_a^b f (x) d x approx sum_(k = 1)^n w_k f (x_k) $<eq:14-kvad>

z danimi utežmi $w_1 , w_2 , dots.h w_n$ in vozlišči
$x_1 , x_2 , dots.h x_n$. Če za zunanji integral uporabimo kvadrature
@eq:14-kvad, dobimo:

$
integral integral_([a , b]^2) f (x , y) d x d y = integral_a^b (integral_a^b f (x , y) d y) d x =
sum w_i F y (x_i),
$

kjer je funkcija $F y (x)$ enaka integralu po $y$. Za izračun vrednosti $F_(y)(x_i)$ lahko zopet
uporabimo kvadrature @eq:14-kvad:

$
F y (x_i) = integral_a^b f (x_i , y) d y approx sum w_j f (x_i , y_j)
$

Dvojni integral lahko tako približno izračunamo kot dvojno vsoto

$
integral_a^(b) integral_a^(b) f (x , y) d x d y approx sum_(i , j) w_i w_j f (x_i , y_j) .
$<eq:14-prodkvad2>

Formulo @eq:14-prodkvad2 lahko posplošimo za integrale v več dimenzijah

$
integral_([a, b]^d) f(x_1, x_2 med dots med x_d) d x_1 d x_2 med dots med d x_d approx
sum_(i_1, i_2 med dots med i_d) product_(j=1)^d w_(i_j) f(x_(i_1), x_(i_2) med dots med x_(i_d)),
$<eq:14-prodkvad>
kjer seštevamo po vseh možnih multi indeksih $(i_1, i_2 med dots med i_d) in {1, 2 med dots med n}^d$.
S preprosto linearno preslikavo formulo @eq:14-prodkvad razširimo na poljuben
$d$-dimenzionalen kvader $[a_1, b_1] times [a_2, b_2] med dots med [a_d, b_d]$:

$
integral_(a_1)^(b_1) integral_(a_2)^(b_2)dots integral_(a_n)^(b_n)
  f(x_1, x_2 med dots med x_d) d x_1 d x_2 med dots med d x_d approx\
  product_(i=1)^(d) ((b_i - a_i)/(b - a)) sum_(i_1, i_2 med dots med i_d)
  product_(j=1)^d w_(i_j) f(t_(1 i_1), t_(2  i_2) med dots med t_(d i_d)),
$<eq:14-prodkvadkvad>
kjer je $t_(i j)$ vozlišče $x_j$ preslikano na interval $[a_i, b_i]$.
Kvadraturnim formulam @eq:14-prodkvad2, @eq:14-prodkvad in @eq:14-prodkvadkvad
pravimo #emph[produktne formule].

#opomba(naslov:[Produktne formule trpijo za prekletstvom dimenzionalnosti])[

Število vozlišč, ki jih dobimo, ko uporabimo produktno formulo, narašča eksponentno z
dimenzijo prostora, na katerem integriramo. Zato produktne kvadrature postanejo hitro
(že v dimenzijah nad 6, 7) časovno tako zahtevne, da celo slabše konvergirajo kot metoda
Monte Carlo (@sec:14-monte-carlo).
Pojav imenujemo
#link("https://en.wikipedia.org/wiki/Curse_of_dimensionality")[prekletstvo dimenznionalnosti] in
se pojavi tudi pri drugih problemih, ko dimenzija prostora narašča.

Z dimenzijo narašča delež volumna, ki je „na robu“. Oglejmo si $d-$dimenzionalno
enotsko kocko $[-1,1]^d$. Če interval $[-1,1]$  razdelimo
na točke v notranjosti $[-1/2, 1/2]$ in točke na robu $[-1,1]-[-1/2, 1/2]$, sta v eni dimenziji
oba dela enako dolga. V višjih dimenzijah pa delež točk v kocki, ki so na robu v primerjavi s
točkami v notranjosti narašča. Delež točk v notranjosti lahko preprosto izračunamo:
$
P([-1/2,1/2]^d) = 1/(2^d)
$
in pada eksponentno z dimenzijo $d$. Zato je smiselno na robu uporabiti bolj gosto mrežo kot v
notranjosti. Tako je matematik Sergey A. Smolyak razvil
#link("https://en.wikipedia.org/wiki/Sparse_grid")[razpršene mreže], ki izkoriščajo to idejo in
delno omilijo prekletstvo dimenzionalnosti.
]

Definirajmo naslednje tipe in funkcije:
- podatkovni tip #jl("VeckratniIntegral(fun, box)"), ki opiše večkratni integral na kvadru
  $product [a_i, b_i]$ (@pr:14-veckratni-integral),
- metodo #jl("integriraj(I::VeckrantiIntegral, kvad::Kvadratura)") za funkcijo #jl("integriraj"),
  ki izračuna večkranti integral s kvadraturno formulo @eq:14-prodkvadkvad (@pr:14-preslikaj,
  @pr:14-integriraj, @pr:14-naslednji).

== Metoda Monte Carlo
<sec:14-monte-carlo>

Naj bo $X ~ U([a_1, b_1] times [a_2, b_2] med dots med [a_d, b_d])$ enakomerno porazdeljena slučajna
spremenljivka na $B_d = [a_1, b_1] times [a_2, b_2] med dots med [a_d, b_d]$. Potem je pričakovana
vrednost funkcije $f(X)$ slučajne spremenljivke $X$ enaka:
$
E(f(X)) = 1/V(B_d) integral_(B_d) f(x) d x.
$

Po #link("https://en.wikipedia.org/wiki/Central_limit_theorem")[centralnem limitnem izreku] je
vzorčno povprečje :

$
overline(f(x)) = 1/(n)(f(x_1) + f(x_2) med dots med f(x_n))
$

za enostaven vzorec $x_1, x_2 med dots med x_n$ porazdeljeno približno normalno $N(mu, sigma)$ s
parametri $mu = E(f(X))$ in $sigma= sigma(f(X))/sqrt(n)$. Razpršenost porazdelitve pada s
$sqrt(n)$, zato je vzorčno povprečje za velike vzorce blizu vrednosti:

$
E(f(X)) = 1/V(B_d) integral_(B_d) f(x) d x.
$

Približno vrednost integrala lahko izračunamo kot

$
integral_(B_d) f(x) d x approx overline(f(x)) dot.c V(B_d).
$

Metoda Monte Carlo ne konvergira zelo hitro #footnote[Napaka pada s $sqrt(n)$, kjer je $n$ število
izračunov funkcijske vrednosti.]
ima pa prednost, da ne trpi za
prekletstvom dimenzionalnosti. Zato se jo najpogosteje uporablja za računanje integralov v
višjih dimenzijah.

Definirajmo sedaj naslednji tip in metodo:
- podatkovni tip #jl("MonteCarlo(rng, n)") za parametre metode Monte Carlo in
- novo metodo #jl("integriraj(integral::VeckrantiIntegral, mc::MonteCarlo)") za funkcijo
  #jl("integriraj"), ki dani integral izračuna z metodo Monte Carlo (@pr:14-mc).

== Povprečna razdalja med točkama na kvadratu $[0 , 1]^2$
<povprečna-razdalja-med-točkama-na-kvadratu-012>

Povprečna razdaljo lahko izračunamo s štirikratnem integralom

$ overline(d) = integral_([0 , 1]^4) sqrt((x_1 - x_2)^2 + (y_1 - y_2)^2) d x_1 d x_2 d y_1 d y_2 . $

Za izračun bomo uporabili produktno kvadraturo s sestavljeno Simpsonovo
formulo in metodo Monte Carlo.

#let demo14(koda) = code_box(jlfb("scripts/14_quad4d.jl", koda))
Najprej definiramo funkcijo razdalje:

#demo14("# razdalja")

Nato pa še funkcijo, ki izračuna povprečno razdaljo:

#demo14("# povprecna")

Za izračun uporabimo sestavljeno Simpsonovo formulo:

#demo14("# izracun")
#code_box(raw(read("out/14-dp.out")))

Napako ocenimo tako, da izračun ponovimo z bolj natančno kvadraturno formulo. Na primer tako, da
podvojimo število vozlišč v osnovni kvadrturi:

#demo14("# ocena napake")
#code_box(raw(read("out/14-napaka.out")))

Isti rezultat izračunajmo še z metodo Monte Carlo:

#demo14("# mc izračun")
#code_box(raw(read("out/14-dmc.out")))

Poglejmo si, kako napaka pada, če povečamo število podintervalov v sestavljeni Simpsonovi formuli.

#demo14("# napaka simpson")

Iz rezultatov lahko ocenimo red metode. Zapišemo predoločeni sistem za logaritem napako v odvisnosti
od logaritma števila funkcijskih izračunaov:

$
delta(n) = n^(-r)\
log(delta(n)) = -r log(n)
$
Tako dobimo $k times 1$ predoločen sistem za en parameter $r$:
$
mat(log(n_1); log(n_2); dots.v; log(n_k)) dot.c vec(r) =
 - vec(log(|delta_1|), log(|delta_2|), dots.v, log(|delta_k|)),
$<eq:14-red>
kjer so $delta_i$ izračunane napake za $n_i$ funkcijskih izračunov. Sistem <eq:14-red> rešimo po
metodi najmanjših kvadratov z operatorjem #jl("\\"):

#demo14("# red s")
#code_box(raw(read("out/14-ksim.out")))

Vidimo, da je red malo manj kot $1$. Za vsako novo točno decimalko moramo število
korakov povečati za faktor $10^(1/r)$, kar je malo več kot $10$. Poglejmo si sedaj, kako se odreže
metoda Monte Carlo.

#demo14("# napaka mc")

#figure(image("img/14-napaka.svg", width: 60%), caption: [Napaka Simpsonove produktne kvadrature in
metode Monte Carlo v odvisnosti od števila funkcijskih izračunov])

Vidimo, da je napaka pri metodi Monte Carlo precej bolj nepredvidljiva kot pri produktni Simpsonovi
kvadraturi. To je posledica neprevidljivosti vzorčenja. Kljub temu je trend jasen.
Podobno kot prej lahko ocenimo red metode Monte Carlo. Centralni limitni izrek pove, da bi moral
biti red približno $1/2$.

#demo14("# red mc")
#code_box(raw(read("out/14-kmc.out")))

Izračunan red je nekoliko večji, a to je zgolj posledica variabilnosti, ki ga prinaša s seboj
vzorčenje.

#opomba(naslov: [Kaj smo se naučili?] )[
- Večkratni integral lahko izračunamo s produktnimi kvadraturami.
- Produktne kvadrature trpijo za prekletsvom dimenzionalnosti.
- Metoda Monte Carlo je enostavnoa in ne trpi za prekletstvom dimenzionalnosti, a konverira počasi.
]

#pagebreak()

== Rešitve

#let vaja14(koda, caption) = figure(code_box(jlfb("Vaja14/src/Vaja14.jl", koda)), caption: caption)

#vaja14("# VeckratniIntegral")[Podakovni tip, ki opiše večkratni integral]<pr:14-veckratni-integral>
#vaja14("# preslikaj")[Preslikaj kvadraturo na drug interval]<pr:14-preslikaj>
#vaja14("# integriraj")[Izračunaj večkratni integral s produktno kvadraturo]<pr:14-integriraj>
#vaja14("# naslednji!")[Izračunaj naslednji multiindeks
$(i_1, i_2 med dots med i_d) in {1, 2 med dots med n}^d$ ]<pr:14-naslednji>
#vaja14("# simpson")[Izračunaj vozlišča in uteži za sestavljeno Simpsonovo pravilo]<pr:14-simpson>
#vaja14("# mc")[Izračunaj večkratni integral z metodo Monte Carlo]<pr:14-mc>

== Testi

#let test14(koda, caption) = figure(code_box(jlfb("Vaja14/test/runtests.jl", koda)),
  caption: caption)

#test14("# naslednji")[Test izračuna naslednjega multiindeksa]
#test14("# simpson")[Test izračuna sestavljenega Simpsonovega pravila]
#test14("# preslikaj")[Test preslikave kvadrature na nov interval]
#test14("# integriraj")[Test izračuna integrala s produktno kvadraturo]
