#import "admonitions.typ": opomba, naloga
#import "julia.typ": code_box, jl, jlfb, pkg
#import "@preview/fletcher:0.5.2": diagram, node, edge
#import "@preview/cetz:0.3.1" as cetz: canvas, plot

= Minimalne ploskve
<minimalne-ploskve>

Žično zanko s pravokotnim tlorisom potopimo v milnico, tako da se nanjo napne
milna opna. Naša naloga bo poiskati obliko milne opne. Malo brskanja po
fizikalnih knjigah ali internetu hitro razkrije, da ploskve, ki tako nastanejo,
sodijo med
#link("http://en.wikipedia.org/wiki/Minimal_surface")[minimalne ploskve], ki so
burile domišljijo mnogih matematikov in nematematikov. Minimalne ploskve so navdihovale tudi
umetnike in arhitekte. Eden najbolj znanih primerov uporabe
minimalnih ploskev v arhitekturi je streha münchenskega olimpijskega stadiona, ki jo je zasnoval
#link("https://en.wikipedia.org/wiki/Frei_Otto")[Frei Otto] s sodelavci. Frei Otto je
eksperimentiral z milnimi mehurčki in elastičnimi tkaninami, s katerimi je ustvarjal nove oblike.


#figure(
  image("img/1024px-Olympic_Stadium_Munich_Dachbegehung.JPG", width: 90%),
  caption: [Streha olimpijskega stadiona v Münchnu (vir: #link(
      "https://de.wikipedia.org/wiki/Olympiastadion_M%C3%BCnchen#/media/File:Olympic_Stadium_Munich_Dachbegehung.JPG")[Wikipedia])],
)

== Naloga
<naloga>
Namen te vaje je primerjava eksplicitnih in iterativnih metod za reševanje sistemov linearnih enačb.
Prav tako se bomo naučili, kako zgradimo matriko sistema in desne strani enačb za spremenljivke,
ki niso podane z vektorjem, temveč kot elementi matrike. V okviru te vaje zato opravi naslednje
naloge:

- Izpelji matematični model za minimalne ploskve s pravokotnim tlorisom.
- Zapiši problem iskanja minimalne ploskve kot
  #link("https://en.wikipedia.org/wiki/Boundary_value_problem")[robni problem] za
  #link("https://en.wikipedia.org/wiki/Laplace%27s_equation")[Laplaceovo enačbo] na pravokotniku.
- Robni problem diskretiziraj in zapiši v obliki sistema linearnih enačb.
- Reši sistem linearnih enačb z LU razcepom. Uporabi knjižnico
  #link("https://docs.julialang.org/en/v1/stdlib/SparseArrays/")[SparseArrays] za varčno hranjenje
  matrike sistema.
- Preveri, kako se število neničelnih elementov poveča pri LU razcepu razpršene matrike.
- Uporabi iterativne metode (Jacobijeva, Gauss-Seidlova in SOR iteracija)  na elementih matrike
  višinskih vrednosti ploskve in reši
  sistem enačb brez eksplicitne uporabe matrike sistema.
- Nariši primer minimalne ploskve.
- Animiraj konvergenco iterativnih metod.

== Matematično ozadje
<matematično-ozadje>

Ploskev v trirazsežnem prostoru lahko predstavimo eksplicitno s funkcijo dveh spremenljivk
$z = u (x, y)$, ki predstavlja višino ploskve nad točko $(x, y)$. Naša naloga je poiskati približek
za funkcijo $u$ na danem pravokotnem območju, ki opisuje obliko milne opne, napete na žični
zanki s pravokotnim tlorisom.

Funkcija $u$, ki opisuje milno opno, zadošča
#link("https://en.wikipedia.org/wiki/Young%E2%80%93Laplace_equation")[Young-Laplaceovi enačbi]:
$
  (1+u_(x)^2) u_(y y) -u_(x) u_(y) u_(x y) + (1 + u_(y)^2)u_(x x) = rho(x, y),
$ <eq:4-young-laplace>

kjer so $u_x=(partial u)/(partial x)$, $u_y=(partial u)/(partial y)$,
$u_(x x) = (partial^2 u)/(partial x^2)$, $u_(x y) = (partial^2 u)/(partial x partial y)$
in $u_(y y) = (partial^2 u)/(partial y^2)$ parcialni odvodi funkcije $u$.
Funkcija $rho$ je sorazmerna tlačni razliki med zgornjo in spodnjo površino milne opne in je posledica teže milnice.
Enačba @eq:4-young-laplace vsebuje parcialne odvode in jo zato uvrščamo med
#link("https://sl.wikipedia.org/wiki/Parcialna_diferencialna_ena%C4%8Dba")[parcialne diferencialne
enačbe] ali s kratico PDE. Parcialni odvodi nastopajo nelinearno, zato enačbo @eq:4-young-laplace
uvrščamo med nelinearne PDE.

