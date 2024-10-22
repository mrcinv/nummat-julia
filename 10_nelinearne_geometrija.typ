#import "admonitions.typ": opomba
#import "julia.typ": code_box, jlfb, jl, repl, blk

= Nelinearne enačbe v geometriji

Ko obravnavamo geometrijske objekte, ki so ukrivljeni (na primer krožnice,
krivulje, ukrivljene ploskve), lahko probleme pogosto prevedemo na reševanje
sistema nelinearnih enačb. Ogledali si bomo dva primera, kjer problem rešimo
na ta način: iskanje samopresečišča
krivulje in minimlne razdalje med dvema krivuljama.

== Naloga

- Napiši funkcijo, ki poišče eno od samopresečišč
  #link("https://sl.wikipedia.org/wiki/Lissajousova_krivulja")[Lissajousove krivulje]
   $ (x(t), y(t)) = (a sin(n t), b cos(m t)) $
   za parametre $a = b = 1$, $n=3$ in $m=2$.
- Poišči najmanjšo razdaljo med dvema parametrično podanima krivuljama:
    $
    (x_1(t), y_1(t)) = &(2 cos(t) + 1/3, sin(t) + 1/4) \
    (x_2(s), y_2(s)) = &(1/3 cos(s) - 1/2 sin(s), 1/3 cos(s) + 1/2 sin(t)).
    $
  - Zapiši razdaljo med točko na prvi krivulji in točko na drugi krivulji kot funkcijo
    $d(t, s)$ parametrov $t$ in $s$.
  - Z #link("https://en.wikipedia.org/wiki/Gradient_descent")[gradientnim spustom]
    poišči minimum funkcije $d(t, s)$ oziroma $d^2(t, s)$.
  - Minimum funkcije $d^2(t, s)$ poišči še z Newtonovo metodo kot rešitev
    vektorske enačbe
    $ nabla d^2(t, s) = 0. $
  - Grafično predstavi zaporedja približkov za gradientno in Newtonovo metodo.
  - Primerjaj konvergenčna območja za gradientno in Newtonovo metodo (glej @9-poglavje).

== Presečišča parametrično podanih krivulj

Poiščimo samopresečišča
#link("https://sl.wikipedia.org/wiki/Lissajousova_krivulja")[Lissajousove krivulje]
$
x(t) = a sin(n t)\
y(t) = b cos(m t)
$<eq:10-lissajous>

za parametre $a=b=1$, $n=2$ in $m=3$. Za lažjo prdstavo najprej narišemo krivuljo.

#let demo10(koda) = code_box(
  jlfb("scripts/10_geom.jl", koda)
)

#demo10("# krivulja")

#figure(
  image("img/10-lissajous.svg", width: 60%), caption: [Lissajousova krivulja za $a=b=1$, $n=2$ in $m=3$]
)

Iščemo parametra $t$ in $s$, ki sta različna $t eq.not s$ in za katera velja
$
x(t) = x(s)\
y(t) = y(s).
$<eq:10-samopres>

Dobili smo torej sistem dveh nelinearnih enačb z dvema neznankama. Rešitve sistema @eq:10-samopres
poiščemo z Newtonovo metodo, ki smo jo spoznali v prejšnjem poglavju \(@9-poglavje\). Newtonova
metoda zahteva, da sistem enačb prevedemo v vektorsko enačbo $F(bold(x))=bold(0)$. Funkcija,
katere ničlo iščemo, je:
$
F(vec(delim: "[", t, s)) = vec(delim: "[", x(t) - x(s), y(t) - y(s)),
$

njena Jacobijeva matrika pa:

$
J F(vec(delim: "[", t, s)) = mat(
  dot(x)(t), -dot(x)(s); dot(y)(t), -dot(y)(s)
).
$

#demo10("# samopres")

#figure(
  image("img/10-samopres.svg", width: 60%),
  caption: [Krivulja doseže izbrano samopresečišče pri dveh različnih vrednostih parametra $t$.])

Napišimo funkcijo, #jl("samopres(k, dk, ts0)"), ki poišče eno od samopresečišč
krivulje z Newtonovo metodo (rešitev @pr:10-samopres).

Nato uporabimo @pr:09-konvergenca in poiščemo vsa samopresečišča ter določimo konvergenčna
območja. Ker sta funkciji $sin$ in $cos$, ki nastopata v definiciji krivulje,
periodični s periodo $2pi$, vrednosti parametrov $t$ in $s$ računamo po modulu
$2pi$.

#demo10("# obmocje samopres")

#figure(image("img/10-obmocje-samopres.svg", width: 60%),
  caption: [Območje konvergence za samopresečišča Lissajousove krivulje])
