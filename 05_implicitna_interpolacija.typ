#import "julia.typ": jlfb, code_box, jl

= Interpolacija z implicitnimi funkcijami
<interpolacija-z-implicitnimi-funkcijami>

Krivulje v ravnini in ploskve v prostoru lahko opišemo na različne načine

#figure(
  table(
    columns: 3,
    stroke: none,
    align: left,
    [], [krivulje v $R^2$], [ploskve v $RR^3$],
    [eksplicitno], $y = f(x)$, $z = f(x, y)$,
    [parametrično], $(x , y) = (x(t) , y(t))$, $(x , y, z) = (x(u, v) , y(u, v), z(u, v))$,
    [implicitno], $F(x , y) = 0$, $F(x, y, z) = 0$
  ),
  caption: [Različni načini predstavitve krivulj v $RR^2$ in ploskev v $RR^3$.]
)


Implicitne enačbe oblike $F(x_1, x_2, dots) = 0$ so zelo dober način za opis krivulj in ploskev. 
Hitri algoritmi za izračun nivojskih krivulj in ploskev kot sta 
#link("https://en.wikipedia.org/wiki/Marching_cubes")[korakajoče kocke] in 
#link("https://en.wikipedia.org/wiki/Marching_squares")[korakajoči kvadrati] omogočajo učinkovito
predstavitev implicitno podanih ploskev in krivulj s poligonsko mrežo. Predstavitev 
s #link("https://en.wikipedia.org/wiki/Signed_distance_function")[predznačeno funkcijo razdalje] pa
je osnova za mnoge grafične programe, ki delajo s ploskvami v 3d prostoru.

V tej vaji bomo spoznali, kako poiskati implicitno krivuljo ali ploskev, ki dobro opiše dani oblak
točk v ravnini ali prostoru. Funkcijo $F$ v implicitni enačbi $F(x, y) = 0$ bomo 
poiskali kot linearno kombinacijo 
#link("https://en.wikipedia.org/wiki/Radial_basis_function")[radialnih baznih funkcij (RBF)] 
(@savchenko95, @turk99). 

== Naloga
#let bx = math.bold[x]

- Definiraj podatkovni tip za linearno kombinacijo radialnih baznih funkcij (RBF). 
  Podatkovni tip naj vsebuje središča RBF $bold(x)_i$, funkcijo ene oblike $phi$ in 
  koeficiente $w_i$ v linearni kombinaciji
  $ 
    F(bx) = sum_(i=1)^n w_i phi(norm(bx - bx_i)). 
  $<eq:05-rbf>

- Napiši sistem za koeficiente v linearni kombinaciji RBF, če so podane
  vrednosti $f_i=F(bx_i)$ v središčih RBF. Napiši funkcijo, ki za dane vrednosti $f_i$, 
  funkcijo $phi$ in središča $bx_i$ poišče koeficiente $w_1, w_2 dots w_n$. Katero metodo za
  reševanja sistema lahko uporabimo?
- Napiši funkcijo `vrednost`, ki izračuna vrednost funkcije $F$ v dani točki. 
- Uporabi napisane metode in interpoliraj oblak točk v ravnini z implicitno podano krivuljo. Oblak 
  točk ustvari na krivulji podani s parametrično enačbo:

  $
    x(phi) = 8cos(phi) - cos(4phi)\
    y(phi) = 8sin(phi) - sin(4phi).
  $<eq:05-cikloida> 

== Interpolacija z radialnimi baznimi funkcijami

V ravnini#footnote[Postopek, ki ga bomo opisali,
deluje ravno tako dobro tudi za točke v prostoru. Vendar se bomo zavoljo enostavnosti omejili na 
točke v ravnini] je podan oblak točk ${ bx_1 , dots.h bx_n } subset RR^2$. Iščemo krivuljo, ki dobro
opiše dane točke. Če zahtevamo, da vse točke ležijo krivulji, problemu rečemo #emph[interpolacija],
če pa dovolimo, da je krivulja zgolj blizu danih točk in ne nujno vsebuje vseh točk, problem
imenujemo #emph[aproksimacija]. Krivuljo bomo poiskali v implicitni obliki kot nivojsko krivuljo
funkcije 2 spremenljivk. Za izbrano vrednost $c$ iščemo funkcijo $f(x, y)$, za katero velja

