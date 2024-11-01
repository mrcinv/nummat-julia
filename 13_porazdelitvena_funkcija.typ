#import "admonitions.typ": opomba
#import "julia.typ": code_box, jl, jlfb

= Porazdelitvena funkcija normalne porazdelitve

== Naloga

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

== Razdelitev definicijskega območja

Pri implementaciji neke funkcije sta pomembni dve stvari. Da je na celem defnicijskem območju
relativna napaka omejena in da je časnovna zahtevnost izračuna omejena s konstanto, ki ni odvisna
od argumenta funkcije. Za funkcijo kot je porazdelitvena funkcija normalne spremenljivke je
oba pogoja zelo težko doseči z enim algoritmom. Zato je definicijsko območje bolje razdeliti na
več delov in na vsakem delu izbrati numerično metodo, ki je najbolj primerna in zadosti
omenjenima pogojema.

#figure(
  image("img/13-obmocja.png", width: 60%),
  caption: [Razdelitev intervala $(-oo, oo)$ na tri dele, na katerih uporabimo različne metode]
)

== Izračun na $[-c, oo)$
Izračunamo $Phi(-c)$ in $Phi(x) = Phi(-c) + integral_(-c)^x e^(-x^2/2)d x$. Integral izračunamo z
Gauss-Legendrovimi kvadraturami s fiksnim številom vozlišč, tako da je absolutna napaka enakomerno
omejena. Na $[b, oo)$ za dovolj velik $b$ je vrednost enaka $1$.

== Izračun na $(-oo, -c]$

Sledili bomo ideji iz @shepherd1981. Izračunali bomo komplementarno funkcijo napake
#let erfc = math.op("erfc")
$
erfc(x) = integral_(x)^(oo) e^(-t^2) d t,
$<eq:13-integral>
za $x in [0, oo)$. Funkcija $Phi(x)$ lahko za negativne vrednosti $x$ izrazimo s funkcijo $erfc$ kot

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
preslikavo $t = 1/x$])

Funkcija $1/(u^2)exp(-1/u^2)$ ni podobna polinomom, saj pri nič zelo hitro konvergira k $0$. Zato
metode visokega reda ne bodo dale dobrih rezultatov in bomo raje uporabili adaptivno kvadraturo.

== Adaptivna metode

== Aproksimacija s polinomi Čebiševa

#link("https://en.wikipedia.org/wiki/Stone%E2%80%93Weierstrass_theorem#Weierstrass_approximation_theorem")[Weierstrassov izrek]
pravi, da lahko poljubno zvezno funkcijo na končnem intervalu enakomerno na vsem intervalu
aproksimiramo s polinomi. Polinom dane stopnje, ki neko funkcijo najbolje aproksimira je težko
poiskati. Z razvojem funkcije po ortogonalnih polinomih Čebiševa, pa se optimalni aproksimaciji
zelo približamo. Naj bo $f:[−1,1]->RR$ zvezna funkcija. Potem lahko $f$ zapišemo z neskončno
Furierovo vrsto

$
f(t)=sum_(n=0)^oo a_n T_n(t),
$<eq:13-vrsta>

kjer so $T_n$ polinomi Čebiševa, $a_n$ pa koeficienti. Koeficienti $a_n$ so dani z integralom

$
a_0 = 1/pi integral_(-1)^(1) f(x)/sqrt(1-x^2) d x\
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
T_0(x) &= 1\
T_1(x) &= x\
T_2(x) &= 2x^2 - 1\
T_3(x) &= 2x(2x^2 - 1) - x = 4x^3 - 3x
$

Namesto cele vrste @eq:13-vrsta, lahko obdržimo le prvih nekaj členov in funkcijo aproksimiramo
s končno vsoto

$
f(x)approx C_N(x) = sum_(n=0)^N a_n T_(n)(x),
$

koeficiente $a_n$ pa bomo poiskali numerično z Gauss-Čebiševimi kvadraturami @dlmf3.

Vozlišča za Gauss-Čebiševa kvadraturo v $n$ vozliščih so v
#link("https://en.wikipedia.org/wiki/Chebyshev_nodes")[Čebiševih vozliščih]

$
  x_k = cos((2k +1)/(2n)pi), quad k=0, med dots med n-1,
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
Na vajah bomo koeficiente an računali približno z Gauss-Čebiševimi kvadraturnimi formulami. V praksi
je mogoče koeficiente $a_n$ izračunati bolj natančno in hitreje ($cal(O)(n log(n))$ namesto
$cal(O)(n^2)$) z diskretno Fourierovo kosinusno transformacijo funkcijskih vrednosti v Čebiševih
interpolacijskih točkah @trefethen19.
]

Če želimo aproksimirati funkcijo $f:[a, b]->RR$, moramo argument preslikati na interval $[-1, 1]$ z
linearno preslikavo. V splošnem sta linearni preslikavi med $x in [a, b]$ in $t in [c, d]$ podani
kot:

$
  t(x) = (d - c)/(b - a)(x - a) + c\
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

Kako vemo, kdaj je členov vrste dovolj, da je dosežena zahtevana natančnost. Izberemo $N$ tako, da
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

== Izračun funkcije $Phi(x)$ na $[c, oo)$
