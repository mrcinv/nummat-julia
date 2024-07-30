#import "admonitions.typ": opomba
#import "julia.typ": code_box, jl, jlfb

= Porazdelitvena funkcija normalne porazdelitve

== Naloga

- Implementiraj porazdelitveno funkcijo standardne normalne porazdelitve
  $
    Phi(x) = 1/sqrt(2 pi) integral_(-oo)^x e^(-t^2/2) d t.
  $
- Poskrbi, da je relativna napaka manjša od $0.5 dot 10^{-11}$. Definicijsko območje      
  razdeli na več delov in na vsakem delu uporabi primerno metodo, da zagotoviš relativno 
  natančnost.
- Interval $(-oo, -1]$ transformiraj s funkcijo $1/x$ na interval $[-1, 0]$ in uporabi 
  interpolacijo s polinomom na Čebiševih točkah.
- Na intervalu $[-1, a]$ za primerno izbran $a$ uporabi #link("https://en.wikipedia.org/wiki/Gauss%E2%80%93Legendre_quadrature")[Gauss-Legendrove kvadrature].
- Izberi $a$, da je na intervalu $[a, oo)$ vrednost na 10 decimalk enaka $1$.

== Aproksimacija s polinomi Čebiševa

#link("https://en.wikipedia.org/wiki/Stone%E2%80%93Weierstrass_theorem#Weierstrass_approximation_theorem")[Weierstrassov izrek] pravi, da lahko poljubno zvezno funkcijo na končnem intervalu enakomerno na vsem intervalu aproksimiramo s polinomi. Polinom dane stopnje, ki neko funkcijo najbolje aproksimira je težko poiskati. Z razvojem funkcije po ortogonalnih polinomih Čebiševa, pa se optimalni aproksimaciji zelo približamo. Naj bo $f:[−1,1]->RR$ zvezna funkcija. Potem lahko $f$ zapišemo z neskončno Furierovo vrsto

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

Namesto cele vrste @eq:13-vrsta, lahko obdržimo le prvih nekaj členov in funkcijo aproksimiramo s končno vsoto 

$
f(x)approx C_N(x) = sum_(n=0)^N a_n T_(n)(x),
$

koeficiente $a_n$ pa poiščemo numerično z Gauss-Čebiševimi kvadraturami @dlmf3.

Vozlišča za Gauss-Čebiševa kvadraturo v $n$ vozliščih so v
#link("https://en.wikipedia.org/wiki/Chebyshev_nodes")[Čebiševih vozliščih]

$
  x_k = cos((2k +1)/(2n)pi), quad k=0, med dots med n-1,
$

uteži pa so vse enake $w_k = pi/n$. Za vrsto $C_N(x)$ uporabimo kvadraturne formule z $N+1$ vozlišči. Za koeficiente tako na intervalu $[-1, 1]$ dobimo približne formule

$
  a_0 = 1/(N+1) sum_(k=0)^(N) f(x_k)\
  a_1 = 2/(N+1) sum_(k=0)^(N) T_1(x_k) f(x_k)\
  a_2 = 2/(N+1) sum_(k=0)^(N) T_2(x_k) f(x_k)\
  dots.v\
  a_N = 2/(N+1) sum_(k=0)^(N) T_N(x_k) f(x_k).
$

#opomba(naslov:[Koeficiente Čebiševe vrste natančneje in hitreje računamo s FFT])[
Na vajah bomo koeficiente an računali približno z Gauss-Čebiševimi kvadraturnimi formulami. V praksi je mogoče koeficiente $a_n$ izračunati bolj natančno in hitreje ($cal(O)(n log(n))$ namesto $cal(O)(n^2)$) z diskretno Fourierovo kosinusno transformacijo funkcijskih vrednosti v Čebiševih interpolacijskih točkah @trefethen19. 
]

Če želimo aproksimirati funkcijo $f:[a, b]->RR$, moramo argument preslikati na interval $[-1, 1]$ z linearno preslikavo. V splošnem sta linearni preslikavi med $x in [a, b]$ in $t in [c, d]$ podani kot: 

$
  t(x) = (d - c)/(b - a) * (x - a) + c\
  x(t) = (b - a)/(d - c)*(t - c) + b.
$

Namesto $f(x)$ aproksimiramo funkcijo $tilde(f)(t) = f(x(t))$ na intervalu $[-1, 1]$. 

Napako aproksimacije lahko ocenimo z velikostjo koeficientov $a_n$. Ker je 
$
  |T_n(x)| <= 1, quad x in [-1, 1], 
$

je napaka $f(X) - C_N(x)$ omejena s $sum_(n=N+1)^oo |a_n|$

$
  |f(X) - C_N(x)| = |sum_(n=N+1)^oo a_n T_(n)(x)| <= sum_(n=N+1)^oo |a_n|
$

Ker neskončne vrste $sum_(n=N+1)^oo |a_n|$ ne moremo sešteti, za približno oceno napake vzamemo
kar zadnji koeficient $a_N$ v končni vsoti $C_N(x)$. 