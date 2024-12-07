= Ideje za nove vaje

== Elastične preslikave

Klasifikacija objektov pri kateri je model za mejno ploskev elastična mreža.
Rešitev se poišče z expectation-maximization algoritmom.
- #link("https://en.wikipedia.org/wiki/Elastic_map")[Elastične preslikave] na Wikipedii

== Logistična regresija z nelinearno mejo

Uporabi avtomatsko odvajanje in poišči klasifikator na podlagi logistične
regresije. Poleg linearne meje uporabi kvadratično ali kakšno drugo nelinearno
mejno družino ploskev.
- #link("https://towardsdatascience.com/logistic-regression-as-a-nonlinear-classifier-bdc6746db734")[o nelinearni logistični regresiji].


== Metoda največjega verjetja


Aproksimacija podatkov z
  #link("https://en.wikipedia.org/wiki/Logistic_function")[logistično funkcijo] s
  #link("https://en.wikipedia.org/wiki/Maximum_likelihood_estimation")[cenilko največjega verjetja].

#let LL = $cal(L)$
Avtomatsko računaje gradienta bomo preiskusili pri iskanju cenilke največjega verjetja z gradientno
metodo. Cenilka največjega verjetja je izbira parametrov $phi$ verjetnostnega modela, pri kateri je
verjetje $LL(phi, x)$ največje za dane podatke $x$ in parametre $phi$. Denimo, da imamo
verjetnostni model za slučajno spremenljivko $X$, ki je odvisen od parametrov $phi$. Slučajna
spremenljivka je lahko tudi vektorska. Verjetnost, da $X$ doseže neko vrednost $bold(x)$ je
podana bodisi s funkcijo gostote verjetnosti $p(bold(x), phi)$ za zvezne spremenljivke ali s
funkcijo verjetnosti $p(bold(x), phi) = P(X=bold(X)| phi)$ za diskretne spremenljivke.
Za dano vrednost slučajne spremenljivke $bold(x)$ je funkcija verjetja funkcija odvisna od $phi$
$
phi -> p(bold(x), phi)
$

== Porazdelitvena funkcija normalne porazdelitve

- Implementirajte porazdelitveno funkcijo standardne normalne porazdelitve
  $
    Phi(x) = 1/sqrt(2 pi) integral_(-oo)^x e^(-t^2/2) d t.
  $
- Poskrbite, da je relativna napaka manjša od $0.5 dot 10^{-11}$. Definicijsko območje
  razdelite na več delov in na vsakem delu uporabi primerno metodo, da zagotovite zahtevano
  relativno natančnost.
- Interval $(-oo, -1]$ transformiraj s funkcijo $1/x$ na interval $[-1, 0]$ in uporabi
  aproksimacijo s Čebiševimi polinomi.
  - Namesto funkcije $Phi(x)$ aproksimiraj funkcijo $x e^(x^2) Phi(x)$.
  - Vrednosti funkcije $Phi(x)$ v Čebiševih točkah izračunajte z adaptivno metodo s parom
    Gauss-Legendrovih kvadratur
- Na intervalu $[-1, 0]$ za primerno izbran $a$ uporabite
  #link("https://en.wikipedia.org/wiki/Gauss%E2%80%93Legendre_quadrature")[Gauss-Legendrove kvadrature].
- Na intervalu $[0, oo)$ uporabite lastnost $Phi(x) = 1 - Phi(-x)$.

=== Razdelitev definicijskega območja

Pri implementaciji neke funkcije sta pomembni dve stvari. Da je na celem defnicijskem območju
relativna napaka omejena in da je časovna zahtevnost izračuna omejena s konstanto, ki ni odvisna
od argumenta funkcije. Za funkcijo, kot je porazdelitvena funkcija normalne spremenljivke je
oba pogoja zelo težko doseči z enim algoritmom. Zato je definicijsko območje bolje razdeliti na
več delov in na vsakem delu izbrati numerično metodo, ki je najbolj primerna in zadosti
omenjenima pogojema.

#figure(
  image("img/13-obmocja.png", width: 60%),
  caption: [Razdelitev intervala $(-oo, oo)$ na tri dele, na katerih uporabimo različne metode.]
)