Če zanemarimo tlačno razliko $rho$ in višje potence odvodov $u_x^2$, $u_y^2$ in $u_x u_y$, dobimo
#link("https://en.wikipedia.org/wiki/Laplace%27s_equation")[Laplaceovo enačbo]:

$
  Delta u(x, y) = u_(x x)(x, y) + u_(y y)(x, y)= 0.
$<eq:Laplace>

Diferencialni operator

$
Delta u = u_(x x) + u_(y y)
$<eq:operator>
imenujemo #link("https://sl.wikipedia.org/wiki/Laplaceov_operator")[Laplaceov operator].

Vrednosti $u$ na robu območja so določene z obliko zanke, medtem ko za vrednosti v notranjosti
velja enačba @eq:Laplace.  Problem za
diferencialno enačbo, pri katerem so podane vrednosti na robu, imenujemo
#link("https://en.wikipedia.org/wiki/Boundary_value_problem")[robni problem]. Ker je oblika milnice
določena na robu, iskanje oblike milnice prevedemo na robni problem za Laplaceovo PDE na
območju, omejenem s tlorisom žične zanke.

Naj bo območje pravokotnik $[a, b] times [c, d]$.
Poleg Laplaceove enačbe @eq:Laplace veljajo za vrednosti funkcije $u$
tudi #emph[robni pogoji]:

$
  u(x, c) &= f_s (x),\
  u(x, d) &= f_z (x),\
  u(a, y) &= f_l (y),\
  u(b, y) &= f_d (y).
$<eq:robni-pogoji>

Pri tem so $f_s, f_z, f_l$ in $f_d$ dane funkcije. Rešitev robnega
problema je odvisna od izbire območja in robnih pogojev.

== Diskretizacija in sistem linearnih enačb
<diskretizacija-in-linearni-sistem-enačb>
Problema se lotimo numerično, zato vrednosti
$u(x, y)$ poiščemo le v končno mnogo točkah: problem
#link("https://en.wikipedia.org/wiki/Discretization")[diskretiziramo].
Za diskretizacijo je najpreprosteje uporabiti enakomerno razporejeno pravokotno mrežo točk na
pravokotniku. Točke na mreži imenujemo #emph[vozlišča]. Zaradi enostavnosti se omejimo na mreže z
enakim razmikom v obeh koordinatnih smereh. Interval $[a, b]$
razdelimo na $n + 1$ delov, interval $[c, d]$ pa na $m + 1$ delov tako, da sta razmika v obeh
smereh približno enaka. Dobimo zaporedje koordinat, ki definirajo pravokotno mrežo točk $(x_j, y_i)$:
$
  a = & x_0, & x_1, med dots, med & x_(n+1)&=b & quad #text[ in ]\
  c = & y_0, & y_1, med dots, med & y_(m+1)&=d.
$

Namesto funkcije $u: [a, b] times [c, d] arrow.r bb(R)$
tako iščemo le vrednosti

$ u_(i j) = u(x_j, y_i), quad i=1, med dots, med m, quad j=1, med dots, med n. $

Vrstni red indeksov $j$ in $i$ smo v matriki zamenjali, saj prvi indeks določa položaj
elementa matrike v navpični smeri, drugi indeks pa položaj v vodoravni smeri.
//#figure([#image("sosedi.png")], caption: [
// sosednja vozlišča
//])

Elemente matrike $u_(i j)$ določimo tako, da je v limiti, ko gre razmik med vozlišči proti
$0$, izpolnjena Laplaceova enačba @eq:Laplace.

Laplaceovo enačbo lahko diskretiziramo s
#link("https://en.wikipedia.org/wiki/Finite_difference")[končnimi diferencami]. Lahko pa
dobimo navdih pri arhitektu Ottu, ki je minimalne ploskve
#link("https://youtu.be/-IW7o25NmeA")[raziskoval z elastičnimi tkaninami]. Ploskev si
predstavljamo kot elastično tkanino, ki je fina kvadratna mreža iz elastičnih nitk. Vsako vozlišče v mreži je povezano s štirimi sosednjimi vozlišči.