$
f(x_i, y_i) = c
$

za vse točke v danem oblaku točk. Problem bomo rešili malce bolj splošno. Denimo, da imamo za vsako 
dano točko v oblaku, podano tudi vrednost funkcije ${ f_1 , dots.h , f_n }$. Iščemo zvezno funkcijo 
$f(x, y)$, tako da so izpolnjene enačbe:

$
f(x_1, y_1) = f_1\
dots.v\
f(x_n, y_n) = f_n.
$<eq:05enacbe>

Zveznih funkcij, ki zadoščajo enačbam @eq:05enacbe, je neskončno. Zato se moramo omejiti na 
podmnožico funkcij, ki je dovolj raznolika da je sistem rešljiv, hkrati pa dovolj majhna, da je 
rešitev ena sama. V tej vaji, se bomo omejili na $n$ parametrično družino funkcij oblike
#let bw = math.bold[w]
$
F(bx, bw) = F(bx, w_1, w_2, dots, w_n) = sum_i w_i phi(norm( bx - bx_i)).
$
Funkcije $phi_(k)(bx) = phi(norm(bx - bx_k))$ sestavljajo bazo za množico funkcij oblike @eq:05-rbf.  

Radialne bazne funkcije \(RBF) so funkcije, katerih vrednosti so odvisne od razdalje do izhodiščne
točke

$ f(bx) = phi (norm(bx - bx_0)) $

Uporabljajo se za interpolacijo ali aproksimacijo podatkov s funkcijo oblike

$ F(bx) = sum_i w_i phi(norm( bx - bx_i)), $

npr. za rekonstrukcijo 2D in 3D oblik v računalniški grafiki. Funkcija
$phi$ je navadno pozitivna soda funkcija zvončaste oblike in jo
imenujemo funkcija oblike.


Problem @eq:05enacbe se prevede na iskanje vrednosti koeficientov $bw=[w_1, dots w_n]^T$, tako da je
izpolnjen sistem enačb

$
F(bx_1, w_1, w_2, dots, w_n) = f_1\
dots.v\
F(bx_n, w_1, w_2, dots, w_n) =  f_n.
$<eq:05int>

Enačbe @eq:05int so linearne za koeficiente $w_1, dots w_n$:

$
w_1 phi_1(bx_1) + w_2 phi_2(bx_1) dots w_n phi_n(bx_1) = f_1\
dots.v\
w_1 phi_1(bx_n) + w_2 phi_2(bx_n) dots w_n phi_n(bx_n) = f_n,
$<eq:05lin-sistem>

Z matriko sistema

$
mat(
  phi(norm(bx_1 - bx_1)), phi(norm(bx_1-bx_2)), dots, phi(norm(bx_1-bx_n));
  phi(norm(bx_2 - bx_1)), phi(norm(bx_2-bx_2)), dots, phi(norm(bx_2-bx_n));
  dots.v, dots.v, dots.down, dots.v;
  phi(norm(bx_n - bx_1)), phi(norm(bx_n - bx_2)), dots, phi(norm(bx_n - bx_n))
).
$<eq:05-matrika>

Ker je 

$
phi_i(bx_j) = phi(norm(bx_j - bx_i)) = phi(norm(bx_i -bx_j)) = phi_j(bx_i),
$

je matrika sistema @eq:05-matrika simetrična. V literaturi @savchenko95 se pojavijo naslednje
izbire za funkcijo oblike $phi$:
  - #link("https://en.wikipedia.org/wiki/Polyharmonic_spline")[poliharmonični zlepek] (_pločevina_):
   $phi(r) = r^2 log (r)$ za 2d in $phi(r) =(r)^3$ za 3d @turk99
  - Gaussova funkcija: $phi(r) = e^(-r^2/sigma^2)$
  - racionalni približek za Gaussovo funkcijo:
    $ phi(r) = 1/(1 + (r/sigma)^(2p)). $