=== Izračun na $[-c, oo)$
Izračunamo $Phi(-c)$ in $Phi(x) = Phi(-c) + integral_(-c)^x e^(-x^2/2)d x$. Integral izračunamo z
Gauss-Legendrovimi kvadraturami s fiksnim številom vozlov, tako da je absolutna napaka enakomerno
omejena. Na $[b, oo)$, za dovolj velik $b$, je vrednost enaka $1$.

=== Izračun na $(-oo, -c]$

Sledili bomo ideji iz @shepherd1981. Izračunali bomo komplementarno funkcijo napake
#let erfc = math.op("erfc")
$
erfc(x) = integral_(x)^(oo) e^(-t^2) d t,
$<eq:13-integral>
za $x in [0, oo)$. Funkcijo $Phi(x)$ lahko za negativne vrednosti $x$ izrazimo s funkcijo $erfc$ kot

$
Phi(x) = 1/sqrt(pi) erfc(-x/sqrt(2)).
$

Vrednosti integrala $erfc(x)$ potrebujemo na intervalu $[c, oo)$. Da se izognemo neskončnim mejam,
integral s transformacijo $t=1/x$ iz intervala $[c, oo)$ prestavimo na
končen interval $[0, 1/c]$. V @shepherd1981 za transformacijo izberejo linearno ulomljeno preslikavo
$t = (x - k)/(x + k)$, kjer $k$ določijo tako,
da je konvergenca dobljene Čebiševe vrste čim hitrejša. Mi si bomo stvari poenostavili in izbrali
preprostejšo transformacijo. Vpeljimo novo spremenljivko
$u = 1/t$ v integral @eq:13-integral. Izračunamo diferencial $d t = -1/u^2 d u$ in integral
$I(t) = erfc(x(t))$ zapišemo kot
$
I(t) =  -integral_t^0 exp(-1/u^2)/u^2 d u = integral_0^t exp(-1/u^2)/u^2 d u.
$

#figure(image("img/13-preslikan-integrand.svg", width:60%), caption: [Integrand
$1/u^2 exp(-1/(2u^2))$, če integral $integral_(x)^(oo) exp(-t^2/2) d t$ preslikamo s
preslikavo $t = 1/x$.])

Funkcija $1/(u^2)exp(-1/u^2)$ ni podobna polinomom, saj pri nič zelo hitro konvergira k $0$. Zato
metode visokega reda ne bodo dale dobrih rezultatov in bomo raje uporabili adaptivno kvadraturo.

== Aproksimacija s polinomi Čebiševa

#link("https://en.wikipedia.org/wiki/Stone%E2%80%93Weierstrass_theorem#Weierstrass_approximation_theorem")[Weierstrassov izrek]
pravi, da lahko poljubno zvezno funkcijo na končnem intervalu enakomerno na vsem intervalu
aproksimiramo s polinomi. Polinom dane stopnje, ki neko funkcijo najbolje aproksimira, je težko
poiskati. Z razvojem funkcije po ortogonalnih polinomih Čebiševa, pa se optimalni aproksimaciji
zelo približamo. Naj bo $f:[−1,1]->RR$ zvezna funkcija. Potem lahko $f$ zapišemo z neskončno
Fourierovo vrsto

$
f(t)=sum_(n=0)^oo a_n T_n(t),
$<eq:13-vrsta>

kjer so $T_n$ polinomi Čebiševa, $a_n$ pa koeficienti. Koeficienti $a_n$ so dani z integralom

$
a_0 = 1/pi integral_(-1)^(1) f(x)/sqrt(1-x^2) d x,\
a_n = 2/pi integral_(-1)^(1) (f(x)T_(n)(x))/sqrt(1-x^2) d x.
$

Polinomi Čebiševa so definirani z relacijo

$
T_(n)(cos(phi)) = cos(n phi)
$

in zadoščajo dvočlenski rekurzivni enačbi

$
T_(n+1)(x)=2x T_(n)(x) - T_(n−1)(x).
$

Prvih nekaj polinomov $T_(n)(x)$ je enakih:

