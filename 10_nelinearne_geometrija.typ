#import "admonitions.typ": opomba
#import "julia.typ": code_box, jlfb, jl

= Nelinearne enačbe v geometriji

== Naloga

- Implementirajte Newtonovo metodo za sisteme nelinearnih enačb.
- Napišite funkcijo, ki poišče samopresečišče
  #link("https://sl.wikipedia.org/wiki/Lissajousova_krivulja")[Lissajousove krivulje]
   $ (x(t), y(t)) = (a sin(n t), b cos(m t)) $
   za parametre $a = b = 1$ in $n=3$ in $m=2$.
- Poiščite minimalno razdaljo med dvema parametrično podanima krivuljama:
  $
  (x_1(t), y_1(t)) = &(2 cos(t) + 1/3, sin(t) + 1/4) \
  (x_2(s), y_2(s)) = &(1/3 cos(s) - 1/2 sin(s), 1/3 cos(s) + 1/2 sin(t)).
  $
  - Zapišite razdaljo med točko na prvi krivulji in točko na drugi krivulji kot funkcijo
    $d(t, s)$ parametrov $t$ in $s$.
  - Minimum funkcije $d(t, s)$ oziroma $d^2(t, s)$ poiščite z #link("https://en.wikipedia.org/wiki/Gradient_descent")[gradientnim spustom].
  - Minimum funkcije $d^2(t, s)$ poiščite z Newtonovo metodo kot rešitev vektorske enačbe $ nabla d^2(t, s) = 0. $
  - Grafično predstavite zaporedja približkov za gradientno metodo in Newtonovo metodo.
  - Primerjajte konvergenčna območja za gradientno in Newtonovo metodo (glej @konvergencna-obmocja).

== Presečišča geometrijskih objektov
Poiščimo samopresečišča
#link("https://sl.wikipedia.org/wiki/Lissajousova_krivulja")[Lissajousove krivulje]
$
x(t) = a sin(n t)\
y(t) = b cos(m t)
$<eq:10-lissajous>

za parametre $a=b=1$, $n=2$ in $m=3$. Da si lažje predstavljamo, kaj iščemo, najprej narišimo
krivuljo.

#let demo10(koda) = code_box(
  jlfb("scripts/10_geom.jl", koda)
)

#demo10("# krivulja")

#figure(
  image("img/10-lissajous.svg", width: 60%), caption: [Lissajousova krivulja za $a=b=1$, $n=2$ in $m=3$]
)
== Minimalna razdalja med dvema krivuljama

#let bk = math.bold("k")

Naj bosta $K_1$ in $K_2$ parametrično podani krivulji:

$
  K_1: bk_1(t) = (x_1(t), y_1(t)); quad t in RR\
  K_2: bk_2(t) = (x_2(s), y_2(s)); quad s in RR.
$

Razdaljo med krivuljama lahko definiramo na različne načine. Poglejmo si dva načina, kako definiramo
razdaljo med krivuljama:

- #emph[Minimalna razdalja]:
  $ d_(m)(K_1, K_2) = min_(bold(T_1) in K_1, bold(T_2) in K_2) d(T_1, T_2), $
- #emph[Hausdorffova razdalja]:
  $ d_(h)(K_1, K_2) = max(max_(T_1 in K_1) min_(T_2 in K_2) d(T_1, T_2),
    max_(T_2 in K_2) min_(T_1 in K_1) d(T_1, T_2)) $

#opomba(naslov: [Hausdorffova razdalja])[
Hausdorffova razdalja pove, koliko je lahko točka na eni krivulji največ oddaljena od druge
krivulje. Če sta množici blizu v Hausdorffovi razdalji, je vsaka točka ene množice blizu
drugi množici. Medtem, ko je minimalna razdalja med dvema krivuljama vedno končna,
pa je lahko Hausdorffova razdalja tudi neskončna (na primer, če je ena krivulja omejena,
druga pa neomejena).
]

V primeru minimalne razdalje iščemo točko $bk_1(t)$ na krivulji $bk_1$ in točko $bk_2(s)$ na
krivulji $bk_2$, ki sta najbližji med vsemi pari točk. Iščemo vrednosti parametrov $t$ in $s$
pri katerih funkcija razdalje

$
d(t, s) = sqrt((x_1(t)-x_2(s))^2 + (y_1(t)-y_2(s))^2)
$

doseže minimum. Ker je koren naraščajoča funkcija imata $d(t, s)$ in $d^2(t, s)$ minimum v isti točki.
Zato bomo raje poiskali minimum funkcije

$
D(t, s) = d^2(t, s)=(x_1(t)-x_2(s))^2 + (y_1(t)-y_2(s))^2.
$

=== Gradientni spust

=== Newtonova metoda

Fermat je med drugim dokazal izrek, ki pove, da je v lokalnem ekstremu vrednost odvoda vedno enaka 0.
Isti izrek velja tudi za funkcije več spremenljivk, le da je v tem primeru gradient funkcije enak 0.

Ta izrek morda ni tako razvpit kot njegov zadnji izrek, je pa zato toliko bolj uporaben.
Potreben pogoj za nastop lokalnega ekstrema je namreč vektorska enačba

$
nabla D(t, s) = 0.
$<eq:10-stac>

Gradient $nabla D$ lahko izrazimo s smernimi odvodi na krivulji:

$
nabla D(t, s) = vec((partial D(t, s))/(partial t), (partial D(t, s))/(partial s)) = vec(
  2(x_1(t) - x_2(s))dot(x)_1(t) + 2(y_1(t) - y_2(s))dot(y)_1(t),
  -2(x_1(t) - x_2(s))dot(x)_2(s) - 2(y_1(t) - y_2(s))dot(y)_2(s)
)
$

Rešitev enačbe @eq:10-stac lahko poiščemo z Newtonovo metodo, ki smo jo spoznali v prejšnjem poglavju
(@konvergencna-obmocja).

== Rešitve