#figure(
  caption:[Vrednosti v sosednjih vozliščih])[
  #canvas({
    import cetz.draw: *
    set-style(
      line: (stroke: 0.5pt),
      content: (padding: 3pt)
    )
    line((0, 0), (0, 5), stroke: 0.2pt, mark:(end: "stealth"))
    content((), $y$, anchor: "south")
    line((0, 0), (5, 0), stroke: 0.2pt, mark:(end: "stealth"))
    content((), $x$, anchor: "west")
    content((2.5, 2.5), $u_(i, j)$)
    // y ticks
    content((0, 2.5), $y_i$, anchor: "east")
    line((0, 2.5), (0.1, 2.5), stroke: 0.2pt)
    content((0, 4), $y_(i+1)$, anchor: "east")
    line((0, 4), (0.1, 4), stroke: 0.2pt)
    content((0, 1), $y_(i-1)$, anchor: "east")
    line((0, 1), (0.1, 1), stroke: 0.2pt)
    // x ticks
    content((2.5, 0), $x_j$, anchor: "north")
    line((2.5, 0), (2.5, 0.1), stroke: 0.2pt)
    content((4, 0), $x_(j+1)$, anchor: "north")
    line((4, 0), (4, 0.1), stroke: 0.2pt)
    content((1, 0), $x_(j-1)$, anchor: "north")
    line((1, 0), (1, 0.1), stroke: 0.2pt)
    // connections
    content((1, 2.5), $u_(i, j-1)$)
    content((4, 2.5), $u_(i, j+1)$)
    content((2.5, 1), $u_(i-1, j)$)
    content((2.5, 4), $u_(i+1, j)$)
    line((1.5, 2.5), (2, 2.5))
    line((3, 2.5), (3.5, 2.5))
    line((2.5, 1.5), (2.5, 2))
    line((2.5, 3), (2.5, 3.5))

  })
]

Vozlišče je v ravnovesju, ko je vsota vseh sil nanj enaka 0.

#figure(
  caption:[Vektorske komponente sil, ki delujejo na vozlišče
  $(x_(j),y_(i))$ iz sosednjih vozlišč $(x_(j-1), y_(i))$ in
  $(x_(j+1), y_(i))$.])[
  #canvas({
    import cetz.draw: *
    set-style(
      content: (padding: 2pt)
    )
    let (x0, y0) = (-1.5, -4.5)
    line((x0, y0), (x0, y0 + 6), stroke: 0.2pt, mark:(end: "stealth"))
    content((), $z$, anchor: "south")
    line((x0, y0), (x0 + 9, y0), stroke: 0.2pt, mark:(end: "stealth"))
    content((), $x$, anchor: "west")
    let x = 3
    let y = -1.5
    line((x, y), (0, 0), mark: (end: ">"))
    line((0, 0), (x, 0), stroke: 0.2pt)
    line((x, y), (x, 0), mark: (end: ">"), name:"f1")
    line((x, y), (x, 2.5*y), mark: (end: ">"), name: "f2")
    line((x, y), (2*x, 2.5*y), mark: (end: ">"))
    line((x, 2.5*y), (2*x, 2.5*y), stroke: 0.2pt)
    circle((x, y), radius: 0.05, fill: white)
    circle((0, 0), radius: 0.05, fill: white)
    circle((2*x, 2.5*y), radius: 0.05, fill: white)
    content((x + 0.1, 0.5*y), [$bold(F)_(1 z) prop u_(i, j-1) - u_(i, j)$], anchor: "west")
    content((x - 0.1, 1.5*y), [$bold(F)_(2 z) prop u_(i, j+1) - u_(i, j)$], anchor: "east")
    content((x * 0.5 , 0.3*y), [$bold(F)_1$], anchor: "west")
        content((x * 1.5 , 1.9*y), [$bold(F)_2$], anchor: "east")
    content((-0.2, 0), [$u_(i, j-1)$], anchor: "east" )
    content((x + 0.2, y), [$u_(i, j)$], anchor: "west" )
    content((2*x + 0.2, 2.5*y), [$u_(i, j+1)$], anchor: "west" )
  })
]

Predpostavimo, da so vozlišča povezana z idealnimi vzmetmi in je sila sorazmerna z vektorjem med
položaji vozlišč. Če zapišemo enačbo za komponente sile v smeri $z$, dobimo za točko
$(x_j, y_i, u_(i j))$ enačbo:

$
  (u_(i-1 j) - u_(i j)) + (u_(i j-1) - u_(i j))
    + (u_(i+1 j) - u_(i j)) + (u_(i j+1) - u_(i j)) &= 0 arrow.r.double\
    arrow.r.double
  u_(i-1 j) + u_(i j-1) - 4u_(i j) + u_(i+1 j) + u_(i j+1) &= 0.
$<eq:ravnovesje>

Za vsako vrednost $u_(i j)$ dobimo eno enačbo. Tako dobimo sistem $n dot m$ linearnih enačb za
$n dot m$ neznank. Ker so vrednosti na robu določene z robnimi pogoji, moramo elemente
$u_(0 j)$, $u_(m + 1 j)$, $u_(i 0)$ in $u_(i n + 1)$ prestaviti na desno stran in jih
upoštevati kot konstante.