$
T_0(x) &= 1,\
T_1(x) &= x,\
T_2(x) &= 2x^2 - 1,\
T_3(x) &= 2x(2x^2 - 1) - x = 4x^3 - 3x.
$

Namesto cele vrste @eq:13-vrsta, lahko obdržimo le prvih nekaj členov in funkcijo aproksimiramo
s končno vsoto

$
f(x)approx C_N(x) = sum_(n=0)^N a_n T_(n)(x),
$

koeficiente $a_n$ pa bomo poiskali numerično z Gauss-Čebiševimi kvadraturami @dlmf3.

Vozli za Gauss-Čebiševa kvadraturo v $n$ vozlih so v
#link("https://en.wikipedia.org/wiki/Chebyshev_nodes")[Čebiševih vozlih]

$
  x_k = cos((2k +1)/(2n)pi), quad k=0, med dots, med n-1,
$

uteži pa so vse enake $w_k = pi/n$. Za vrsto $C_N(x)$ uporabimo kvadraturne formule z $N+1$ vozlišči.
Za koeficiente tako na intervalu $[-1, 1]$ dobimo približne formule

$
  a_0 = 1/(N+1) sum_(k=0)^(N) f(x_k)\
  a_1 = 2/(N+1) sum_(k=0)^(N) T_1(x_k) f(x_k)\
  a_2 = 2/(N+1) sum_(k=0)^(N) T_2(x_k) f(x_k)\
  dots.v\
  a_N = 2/(N+1) sum_(k=0)^(N) T_(N)(x_k) f(x_k).
$

#opomba(naslov:[Koeficiente Čebiševe vrste natančneje in hitreje računamo s FFT])[
Na vajah bomo koeficiente izračunali približno z Gauss-Čebiševimi kvadraturnimi formulami. V praksi
je mogoče koeficiente $a_n$ izračunati bolj natančno in hitreje ($cal(O)(n log(n))$ namesto
$cal(O)(n^2)$) z diskretno Fourierovo kosinusno transformacijo funkcijskih vrednosti v Čebiševih
interpolacijskih točkah @trefethen19.
]

Če želimo aproksimirati funkcijo $f:[a, b]->RR$, moramo argument preslikati na interval $[-1, 1]$ z
linearno funkcijo. V splošnem sta linearni funkciji med $x in [a, b]$ in $t in [c, d]$ podani
kot:

$
  t(x) = (d - c)/(b - a)(x - a) + c,\
  x(t) = (b - a)/(d - c)(t - c) + b.
$

Namesto $f(x)$ aproksimiramo funkcijo $tilde(f)(t) = f(x(t))$ na intervalu $[-1, 1]$.

Napako aproksimacije lahko ocenimo z velikostjo koeficientov $a_n$. Ker je
$
  |T_n(x)| <= 1, quad x in [-1, 1],
$

je napaka $f(x) - C_N(x)$ omejena s $sum_(n=N+1)^oo |a_n|$

$
  |f(x) - C_N(x)| = |sum_(n=N+1)^oo a_n T_(n)(x)| <= sum_(n=N+1)^oo |a_n|
$

Kako vemo, kdaj je členov vrste dovolj, da je dosežena zahtevana natančnost? Izberemo $N$ tako, da
je nekaj zaporednih čelnov $a_(N+1), a_(N+2), a_(N+3)$ manjših od
Ker neskončne vrste $sum_(n=N+1)^oo |a_n|$ ne moremo sešteti, za približno oceno napake vzamemo kar
zadnji koeficient $a_N$ v končni vsoti $C_N(x)$.

== Čebiševa aproksimacija funkcije $Phi$ za majhne $x$

Za majhne $x$ se vrednost $Phi$ približuje 0

$
 lim_(x->oo) Phi(x) = 0.
$
Zato ni dovolj, da omejimo absolutno napako, ampak moramo poskrbeti, da je tudi relativna napaka
dovolj majhna. Formula

$
  Phi(-x) = 1 - Phi(x)
$