Če izberemo primerno funkcijo oblike, lahko 
dosežemo, da je matrika sistema @eq:05-matrika pozitivno definitna.  V tem primeru lahko za 
reševanje sistema uporabimo razcep Choleskega (poglavje 2.6 v @orel). Za funkcijo oblike bomo 
izbrali Gaussovo funkcijo

$
phi(r) = e^(-t^2/sigma^2),
$<eq:05gauss>

za katero je matrika sistema @eq:05lin-sistem pozitivno definitna, če so točke 
$bx_1, bx_2, dots bx_n$ različne @buhmann15.

== Program

#let vaja05(koda) = jlfb(
  "Vaja05/src/Vaja05.jl",
  koda
)

Najprej definiramo podatkovni tip, ki opiše linearno kombinacijo RBF @eq:05-rbf.

#code_box(
  vaja05("# rbf")
)

Za podatkovni tip napišimo funkcijo #jl("vrednost(x,rbf::RBF)"), ki izračuna vrednost linearne
kombinacije @eq:05-rbf v dani točki `x` (rešitev @pr:05vrednost). Za primer ustvarimo mešanico 
dveh Gaussovih RBF v točkah $(1, 0)$ in $(2, 1)$:

#let s_vaja05(koda) = jlfb(
  "scripts/05_implicit.jl",
  koda
)

#code_box[
  #s_vaja05("# primer 2 točk")
  #raw(read("out/05_z.out"))
]

Narišimo še graf funkcije dveh spremenljivk podane z linearno kombinacijo RBF.

#code_box(
  s_vaja05("# slika 2 točki")
)

#figure(
  image("img/05-2tocki.svg", width: 60%),
  caption: [Linearna kombinacija dveh RBF v točkah $(1, 0)$ in $(2, 1)$ s funkcijo oblike $phi(r) = e^(-r^2/0.7^2)$.]
)

Rešimo sedaj problem interpolacije. Zapišimo funkcijo #jl("interpoliraj(tocke, vrednosti, phi)"), ki poišče koeficiente v linearni kombinaciji @eq:05-rbf in vrne objekt tipa #jl("RBF"), ki dane podatke interpolira (rešitev @pr:05interpolacija). Funkcijo preskusimo na točkah, ki jih generiramo na parametrično podani krivulji @eq:05-cikloida. Sledimo @turk99 in
točkam na krivulji dodamo točke znotraj krivulje, v smeri normal, ki poskrbijo, da ne dobimo trivialne rešitve.

#code_box(
  s_vaja05("# oblak")
)
Vrednosti funkcije $f_i$ za točke na krivulji izberemo tako, da so enake in se razlikujejo od vrednosti v notranjosti.

#code_box(
  s_vaja05("# interpolacija")
)

#figure(
  image("img/05-krivulja.svg", width: 60%),
  caption: [Nivojske krivulje funkcije podane z linearno kombinacijo RBF, ki interpolirajo dane točke]
)
== RBF s kompaktnim nosilcem
<rbf-s-kompaktnim-nosilcem>
Če uporabimo klasične RBF iz prejšnjega razdelka je matrika sistema
polna. Čeprav je večina členov izven diagonale zelo majhnih npr. pri
Gaussovi RBF @eq:05gauss. Če uporabimo RBF s kompaktnim nosilcem, je matrika redka in se tako prostorska kot tudi časovna zahtevnost algoritmov
bistveno zmanjšata @morse01.

== Rešitve

#figure(
  code_box(
    vaja05("# rbf vrednost")
  ),
  caption: [Izračunaj vrednost linearne kombinacije RBF v dani točki]
)<pr:05vrednost>

#figure(
  code_box(
    vaja05("# interpolacija")
  ),
  caption: [Interpoliraj vrednosti funkcij z linearno kombinacijo RBF]
)<pr:05interpolacija>

#let test05(koda) = ljfb(
  "Vaja05/test/runtests.jl",
  koda
)