== Matrika sistema linearnih enačb
<matrika-sistema-linearnih-enačb>
Sisteme linearnih enačb navadno zapišemo v matrični obliki:

$ A bold(x) = bold(b), $

kjer je $A$ kvadratna matrika, $bold(x)$ in $bold(b)$ pa vektorja. V našem primeru je to nekoliko
bolj zapleteno, saj so spremenljivke $u_(i j)$ elementi matrike. Zato
jih moramo najprej razvrstiti v vektor $bold(x)=[x_1, x_2, med dots, med x_N]^T,$ kjer je $N=m dot.c n$ število vseh elementov matrike.
Najpogosteje elemente $u_(i j)$ razvrstimo v vektor $bold(x)$ po stolpcih, tako da je:

$
bold(x) = [u_(11), u_(21), med dots, med u_(m 1), u_(12), u_(22), med dots, med u_(1 n), med dots, med u_(m-1 n), u_(m n)]^T.
$

Iz enačb @eq:ravnovesje lahko potem razberemo matriko $A$. Za $n = m = 3$ dobimo matriko velikosti
$9 times 9$:

$
A^(9, 9) = mat(-4, 1, 0, 1, 0, 0, 0, 0, 0; 1, -4, 1, 0, 1, 0, 0,
0, 0; 0, 1, -4, 0, 0, 1, 0, 0, 0; 1, 0, 0, -4, 1, 0, 1, 0, 0; 0, 1, 0, 1, -4,
1, 0, 1, 0; 0, 0, 1, 0, 1, -4, 0, 0, 1; 0, 0, 0, 1, 0, 0, -4, 1, 0; 0, 0, 0,
0, 1, 0, 1, -4, 1; 0, 0, 0, 0, 0, 1, 0, 1, -4),
$

ki je sestavljena iz $3 times 3$ blokov

$
L^(3, 3) = mat(-4,1,0; 1,-4,1; 0,1,-4),quad
I^(3, 3) = mat(1,0,0; 0,1,0; 0,0,1).
$

Vektor desnih strani prav tako razberemo iz enačbe @eq:ravnovesje. Za $n=m=3$ dobimo vektor:

$
bold(b) &= -[
u_(0 1) + u_(1 0),med u_(2 0), med u_(3 0) + u_(4 1),
u_(0 2), med 0, med u_(4 2),
u_(0 3) + u_(1 4),med u_(2 4),med u_(3 4) + u_(4 3)]^T.
$

V splošnem je formulo za vektor desnih strani lažje sprogramirati, zato bomo zapis izpustili.

#let vecop = math.op("vec", limits: true)

#opomba(naslov: [Razvrstitev po stolpcih in operator $vecop$])[
Elemente matrike razvrstimo v vektor tako, da stolpce
matrike enega za drugim postavimo v vektor. Indeks v vektorju $k$
izrazimo z indeksi v matriki $i,j$ s formulo

$ k = i+(j-1)m. $

Ta način preoblikovanja matrike v vektor označimo s posebnim operatorjem $vecop$:

$
vecop: RR^(m times n) -> RR^(m dot n)\
vecop(A)_(i + (j-1)m) = a_(i j).
$
]

== Izpeljava sistema s Kroneckerjevim produktom

Množenje matrike $A$ z vektorjem $bold(x) = vecop(U)$ lahko zapišemo kot:

$
  A vecop(U) = vecop(L U + U L),
$

kjer je $L$ matrika Laplaceovega operatorja v eni dimenziji, ki ima $-2$ na diagonali in $1$ na spodnji
in zgornji obdiagonali:

$
L = mat(
  -2, 1, 0, dots, 0;
  1, -2, 1, dots.down, dots.v;
  0, dots.down, dots.down, dots.down, 0;
  dots.v, dots.down, 1, -2, 1;
  0, dots, 0,  1, -2;
).
$

Res! Moženje matrike $U$ z matriko $L$ z leve je ekvivalentno množenju stolpcev matrike $U$ z
matriko $L$, medtem ko je množenje z matriko $L$ z desne ekvivalentno množenju vrstic matrike $U$
z matriko $L$. Prispevek množenja z leve predstavlja vsoto sil sosednjih vozlišč v smeri $y$, medtem ko
množenje z desne predstavlja vsoto sil sosednjih vozlišč v smeri $x$. Element produkta $L U + U L$ na
mestu $(i, j)$ je enak:

$
  (L U + U L)_(i j) &= sum_(k=1)^m l_(i k) u_(k j) + sum_(k=1)^n u_(i k) l_(k j) =\
  &= u_(i - 1 j) -2u_(i j) + u_(i +1 j) + u_(i j-1) -2u_(i j) + u_(i j+1),
$

kar je enako levi strani enačbe @eq:ravnovesje.

Operacijo množenja matrike $U: U |-> L U + U L$ lahko predstavimo s
#link("https://sl.wikipedia.org/wiki/Kroneckerjev_produkt")[Kroneckerjevim produktom $times.circle$],
saj velja $vecop(A X B) = A times.circle B dot vecop(X)$. Tako velja:

$
  A vecop(U) &= vecop(L U + U L) = vecop(L U I + I U L) =\
  & = vecop(L U I) + vecop(I U L)
   = (L times.circle I) vecop(U) + (I times.circle L) vecop(U)
$

in

$
  A^(N, N) &= L^(m, m) times.circle I^(n, n) + I^(m, m) times.circle L^(n, n).
$

#opomba(naslov:[Kroneckerjev produkt in operator $vecop$ v Julii])[
Programski jezik Julia ima vgrajene funkcije `vec` in `kron` za preoblikovanje matrik v vektorje in
računanje Kroneckerjevega produkta. Z ukazom `reshape` iz vektorja
znova zgradimo matriko.
]
== Numerična rešitev z LU razcepom

Preden se lotimo programiranja, ustvarimo nov paket za to vajo:

#code_box[
  #pkg("generate Vaja04", none, env: "nummat")
  #pkg("develop Vaja04/", none, env: "nummat")
]

Nato dodamo pakete, ki jih bomo potrebovali:

#code_box[
  #pkg("activate Vaja04", none, env:"nummat")
  #pkg("add SparseArrays", none, env: "Vaja04")
]

Kodo bomo organizirali tako, da bomo najprej ustvarili podatkovni tip, ki opiše robni problem za PDE
na pravokotniku:

#code_box[
  #jlfb("Vaja04/src/Vaja04.jl", "# RPP")
]

Definiramo še tip brez polj, ki predstavlja Laplaceov diferencialni operator @eq:operator
in ga bomo lahko dodali v polje za operator v `RobniProblemPravokotnik`:

#code_box[
  #jlfb("Vaja04/src/Vaja04.jl", "# Laplace")
]

#opomba(naslov: [Podatkovni tipi brez polj])[
Programski jezik Julia ne pozna razredov.
#link("https://docs.julialang.org/en/v1/manual/types/#man-singleton-types")[Podatkovni tipi brez polj],
kot je `Laplace`, nadomestijo razrede brez stanja in omogočajo podobno obliko #link("https://en.wikipedia.org/wiki/Polymorphism_(computer_science)")[polimorfizma].
]

#let pi32 = $1.5 pi$

Robni problem za Laplaceovo enačbo na pravokotniku $[0, pi32]times [0, pi]$ z robnimi pogoji:

$
u(x, 0) = u(x, pi) &= sin(x) quad #text[in]\
u(0, y) = u(pi32, y) &= sin(y)
$<eq:4-rp-sin-0>
predstavimo z objektom:

#code_box[
  #jlfb("scripts/04_laplace.jl", "# rp sin")
]

Zaenkrat si s tem objektom še ne moremo nič pomagati. Zato napišemo funkcije, ki bodo poiskale
rešitev za dani robni problem. Kot smo videli v @diskretizacija-in-linearni-sistem-enačb[poglavju],
lahko približek za rešitev robnega problema poiščemo kot rešitev sistema linearnih enačb
@eq:ravnovesje.

#naloga[
Najprej napiši funkcijo, ki vrne matriko sistema:

#code_box[
  #jl("function matrika(_::Laplace, n, m)")
]

za dane dimenzije notranje mreže $n times m$ (za rešitev glej @pr:matrika).
]

Nato na robu mreže
izračunamo robne pogoje in sestavimo vektor desnih strani sistema @eq:ravnovesje. Ker je
preslikovanje dvojnega indeksa v enojnega in nazaj precej sitno, bomo večino operacij
naredili na matriki $U = [u_(i j)]$ dimenzij $(m+2) times (n+2)$, ki vsebuje tudi
vrednosti na robu.

#naloga[
Napiši funkcijo:

#code_box[
  #jl("U0, x, y = diskretiziraj(rp::RobniProblemPravokotnik, h),")
]
ki poišče pravokotno mrežo z razmikom med vozlišči približno enakim `h` in
izračuna vrednosti na robu. Rezultati funkcije `diskretiziraj` so matrika `U0`, vektor `x` in
vektor `y`. Matrika `U0` ima notranje elemente
enake $0$, robni elementi pa so določeni z robnimi pogoji. Vektorja `x` in `y` vsebujeta delilne
točke na intervalih $[a, b]$ in $[c, d]$ (rešitev je @pr:4-diskretiziraj).
]