ni uporabna, saj pri odštevanju dveh skoraj enakih vrednosti relativna napaka nekontrolirano
naraste. Zato definicijsko območje razdelimo na dva intervala $(-oo, c]$ in $[c, oo)$. Na intervalu
$[c, oo)$ je vrednost $Phi$ navzdol omejena z $Phi(c)$ in je relativna napaka največ
$1/Phi(c)$ kratnik absolutne napake. Zato je na $[c, oo)$ dovolj, če poskrbimo, da je absolutna
napaka majhna.

Pri aproksimaciji s polinomi Čebiševa imamo kontrolo le nad absolutno napako. Če blizu ničle
funkcije pa majhna absolutna napaka ne pomeni nujno tudi majhne relativne napake.  Težavo lahko
rešimo tako, da funkcijo $Phi(x)$ pomnožimo s faktorjem $k(x)$ tako, da je limita

$
  lim_(x->-oo) k(x)Phi(x) = 1.
$

Namesto funkcije $Phi(x)$ aproksimiramo funkcijo $g(x) = k(x)Phi(x)$, ki je navzdol omejena
z neničelno vrednostjo na $(-oo, c]$. Za funkcijo $g(x)$ lahko poskrbimo, da je absolutna
napaka enakomerno omejena na $(-oo, c]$. Vrednost funkcije $Phi(x)$ nato izračunamo tako, da
izračunamo kvocient

$
Phi(x) = g(x)/k(x),
$

kar pa ne povzroči bistvenega povečanja relativne napake, saj je deljenje za razliko od odštevanja
ne povzroči #link("https://en.wikipedia.org/wiki/Catastrophic_cancellation")[katastrofalnega
krajšanja].

Če je $c<0$, lahko za dodatni faktor izberemo $k(x)$ $Phi(x)$
Izračun vrednosti za majhne vrednosti $x$ lahko izračunamo z  Gauss-Laguerreovimi kvadraturami @dlmf3

$
integral_0^oo f(x) e^(-1) d x approx sum_(k=1)^N w_k f(x_k)m,
$<eq:10-gauss-laguerre>

kjer so $x_k$ ničle Laguerrovega polinoma stopnje $N-1$, $w_i$ pa primerno izbrane uteži. Vrednost

$Phi(x)$ za majhne vrednosti $x$
$
Phi(x) = integral_(-oo)^x e^(-t^2/2) d t
$

lahko z uvedbo nove spremenljivke $u = x - t$, ki preslika interval $(-oo, x)$ v interval $(0, oo)$,
prevedemo na integral

$
integral_(-oo)^x e^(-t^2/2) d t = integral_0^oo e^(-(u-x)^2/2) d u =
integral_0^oo e^(-(u-x)^2/2 + u) e^(-u) d u
$

in uporabimo Gauss-Laguerove kvadrature @eq:10-gauss-laguerre za funkcijo
$f(u) = e^(-(u-x)^2/2 + u)$.

= Domače naloge

== Gradientni spust z iskanjem po premici

== Preslikava na drug interval

Določeni integral

$
  integral_(a)^(b) f(x) d x
$<eq:13-int-a-b>

lahko s preprosto linearno funkcijo premaknemo na drug interval $[c, d]$. V integral @eq:13-int-a-b
vpeljemo novo spremenljivko $t = t(x) = k x + n$, ki preslika interval $[a, b]$ na interval $[c, d]$.
Formulo za $t$ določimo tako, da najprej preslikamo $[a, b]$ s preslikavo $s = (x - a)/(b-a)$ na
$[0, 1]$ in nato $s$ preslikamo $t = (d - c)s + c$ z intervala $[0, 1]$ na interval $[c, d]$.
Inverzno preslikavo $x = x(t)$ izračunamo enako:

$
  t(x) = (d - c)/(b - a)(x - a) + c quad #text[ in ] quad
  x(t) = (b - a)/(d - c)(t - c) + a.
$

Integral @eq:13-int-a-b lahko sedaj preslikamo na $[c, d]$:

$
  integral_(a)^(b) f(x) d x = integral_(t(a))^(t(b)) f(x(t)) x'(t) d t =
  (b-a)/(d-c) integral_c^d f((b -a)/(d-c)(t -c) + a) d t.
$<eq:13-int-ab-cd>

Pri izpeljavi @eq:13-int-ab-cd smo upoštevali, da je $d x = x'(t) d t = (b -a)/(d -c) d t$.
Če imamo kvadraturno formulo za interval $[c, d]$:

$
  integral_c^d f(t) d t approx sum_(i=1)^n u_i f(t_i),
$

lahko s preslikavo @eq:13-int-ab-cd zapišemo kvadraturno formulo za poljuben interval $[a, b]$:

$
  integral_a^b f(x) d x = (b - a)/(d - c)integral_c^d f(x(t)) d t approx
  (b - a)/(d - c) sum_(i=1)^n u_i f(x_i),
$

kjer so novi vozli $x_i$ enaka:

$
  x_i = (b - a)/(d - c)(t_i - c) + a.
$

== Adaptivne metode

#opomba(naslov:[Ponovna uporaba že izračunanih funkcijskih vrdnosti])[
V naši implementaciji adaptivne metode smo vrednosti funkcije v nekatirh vozlih večkrat
izračunali. Hitrost smo žrtvovali v prid enostavnosti in preglednosti. V praksi se adaptivne
metode implementira na način, da se funkcijske vrednosti v vsakem vozlu izračuna samo enkrat
in se nato te vrednosti uporabi v nadalnjih izračunih.

To dobro deluje za kvadrature kot so Simpsonova in trapezna formula, ki spadajo med
#link("https://en.wikipedia.org/wiki/Newton%E2%80%93Cotes_formulas")[Newton-Cotesove] kvadrature.
Za Gaussove kvadrature je več težav, saj se vozli kvadratur višjega reda ne prekrivajo z vozli
kvadratur nižjega reda. Rešitev ponujajo
#link("https://en.wikipedia.org/wiki/Gauss%E2%80%93Kronrod_quadrature_formula")[Gauss-Kronrodove kvadrature],
ki so podane kot pari kvadratur, pri katerem kvadratura višjega reda vsebuje vse vozle
kvadrature nižjega reda. Kvadratura nižjega reda je Gauss-Legendrova kvadratura z $n$ vozli.
Nato se izbere dodatnih $n+1$ vozlov in na novo določi uteži, tako da je druga kvadratura čim
višjega reda.
]

== Tabela podatkov z mersko napako

Predpostavimo, da je merska napaka $epsilon$ slučajna spremenljivka, ki je porazdeljena normalno
$epsilon ~ N(0, sigma)$. V tem primeru metode visokega reda nič ne koristijo. Višji red metode bo
zgolj bolje ocenil prispevek napake $epsilon$, ki pa je še vedno neznana. Zato v tem primeru
povsem zadoščajo metode nizkega reda, kot je trapezna metoda. Poglejmo si primer.

#demo13("# funkcija s šumom")
#demo13("# podatki s šumom")

#figure(caption: [Podatki s šumom], image("img/13-podatki-sum.svg", width: 60%))

Poglejmo kako se obnaša napaka pri računanju integrala z različnimi kvadraturami.

#demo13("# simulacija")

#figure(caption: [Primerjava napak za različne metode pri dveh različnih poskusih.
  Napaka numerične metode je zanemarljiva v primerjavi z napako, ki jo povzroči šum.],
  kind: image,
  table(columns: 2, stroke: none,
    image("img/13-napaka-sum-1.svg"),
    image("img/13-napaka-sum-2.svg"),
  )
)

== Surface reconstruction

https://en.wikipedia.org/wiki/Poisson%27s_equation#Surface_reconstruction

== Stretch grid approximation
https://en.wikipedia.org/wiki/Stretched_grid_method

== Perioda geostacionarne orbite

Oblika planeta Zemlja ni čisto pravilna krogla. Zato tudi gravitacijsko polje ne deluje v vseh
smereh enako. Gravitacijsko polje lahko zapišemo kot odvod gravitacijskega
potenciala

$
  bold(F)_(g)(bold(r)) = m dot gradient V(bold(r)),
$

kjer je $V(bold(r))$ skalarna funkcija položaja $bold(r)$.
#link("https://en.wikipedia.org/wiki/Gravity_of_Earth")[Zemljina gravitacija]
#link("https://en.wikipedia.org/wiki/Geopotential_model")[Zemljin gravitacijski potencial].