Narišimo sedaj še krivuljo in na njej označimo sva samopresečišča.
#demo10("# vsa samopres")

#figure(image("img/10-vsa-samopres.svg", width: 60%)
)
== Minimalna razdalja med dvema krivuljama

#let bk = math.bold("k")

Naj bosta $K_1$ in $K_2$ parametrično podani krivulji:

$
  K_1: bk_1(t) = (x_1(t), y_1(t)); quad t in RR\
  K_2: bk_2(s) = (x_2(s), y_2(s)); quad s in RR.
$
Narišimo obe krivulji na istem grafu.

#demo10("# krivulji")

#figure(image("img/10-krivulji.svg", width: 60%), caption: [Krivulji v ravnini])

Razdaljo med krivuljama lahko definiramo na različne načine. Izberemo definicijo,
ki razdaljo med krivuljamo
definira kot najmanjšo razdaljo med točko na eni krivulji in točko na drugi krivulji:

$
d_(m)(K_1, K_2) = min_(T_1 in K_1, T_2 in K_2) d(T_1, T_2).
$

#opomba(naslov: [Hausdorffova razdalja])[
Alternativna definicije razdalje med dvema množicama je #emph[Hausdorfova razdalja].
Hausdorffova razdalja pove, koliko je lahko točka na eni krivulji največ oddaljena od druge
krivulje in je definirana kot

$ d_(h)(K_1, K_2) = max(max_(T_1 in K_1) min_(T_2 in K_2) d(T_1, T_2),
  max_(T_2 in K_2) min_(T_1 in K_1) d(T_1, T_2)).
$

Če sta množici blizu v Hausdorffovi razdalji, je vsaka točka ene množice blizu
drugi množici. Medtem ko je minimalna razdalja med dvema krivuljama vedno končna,
pa je lahko Hausdorffova razdalja tudi neskončna (na primer, če je ena krivulja omejena,
druga pa neomejena).
]

Iščemo točko $bk_1(t)$ na krivulji $bk_1$ in točko $bk_2(s)$ na
krivulji $bk_2$, ki sta najbližji med vsemi pari točk. Iščemo vrednosti
parametrov $t$ in $s$, pri katerih funkcija razdalje

$
d(t, s) = sqrt((x_1(t)-x_2(s))^2 + (y_1(t)-y_2(s))^2)
$

doseže minimum. Ker je koren naraščajoča funkcija, imata $d(t, s)$ in $d^2(t, s)$ minimum v isti točki.
Zato namesto minima funkcije $d(t, s)$ poiščemo minimum funkcije

$
D(t, s) = d^2(t, s)=(x_1(t)-x_2(s))^2 + (y_1(t)-y_2(s))^2.
$

Funkcijo $D(t, s)$ na kvadratu $[-pi, pi]^2$ grafično predstavimo z
nivojnicami in barvami.

#demo10("# razdalja")

#figure(image("img/10-graf-razdalja.svg", width: 60%),
caption: [Razdalja med točkama na krivuljah $k_1$ in $k_2$ v odvisnosti od parametrov na krivulji]
)


=== Gradientni spust

Metoda gradientnega spusta je sila enostavna. Predstavljamo si, da je gosta megla in da smo na
pobočju gore. Želimo čim prej priti v dno doline. Na vsakem koraku izberemo smer, v kateri je
pobočje najstrmejše in se premaknemo v tej smeri. Na ta način bomo najhitreje izgubili višino.
Vendar ni nujno, da bomo na ta način prišli v dno doline, saj lahko prej pristanemo v kakšni
kotanji ali vrtači na pobočju gore. V vsakem primeru bomo
prišli nekam na dno, od koder bo šlo le še navzgor.

V jeziku funkcij iščemo minimum funkcije več spremenljivk $f(bold(x))$. Na vsakem koraku izberemo
smer, v kateri funkcija najhitreje pada, in se premaknemo za določen korak v tej smeri.
To je ravno v nasprotni smeri gradienta funkcije. Če koraki niso preveliki, bomo prej ali slej
pristali v lokalnemu minimumu funkcije $f(bold(x))$.
Računamo naslednje zaporedje približkov:

$
bold(x)^((n+1)) = bold(x)^((n)) - h_n nabla f(bold(x)^((n))),
$
kjer je $nabla f(bold(x)^((n)))$ vrednost gradienta v točki $bold(x)^((n))$,  vrednost $h_n$ pa je
parameter, ki poskrbi, da zaporedje približkov ne skače preveč po domeni in se lahko na vsakem
koraku spremeni. Napišimo funkcijo #jl("spust(gradf, x0, h)"), ki poišče lokalni minimum funkcije
z metodo gradientnega spusta (rešitev @pr:10-spust).