Iz matrike `U0` preprosto sestavimo desne strani enačb. Notranje indekse
zaporedoma zamaknemo v levo, desno, gor in dol ter seštejemo ustrezne podmatrike.
Rezultat nato spremenimo v vektor s funkcijo #jl("vec") .
#naloga[
Napiši funkcijo #jl("desne_strani(U0)"), ki iz rezultata funkcije #jl("diskretiziraj")
sestavi vektor desnih strani sistema (rešitev je @pr:desne-strani).

Ko imaš pripravljeno matriko in desne strani, vse skupaj zloži v funkcijo:

#code_box(
  jl("U, x, y = resi(rp::RobniProblemPravokotnik, h),")
)

ki za dani robni problem `rp` in razmik med vozlišči `h` sestavi matriko sistema, izračuna desne
strani na podlagi robnih pogojev in reši sistem. Funkcija vrne matriko vrednosti `U`
in vektorja delilnih točk `x` in `y` (rešitev je @pr:resi).
]
#pagebreak()
Napisane programe uporabimo za rešitev robnega problema na pravokotniku $[0, pi32]times[0, pi]$ z
robnimi pogoji:
$
  u(0, y) &= 0,\
  u(pi32, y) &= 0,\
  u(x, 0) &= sin(x),\
  u(x, pi) &= sin(x).
$
Definiramo robni problem in uporabimo funkcijo #jl("resi"). Ploskev narišemo s funkcijo
#jl("surface").

#code_box(
  jlfb("scripts/04_laplace.jl", "# sedlo")
)

#figure(image("img/04_sedlo.svg", width: 60%),
  caption: [Rešitev robnega problema za Laplaceovo enačbo z robnimi pogoji @eq:4-rp-sin-0]
 )

== Napolnitev matrike ob eliminaciji
<napolnitev-matrike-ob-eliminaciji>
Matrika Laplaceovega operatorja ima veliko ničelnih elementov. Takim matrikam
pravimo
#link(
  "https://sl.wikipedia.org/wiki/Redka_matrika",
)[razpršene ali redke matrike]. Razpršenost matrike izkoristimo za
prihranek prostora in časa, kot smo že videli pri
tridiagonalnih matrikah (@tridiagonalni-sistemi). Vendar se pri
LU razcepu, ki ga uporablja operator #jl("\\") za rešitev sistema, delež neničelnih elementov
matrike pogosto poveča. Poglejmo, kako se odreže matrika za Laplaceov operator.
#let demo4(koda) = code_box(
  jlfb("scripts/04_laplace.jl", koda)
)

#demo4("# napolnitev")

#figure(
  kind: image,
  table(
    columns:2, stroke: none,
    image("img/04-spyA.svg"),image("img/04-spyLU.svg")),
  caption: [Neničelni elementi matrike za Laplaceov operator (levo) in
  njenega LU razcepa (desno). Število ničelnih elementov se pri LU razcepu
  poveča. Kljub temu sta L in U v razcepu še vedno precej redki matriki.]
)

#opomba(naslov: [Matrični razcepi v Julii])[
V knjižnici #link("https://docs.julialang.org/en/v1/stdlib/LinearAlgebra")[LinearAlgebra]
najdemo implementacije standardnih matričnih razcepov,
kot so LU razcep, razcep Choleskega, QR razcep in drugi.
Rezultat matričnega razcepa v Julii je poseben podatkovni tip, ki učinkovito
hrani rezultate razcepa. Poleg tega so za različne razcepe definirane specializirane metode
splošnih funkcij. Posebej uporabna je funkcija #jl("\\"), ki z izbranim
matričnim razcepom učinkovito reši sistem linearnih enačb.

Poglejmo si, kako z LU razcepom rešimo sistem linearnih enačb.
Uporabimo funkcijo #jl("lu"), ki vrne rezultat tipa #jl("LU"), s katerim
nadomestimo matriko $A$ v izrazu #jl("A\\b"):

#demo4("# lu")

Funkcija #jl("factorize") vrne najprimernejši razcep za dano matriko. Tako za simetrično
pozitivno definitno matriko vrne razcep Choleskega.
]
== Iteracijske metode
<iteracijske-metode>
V prejšnjih podpoglavjih smo poiskali približno obliko minimalne ploskve, tako da smo
sistem linearnih enačb @eq:ravnovesje rešili z LU razcepom.
Največ težav smo imeli z zapisom matrike sistema in desnih strani. Poleg tega je matrika sistema
 redka, ko izvedemo LU razcep pa se matrika deloma napolni. Pri razpršenih