Gradient funkcije $D(t, s)$ bi lahko izračunali na roke, vendar je to zamudno in se pri tem lahko
hitro zmotimo. Uporabili bomo knjižnico za
#link("https://en.wikipedia.org/wiki/Automatic_differentiation")[avtomatsko odvajanje]
#link("https://juliadiff.org/ForwardDiff.jl/stable/")[`ForwardDiff.jl`], ki učinkovito izračuna
vrednosti parcialnih odvodov funkcije v posameznih točkah.
Knjižnica #jl("ForwardDiff") zna odvajati le funkcije vektorske spremenljivke, zato funkcijo
dveh spremenljivk #jl("d2(t, s)") spremenimo v funkcijo vektorske spremenljivke
#jl("ts -> d2(ts...)"). Operator #jl("...") elemente vektorja razporedi kot argumente funkcije.

#demo10("# odvodi")
//#code_box(raw(read("out/10_grad.out")))

#demo10("# spust")

#figure(caption: [Zaporedje približkov gradientnega spusta],
  image("img/10_priblizki_grad.svg", width: 60%))

Iz slike je razvidno, da gradientni spust konvergira k lokalnemu minimumu, vendar postane konvergenca
počasna, ko se približamo minimumu. Konvergenco lahko pohitrimo s primerno izbiro parametra $h_n$, na
primer z metodo
#link("https://sl.wikipedia.org/wiki/Minimizacija_v_dani_smeri")[minimiziranja v dani smeri].

=== Newtonova metoda

Fermatov izrek pravi, da je v lokalnem ekstremu vrednost odvoda vedno enaka 0.
Isti izrek velja tudi za funkcije več spremenljivk, le da je v tem primeru gradient funkcije enak 0.

Ta Fermatov izrek morda ni tako razvpit kot njegov zadnji, je pa zato uporabnejši.
Potreben pogoj za nastop lokalnega ekstrema je tako vektorska enačba

$
nabla D(t, s) = vec((partial D(t, s))/(partial t), (partial D(t, s))/(partial s)) = 0.
$<eq:10-stac>

Rešitev enačbe @eq:10-stac lahko poiščemo z Newtonovo metodo.

#demo10("# newton")

#figure(caption: [Zaporedje približkov gradientnega spusta in Newtonove metode z istim začetnim
približkom],
  image("img/10_priblizki.svg", width: 60%))


Za razliko od gradientnega spusta, Newtonova metoda ne konvergira nujno k lokalnemu minimumu, ampak
k eni od stacionarnih točk funkcije $D(t, s)$, med katerimi so tudi sedla in maksimumi. Zato je
Newtonova metoda precej občutljivejša na izbiro začetnega približka kot gradientni spust.

Poglejmo si točki na krivuljah, ki ustrezata parametroma najdenima z
gradientnim spustom:

#demo10("# minimum")

in Newtonovo metodo:

#demo10("# sedlo")



#figure(kind: image, caption: [Levo: točki na krivuljama, h katerima konvergira gradientna metoda
sta lokalni minimum, ki pa ni globalni. Desno: Newtonova metoda konvergira k sedlu.
Točka na $k_1$ je lokalni minimum, točka na $k_2$ pa lokalni maksimum.],
table(stroke: none, columns: 2, image("img/10_minimum.svg"), image("img/10_sedlo.svg"))
)

Za konec si oglejmo še konvergenčna območja za gradientni spust:

#demo10("# obmocje grad")

in Newtonovo metodo:

#demo10("# obmocje newton")

#figure(kind: image,
table(stroke: none, columns: 2,
image("img/10_obmocje_grad.svg"),
image("img/10_obmocje_newton.svg")),
caption: [Območja konvergence za gradientni spust (levo) in Newtonovo metodo (desno)])

Problem iskanja minimuma funkcije, ki smo ga reševali, spada med optimizacijske probleme.
Študij optimizacijskih problemov je obsežno raziskovalno področje. Več o tem si lahko preberete v knjigi
@kochenderfer_algorithms_2019.

== Rešitve

#let vaja10(koda, caption) = figure(caption: caption, code_box(jlfb("Vaja10/src/Vaja10.jl", koda)))


#vaja10("# samopres")[Funkcija poišče samopresečišče krivulje z Newtonovo metodo.]<pr:10-samopres>
#vaja10("# razdalja2")[Funkcija kvadrata razdalje med dvema krivuljama]<pr:10-razdalja2>
#vaja10("# grad")[Gradientni spust]<pr:10-spust>