matrikah tako pogosto uporabimo
#link(
  "https://en.wikipedia.org/wiki/Iterative_method#Linear_systems",
)[iterativne metode]
za reševanje sistemov enačb, pri katerih se matrika ne spreminja in zato
prihranimo veliko na prostorski in časovni zahtevnosti.

Ideja iteracijskih metod je preprosta. Enačbe preuredimo tako, da ostane na eni strani le en element
s koeficientom 1. Tako dobimo iteracijsko formulo za zaporedje približkov $u_(i j)^((k))$.
Če zaporedje konvergira, je limita ena od rešitev rekurzivne enačbe. V primeru sistemov linearnih
enačb je rešitev enolična.

V našem primeru enačb za minimalne ploskve @eq:ravnovesje izpostavimo element $u_(i j)$ in dobimo
rekurzivne enačbe:

$
u_(i j)^((k+1)) = 1/4 (u_(i j-1)^((k))+u_(i-1 j)^((k))+u_(i+1 j)^((k))+u_(i j+1)^((k))),
$<eq:jacobi>

ki ustrezajo #link("https://en.wikipedia.org/wiki/Jacobi_method")[Jacobijevi iteraciji]. Približek
za rešitev dobimo tako, da zaporedoma uporabimo rekurzivno formulo @eq:jacobi.

#opomba(naslov: [Pogoji konvergence])[
Rekli boste, da je preveč enostavno enačbe le preurediti in se potem rešitev kar sama pojavi, če le dovolj dolgo računamo. Gotovo se nekje skriva kak "hakelc". Res je! Težave se pojavijo, če zaporedje približkov *ne konvergira dovolj hitro* ali pa sploh ne. Jacobijeva, Gauss-Seidlova in SOR iteracija
*ne konvergirajo vedno*, zagotovo pa konvergirajo, če je matrika #link("https://sl.wikipedia.org/wiki/Diagonalno_dominantna_matrika")[diagonalno dominantna po vrsticah].
]


Konvergenco Jacobijeve iteracije lahko izboljšamo, če namesto vrednosti $u_(i-1 j)^((k))$ in
$u_(i j-1)^((k))$ uporabimo nove vrednosti $u_(i-1 j)^((k+1))$ in $u_(i j-1)^((k+1))$, ki so bile
že izračunane (elemente $u_(i j)^((k+1))$ računamo po leksikografskem vrstnem redu).
Če nove vrednosti uporabimo v iteracijski formuli, dobimo
#link(
  "https://en.wikipedia.org/wiki/Gauss%E2%80%93Seidel_method",
)[Gauss-Seidlovo iteracijo]:

$
  u_(i,j)^((k+1)){G S} = 1/4(u_(i,j-1)^((k+1))+ u_(i-1,j)^((k+1))+u_(i+1,j)^((k))+u_(i,j+1)^((k))).
$<eq:gs>

Konvergenco še izboljšamo, če približek $u_(i j)^((k + 1))$, ki ga dobimo
z Gauss-Seidlovo metodo, malce "pokvarimo" s približkom na prejšnjem koraku
$u_(i j)^((k))$. Tako dobimo
#link("https://en.wikipedia.org/wiki/Successive_over-relaxation")[metodo SOR]:

$
  u_(i,j)^((k+1)){G S} &= 1/4(u_(i,j-1)^((k+1))+ u_(i-1,j)^((k+1))+u_(i+1,j)^((k))+u_(i,j+1)^((k))),\
  u_(i, j)^((k+1)){S O R} &= omega u_(i, j)^((k+1)){G S} + (1 - omega) u_(i, j)^((k)).
$

Parameter $omega$ je lahko poljubno število na intervalu
$(0, 2)$. Pri $omega = 1$ dobimo Gauss-Seidlovo iteracijo.

Prednost iteracijskih metod je, da jih je zelo enostavno implementirati. Za Laplaceovo enačbo je
en korak Gauss-Seidlove iteracije podan s preprosto zanko.

#figure(
  code_box(
    jlfb("Vaja04/src/Vaja04.jl", "# gs")
  ),
  caption: [Funkcija, ki poišče naslednji približek Gauss-Seidlove iteracije za diskretizacijo
    Laplaceove enačbe.]
)<pr:gs>

#naloga[
Napišite še funkciji #jl("korak_jacobi(U0)") in  #jl("korak_sor(U0, omega)"), ki izračunata
naslednji približek za Jacobijevo in SOR iteracijo za sistem za Laplaceovo enačbo. Nato napišite še
funkcijo

#code_box(jl("x, k = iteracija(korak, x0),"))

ki izračuna zaporedje približkov za poljubno iteracijsko metodo, dokler se rezultat ne spreminja več znotraj določene tolerance.
Argument #jl("korak") je funkcija, ki iz danega približka izračuna naslednjega, argument #jl("x0") pa začetni približek iteracije.

Rešitve so na koncu poglavja v programih @pr:jacobi, @pr:sor in @pr:iteracija.
]
=== Konvergenca
<konvergenca>

Poglejmo si, kako zaporedje približkov Gauss-Seidlove iteracije konvergira k rešitvi.

#code_box[
  #jlfb("scripts/04_laplace.jl", "# konvergenca jacobi 0")
  #jlfb("scripts/04_laplace.jl", "# konvergenca jacobi 10")
  #jlfb("scripts/04_laplace.jl", "# konvergenca jacobi oo")
]

#figure(
  kind: image,
  table(columns: 2, stroke: none,
    image("img/04-konv-0.svg"), image("img/04-konv-10.svg"),
    image("img/04-konv-50.svg"), image("img/04-konv-oo.svg")
  ), caption: [Približki Gauss-Seidlove iteracije za $k=0, 10, 50$ in končni približek]
)


Za metodo SOR je hitrost konvergence odvisna od izbire parametra $omega$. Odvisnost od parametra
$omega$ je različna za različne matrike in začetne približke. Oglejmo si odvisnost za
primer sistema, ki ga dobimo z diskretizacijo Laplaceove enačbe.

#code_box(
  jlfb("scripts/04_laplace.jl", "# konvergenca sor")
)

#figure(image("img/04-konv-sor.svg", width:60%), caption:[ Odvisnost potrebnega število korakov SOR iteracije
od parametra $omega$])

#opomba(naslov: [Kaj smo se naučili?])[
- Kako rešiti sistem linearnih enačb s spremenljivkami, ki so postavljene v matriko.
- Diskretizacija diferencialnih enačb privede do sistemov linearnih enačb.
- Iterativne metode so posebej uporabne za reševanje sistemov
  velikih dimenzij z redkimi matrikami.
]

== Rešitve

// Uporabili smo naslednje funkcije in knjižnice v `Julii`:

// #rect(
//   table(columns: 2, stroke: none,
//     [
//       #jl("spdiagm") - ustvari razpršeno matriko z danimi diagonalami

//       #jl("kron") - izračunaj Kroneckerjev produkt

//       #jl("vec") - spremeni matriko v vektor

//       #jl("reshape") - preoblikuj vektor v matriko
//     ],
//     [
//      #jl("surface") - nariši ploskev v prostoru

//      #jl("spy") - grafično predstavi neničelne elemente matrike

//     #jl("SparseArrays") - knjižnica za razpršene matrike]
//   )
// )
#let vaja04(koda, caption) = figure(
  code_box(
    jlfb("Vaja04/src/Vaja04.jl", koda)
  ),
  caption: caption
)

#figure(
  code_box(
    jlfb("Vaja04/src/Vaja04.jl", "# matrika")
  ),
  caption: [Funkcija, ki zgradi matriko za diskretizacijo Laplaceovega operatorja.]
)<pr:matrika>
#vaja04("# diskretiziraj")[Funkcija, ki diskretizira robni problem na pravokotniku.]<pr:4-diskretiziraj>
#figure(
  code_box(
    jlfb("Vaja04/src/Vaja04.jl", "# desne strani")
  ),
  caption: [Funkcija, ki izračuna robne pogoje in desne strani sistema za diskretizacijo Laplaceove enačbe.]
)<pr:desne-strani>

#figure(
  code_box(
    jlfb("Vaja04/src/Vaja04.jl", "# resi")
  ),
  caption: [Funkcija, ki poišče približno rešitev robnega problema za Laplaceovo enačbo.]
)<pr:resi>

#figure(
  code_box(
    jlfb("Vaja04/src/Vaja04.jl", "# jacobi")
  ),
  caption: [Funkcija, ki poišče naslednji približek Jacobijeve iteracije za diskretizacijo Laplaceove enačbe.]
)<pr:jacobi>

#figure(
  code_box(
    jlfb("Vaja04/src/Vaja04.jl", "# sor")
  ),
  caption: [Funkcija, ki poišče naslednji približek SOR iteracije za
  diskretizacijo Laplaceove enačbe.]
)<pr:sor>

#figure(
  code_box(
    jlfb("Vaja04/src/Vaja04.jl", "# iteracija")
  ),
  caption: [Funkcija, ki poišče približek za limito rekurzivnega zaporedja.]
)<pr:iteracija>

// TODO: dodaj teste
