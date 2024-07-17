#import "admonitions.typ": opomba
#import "julia.typ": code_box, jl, jlfb, pkg
#import "@preview/fletcher:0.5.1": diagram, node, edge
#import "@preview/cetz:0.2.2" as cetz: canvas

= Minimalne ploskve
<minimalne-ploskve>
== Naloga
<naloga>
Žično zanko s pravokotnim tlorisom potopimo v milnico, tako da se nanjo napne
milna opna. Radi bi poiskali obliko milne opne, razpete na žični zanki. Malo brskanja po
fizikalnih knjigah in internetu hitro razkrije, da ploskve, ki tako nastanejo,
sodijo med
#link("http://en.wikipedia.org/wiki/Minimal_surface")[minimalne ploskve], ki so
burile domišljijo mnogim matematikom in nematematikom. Minimalne ploskve so
navdihovale tudi umetnike npr. znanega arhitekta
#link("https://en.wikipedia.org/wiki/Frei_Otto")[Otto Frei], ki je sodeloval pri
zasnovi Muenchenskega olimpijskega stadiona, kjer ima streha obliko minimalne
ploskve.

#figure(
  image("img/1024px-Olympic_Stadium_Munich_Dachbegehung.JPG"),
  caption: [Streha olimpijskega stadiona v Münchnu (vir #link(
      "https://de.wikipedia.org/wiki/Olympiastadion_M%C3%BCnchen#/media/File:Olympic_Stadium_Munich_Dachbegehung.JPG")[wikipedia])],
)
Namen te vaje je primerjava eksplicitnih in iterativnih metod za reševanje linearnih sistemov enačb.
Prav tako se bomo naučili, kako zgradimo matriko sistema in desne strani enačb za spremenljivke,
ki niso podane z vektorjem ampak kot elementi matrike. V okviru te vaje opravi naslednje naloge.

- Izpelji matematični model za minimalne ploskve s pravokotnim tlorisom.
- Zapiši problem iskanja minimalne ploskve kot #link("https://en.wikipedia.org/wiki/Boundary_value_problem")[robni problem] za #link("https://en.wikipedia.org/wiki/Laplace%27s_equation")[Laplaceovo enačbo] na pravokotniku.
- Robni problem diskretiziraj in zapiši v obliki sistema linearnih enačb.
- Reši sistem linearnih enačb z LU razcepom. Uporabi knjižnico 
  #link("https://docs.julialang.org/en/v1/stdlib/SparseArrays/")[SparseArrays] za varčno hranjenje
  matrike sistema.
- Preveri, kako se število neničelnih elementov poveča pri LU razcepu razpršene matrike.
- Uporabi iterativne metode (Jacobijeva, Gauss-Seidlova in SOR iteracija) in reši
  sistem enačb direktno na elementih matrike višinskih vrednosti ploskve brez eksplicitne
  uporabe matrike sistema.
- Nariši primer minimalne ploskve.
- Animiraj konvergenco iterativnih metod.

== Matematično ozadje
<matematično-ozadje>

Ploskev lahko predstavimo s funkcijo dveh spremenljivk $u (x, y)$, ki predstavlja višino ploskve nad
točko $(x, y)$. Naša naloga je poiskati približek za funkcijo $u(x, y)$ na pravokotnem območju.

Funkcija $u(x, y)$, ki opisuje milno opno, zadošča matematična enačbi

$
  Delta u(x,y) = (partial ^2 u)/(partial x^2) + (partial ^2 u)/(partial y^2) = rho(x, y),
$ <eq:Poisson>

znani pod imenom
#link("https://sl.wikipedia.org/wiki/Poissonova_ena%C4%8Dba")[Poissonova enačba]. Diferencialni 
operator 
$
Delta u(x, y) = (partial ^2 u)/(partial x^2) + (partial ^2 u)/(partial y^2)
$<eq:operator>
imenujemo #link("https://sl.wikipedia.org/wiki/Laplaceov_operator")[Laplaceov operator].

Funkcija $rho(x, y)$ je sorazmerna tlačni razliki med zunanjo in notranjo
površino milne opne. Tlačna razlika je lahko posledica višjega tlaka v
notranjosti milnega mehurčka ali pa teže milnice. Če tlačno razliko zanemarimo,
dobimo
#link("https://en.wikipedia.org/wiki/Laplace%27s_equation")[Laplaceovo enačbo]:

$
  Delta u(x, y) = 0.
$<eq:Laplace>

Vrednosti $u(x, y)$ na robu območja so določene z obliko zanke, medtem ko za vrednosti v notranjosti
velja enačba @eq:Laplace. Enačbo, ki vsebuje parcialne odvode, imenujemo 
#link("https://sl.wikipedia.org/wiki/Parcialna_diferencialna_ena%C4%8Dba")[parcialna diferencialna
enačba] ali s kratico PDE. Rešitev PDE je funkcija več spremenljivk, ki zadošča enačbi. Problem za
diferencialno enačbo, pri katerem so podane vrednosti na robu, imenujemo 
#link("https://en.wikipedia.org/wiki/Boundary_value_problem")[robni problem]. Ker je oblika milnice
določena na robu, lahko iskanje oblike milnice prevedemo na robni problem za Laplaceovo PDE na 
območju omejenem s tlorisom žične zanke.

V nadaljevanju predpostavimo, da je območje pravokotnik $[a, b] times [c, d]$.
Poleg Laplaceove enačbe @eq:Laplace, veljajo za vrednosti funkcije $u(x, y)$
tudi #emph[robni pogoji]:

$
  u(x, c) = f_s (x) \
  u(x, d) = f_z (x) \
  u(a, y) = f_l (y) \
  u(b, y) = f_d (y)\
$<eq:robni-pogoji>

kjer so $f_s, f_z, f_l$ in $f_d$ dane funkcije. Rešitev robnega
problema je tako odvisna od območja, kot tudi od robnih pogojev.

== Diskretizacija in linearni sistem enačb
<diskretizacija-in-linearni-sistem-enačb>
Problema se bomo lotili numerično, zato bomo vrednosti
$u(x, y)$ poiskali le v končno mnogo točkah: problem bomo
#link("https://en.wikipedia.org/wiki/Discretization")[diskretizirali].
Za diskretizacijo je najpreprosteje uporabiti enakomerno razporejeno pravokotno mrežo točk na
pravokotniku. Točke na mreži imenujemo #emph[vozlišča]. Zaradi enostavnosti se omejimo na mreže z
enakim razmikom v obeh koordinatnih smereh. Interval $[a, b]$
razdelimo na $n + 1$ delov, interval $[c, d]$ pa na $m + 1$ delov in dobimo zaporedje koordinat

$
  a = & x_0, & x_1, & dots & x_(n+1)=b\
  c = & y_0, & y_1, & dots & y_(m+1)=d,
$

ki definirajo pravokotno mrežo točk $(x_i, y_j)$. Namesto funkcije $u
: [a, b] times [c, d] arrow.r bb(R)$
tako iščemo le vrednosti

$ u_(j i) = u(x_i, y_j), #h(1em) i=1, dots n, #h(1em) j=1, dots m $

//#figure([#image("sosedi.png")], caption: [
// sosednja vozlišča
//])

Elemente matrike $u_(j i)$ določimo tako, da je v limiti, ko gre razmik med vozliči proti
$0$, izpolnjena Laplaceova enačba @eq:Laplace.

Laplaceovo enačbo lahko diskretiziramo s
#link("https://en.wikipedia.org/wiki/Finite_difference")[končnimi diferencami]. Lahko pa
dobimo navdih pri arhitektu Frei Otto, ki je minimalne ploskve
#link("https://youtu.be/-IW7o25NmeA")[raziskoval z elastičnimi tkaninami]. Ploskev si
predstavljamo kot elastično tkanino, ki je fina kvadratna mreža iz elastičnih nitk. Vsako vozlišče v mreži je povezano s 4 sosednjimi vozlišči.

#figure(
  caption:[Sosednje vrednosti vozlišča $(i,j)$.])[
  #diagram(
    node((1, 0), $u_(i - 1 j)$),
    edge("d", "-"),
    node((0, 1), $u_(i j - 1)$),
    edge("-"),
    node((1, 1), $u_(i j)$),
    edge("-"),
    node((2, 1), $u_(i j+1)$),
    node((1, 2), $u_(i+1 j)$),
    edge("u", "-")
  )
]

Vozlišče bo v ravnovesju, ko bo vsota vseh sil nanj enaka 0.

#figure(
  caption:[Sile elastik iz sosednjih vozlišč $(i, j-1)$ in $(i, j+1)$ na vozlišče $(i,j)$.])[
  #canvas({
    import cetz.draw: *
    let x = 3
    let y = -1.5
    line((0, 0), (x, y))
    line((0, 0), (x, 0), stroke: 0.2pt)
    line((x, y), (x, 0), mark: (end: ">"), name:"f1")
    line((x, y), (x, 2.5*y), mark: (end: ">"), name: "f2")
    line((x, y), (2*x, 2.5*y))
    line((x, 2.5*y), (2*x, 2.5*y), stroke: 0.2pt)
    circle((x, y), radius: 0.05, fill: white)
    circle((0, 0), radius: 0.05, fill: white)
    circle((2*x, 2.5*y), radius: 0.05, fill: white)
    content((x + 0.1, 0.5*y), [$bold(F)_1 prop u_(i j-1) - u_(i j)$], anchor: "west")
    content((x - 0.1, 1.5*y), [$bold(F)_2 prop u_(i j+1) - u_(i j)$], anchor: "east")
    content((-0.2, 0), [$u_(i j-1)$], anchor: "east" )
    content((x + 0.2, y), [$u_(i j)$], anchor: "west" )
    content((2*x + 0.2, 2.5*y), [$u_(i j+1)$], anchor: "west" )
  })
]

Predpostavimo, da so vozlišča povezana z idealnimi vzmetmi in je sila sorazmerna z vektorjem med
položaji vozlišč. Če zapišemo enačbo za komponente sile v smeri $z$, dobimo za točko
$(x_i, y_j, u_(i j))$ enačbo

$
  (u_(i-1 j) - u_(i j)) + (u_(i j-1) - u_(i j)) 
    + (u_(i+1 j) - u_(i j)) + (u_(i j+1) - u_i(i, j)) &= 0\
  u_(i-1 j) + u_(i j-1) - 4u_(i j) + u_(i+1 j) + u_(i j+1) &= 0.
$<eq:ravnovesje>

Za vsako vrednost $u_(i j)$ dobimo eno enačbo. Tako dobimo sistem linearnih $n dot m$ enačb za
$n dot m$ neznank. Ker so vrednosti na robu določene z robnimi pogoji, moramo elemente
$u_(0 j)$, $u_(n plus 1, j)$, $u_(i 0)$ in $u_(i m plus 1)$ prestaviti na desno stran in jih
upoštevati kot konstante.

== Matrika sistema linearnih enačb
<matrika-sistema-linearnih-enačb>
Sisteme linearnih enačb običajno zapišemo v matrični obliki

$ A bold(x) = bold(b), $

kjer je $A$ kvadratna matrika, $bold(x)$ in $bold(b)$ pa vektorja. Spremenljivke
$u_(i j)$ moramo nekako razvrstiti v vektor $bold(x)=[x_1, x_2, dots]^T$.
Najpogosteje elemente $u_(i j)$ razvrstimo v vektor $bold(x)$ po stolpcih, tako da je

$
bold(x) = [u_(11), u_(21) med dots med u_(n 1), u_(12), u_(22) med dots med u_(1n) med dots med u_(m-1 n), u_(m n)]^T.
$

Za $n = m = 3$ dobimo $9 times 9$ matriko

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

in desne strani

$
bold(b) = -\[&u_(0 1)+u_(1 0), u_(2 0) dots u_(n 0) + u_(n+1 1),\
 &u_(0 2), 0 dots u_(n+1, 2), u_(0 3), 0 dots u_(n m+1), u_(n m+1) + u_(n+1 m)\]^T.
$

#let vecop = math.op("vec", limits: true)

#opomba(naslov: [Razvrstitev po stolpih in operator $vecop$])[
Eden od načinov, kako lahko elemente matrike razvrstimo v vektor, je tako, da stolpce
matrike enega za drugim postavimo v vektor. Indeks v vektorju $k$ lahko
izrazimo z indeksi $i,j$ v matriki s formulo
$ k = i+(m-1)j. $ Ta način preoblikovanja matrike v vektor označimo s posebnim operatorjem $vecop$:
$
vecop: RR^(m times n) -> RR^(m dot n)\
vecop(A)_(i + (m-1)j) = a_(i j).
$
]

== Izpeljava sistema s Kronekerjevim produktom

Množenje vektorja $bold(x) = vecop(U)$ z matriko $A$ lahko prestavimo kot
množenje matrike $U$ z matriko $L$ z leve in desne:

$
  A vecop(U) = vecop(L U + U L),
$

kjer je $L$ Laplaceova matrika v eni dimenziji, ki ima $-2$ na diagonali in $1$ na spodnji
pod-diagonali in zgornji nad-diagonali:

$
L = mat(
  -2, 1, 0, dots, 0;
  1, -2, 1, dots, dots.v;
  dots.v, dots.down, dots.down, dots.down, 0;
  0, dots, 1, -2, 1;
  0, dots, 0,  1, -2;
).
$

Res! Moženje matrike $U$ z matriko $L$ z leve je ekvivalentno množenju stolpcev matrike $U$ z
matriko $L$, medtem ko je množenje z matriko $L$ z desne ekvivalentno množenju vrstic matrike $U$
z matriko $L$. Prispevek množenja z leve vsebuje vsoto sil sosednjih vozlišč v smeri $y$, medtem ko
množenje z desne vsebuje vsoto sil sosednjih vozlišč v smeri $x$. Element produkta $L U + U L$ na
mestu $(i, j)$ je enak:

$
  (L U + U L)_(i j) &= sum_(k=1)^m l_(i k) u_(k j) + sum_(k=1)^n u_(i k) l_(k j) \
  &= u_(i j-1) -2u_(i j) + u_(i j+1) + u_(i - 1 j) -2u_(i j) + u_(i +1 j),
$

kar je enako desni strani enačbe @eq:ravnovesje.

Operacijo množenja matrike $U: U |-> L U + U L$ lahko predstavimo s 
#link("https://sl.wikipedia.org/wiki/Kroneckerjev_produkt")[Kronekerjevim produktom $times.circle$],
saj velja $vecop(A X B) = A times.circle B dot vecop(X)$. Tako lahko matriko $A$ zapišemo kot:

$
  A dot vecop(U) &= vecop(L U + U L) = vecop(L U I + I U L) \
  A^(N, N) &= L^(m, m) times.circle I^(n, n) + I^(m, m) times.circle L^(n, n).
$

#opomba(naslov:[Kroneckerjev produkt in operator $vecop$ v Juliji])[
Programski jezik Julia ima vgrajene funkcije `vec` in `kron` za preoblikovanje matrik v vektorje in
računanje Kronekerjevega produkta. Z ukazom `reshape` pa lahko iz vektorja
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

Definiramo še abstrakten tip brez polj, ki predstavlja Laplaceov diferencialni operator @eq:operator 
in ga bomo lahko doali v polje za operator v `RobniProblemPravokotnik`:

#code_box[
  #jlfb("Vaja04/src/Vaja04.jl", "# Laplace")
]

#opomba(naslov: [Abstraktni podatkovni tipi])[
Programski jezik Julija ne pozna razredov. Uporaba 
#link("https://docs.julialang.org/en/v1/manual/types/#man-abstract-types")[abstraktnih podatkovnih tipov],
kot je `Laplace`, omogoča #link("https://en.wikipedia.org/wiki/Polymorphism_(computer_science)")[polimorfizem].
Na ta način lahko v kodo organiziramo tako, da odraža abstraktne matematične pojme, kot je v našem
primeru robni problem za PDE. 
]

Robni problem za Laplaceovo enačbo na pravokotniku $[0, pi]times [0, pi]$ z robnimi pogoji
$
u(x, 0) = u(x, pi) &= sin(x)\
u(0, y) = u(pi, y) &= sin(y)
$
lahko predstavimo z objektom

#code_box[
  #jlfb("scripts/04_laplace.jl", "# rp sin")
]

Zaenkrat si s tem objektom še ne moremo nič pomagati. Zato napišemo funkcije, ki bodo poiskale 
rešitev za dani robni problem. Kot smo videli v poglavju @diskretizacija-in-linearni-sistem-enačb, 
lahko približek za rešitev robnega problema poiščemo kot rešitev linearnega sistema enačb 
@eq:ravnovesje. Najprej napišemo funkcijo, ki generira matriko sistema: 

#code_box[
  #jl("function matrika(_::Laplace, n, m)")
]

za dane dimenzije notrajnje mreže `n` in `m` (za rešitev glej @pr:matrika). Nato na robu mreže
izračunamo robne pogoje in sestavimo vektor desnih strani sistema @eq:ravnovesje. Ker je 
preslikovanje dvojnega indeksa v enojni in nazaj precej sitno, bomo večino operacij 
naredili na matriki vrednosti $U = [u_(i j)]$ dimenzij $(m+2) times (n+2)$, ki vsebuje tudi
vrednosti na robu. Napisali bom funkcijo
#code_box[
  #jl("U0, x, y = diskretiziraj(rp::RobniProblemPravokotnik, n, m),")
]
ki vrne matriko `U0` dimenzije $(m + 2) times (n+2)$ za katero so vrednosti notranjih elementov 
enake $0$ in vrednosti na robu podane z robnimi pogoji podanimi v robnem problemu `rp`. Poleg 
matrike `U` naj funkcija vrne vektorja `x` in `y`, ki vsebujeta delilne točke na intervalih $[a, b]$
in $[c, d]$. 

Iz matrike `U` lahko sedaj dokaj preprosto sestavimo desne strani enačb, tako da indekse 
$i=2 dots (m-1)$ in $j=2 dots (n-1)$ zaporedoma zamaknemo v levo, desno, gor in dol in 
seštejemo ustrezne podmatrike. Rezultat nato spremenimo v vektor s funkcijo #jl("vec") 
(za rešitev glej @pr:desne-strani).    

Ko imamo pripravljeno matriko in desne strani, vse skupaj zložimo v funkcijo

#code_box(
  jl("U, x, y = resi(rp::RobniProblemPravokotnik, h),")
)

ki za dani robni problem `rp` in razmik med vozlišči `h` sestavi matriko sistema, izračuna desne
strani na podlagi robnih pogojev in reši sistem. Rezultat nato vrne v obliki matrike vrednosti `U` 
in vektorjev vozlišč `x` in `y` (za rešitev glej @pr:resi).

Napisane programe uporabimo za rešitev robnega problema za pravokotnik $[0, pi]times[0, pi]$ z 
robnimi pogoji 
$
  u(0, y) &= 0\
  u(pi, y) &= 0\
  u(x, 0) &= sin(x)\
  u(x, pi) &= sin(x).
$
Dfiniramo robni problem in uporabimo funkcijo #jl("resi"). Ploskev narišemo s funkcijo 
#jl("surface").

#code_box(
  jlfb("scripts/04_laplace.jl", "# sedlo")
)

#figure(image("img/04_sedlo.svg", width: 60%),
 caption: [Rešitev robnega problema za Laplaceovo enačbo.]
 )

== Napolnitev matrike ob eliminaciji
<napolnitev-matrike-ob-eliminaciji>
Matrika Laplaceovega operatorja ima veliko ničelnih elementov. Takim matrikam
pravimo
#link(
  "https://sl.wikipedia.org/wiki/Redka_matrika",
)[razpršene ali redke matrike]. Razpršenost matirke lahko izkoristimo za
prihranek prostora in časa, kot smo že videli pri
tridiagonalnih matrikah v poglavju @tridiagonalni-sistemi. Vendar se pri
LU razcepu, ki ga uporablja operator #jl("\\") za rešitev sistema, delež neničelnih elementov 
matrike pogosto poveča. Poglejmo, kako se odreže matrika za Laplaceov operator.

#code_box(
  jlfb("scripts/04_laplace.jl", "# napolnitev")
)

#figure(
  kind: image,
  table(
    columns:2, stroke: none, 
    image("img/04-spyA.svg"),image("img/04-spyLU.svg")),
  caption: [Neničelni elementi matrike za Laplaceov operator (levo) in 
  njenega LU razcepa (desno). Število ničelnih elementov se pri LU razcepu 
  poveča. Kljub temu sta L in U v razcepu še vedno precej redki matriki.]
)

== Iteracijske metode 
<iteracijske-metode>
V prejšnjih poglavjih smo poiskali približno obliko minimalne ploskve, tako da smo linearni sistem
@eq:ravnovesje rešili z LU razcepom.
Največ težav smo imeli z zapisom matrike sistema in desnih strani. Poleg tega je matrika sistema
 redka, ko izvedemo LU razcep pa se matrika deloma napolni. Pri razpršenih
matrikah tako pogosto uporabimo
#link(
  "https://en.wikipedia.org/wiki/Iterative_method#Linear_systems",
)[iterativne metode]
za reševanje sistemov enačb, pri katerih se matrika ne spreminja ostane in tako lahko
prihranimo veliko na prostorski in časovni zahtevnosti.

Ideja iteracijskih metod je preprosta. Enačbe preuredimo tako, da ostane na eni strani le en element
s koeficientom 1. Tako dobimo iteracijsko formulo za zaporedje približkov $u_(i j)^((k))$. 
Če zaporedje konvergira, je limita ena od rešitev rekurzivne enačbo. V primeru linearnih sistemov je
rešitev enolična.

V primeru enačb @eq:ravnovesje za minimalne ploskve, izpostavimo element $u_(i j)$ in dobimo
rekurzivne enačbe

$
u_(i j)^((k+1)) = 1/4 (u_(i j-1)^((k))+u_(i-1 j)^((k))+u_(i+1 j)^((k))+u_(i j+1)^((k))),
$<eq:jacobi>

ki ustrezajo #link("https://en.wikipedia.org/wiki/Jacobi_method")[Jacobijevi iteraciji]. Približek 
za rešitev tako dobimo, če zaporedoma uporabimo rekurzivno formulo @eq:jacobi.

#opomba(naslov: [Pogoji konvergence])[
Rekli boste, to je preveč enostavno, če enačbe le pruredimo in se potem rešitel kar sama pojavi, če le dovolj dolgo računamo. Gotovo se nekje skriva kak hakelc. Res je! Težave se pojavijo, če zaporedje približkov *ne konvergira dovolj hitro* ali pa sploh ne. Jakobijeva, Gauss-Seidlova in SOR iteracija 
*ne konvergirajo vedno*, zagotovo pa konvergirajo, če je matrika po vrsticah 
#link("https://sl.wikipedia.org/wiki/Diagonalno_dominantna_matrika")[diagonalno dominantna].
] 


Konvergenco jacobijeve iteracije lahko izboljšamo, če namesto vrednosti $u_(i-1 j)^((k))$ in 
$u_(i j-1)^((k))$, uporabimo nove vrednosti $u_(i-1 j)^((k+1))$ in $u_(i j-1)^((k+1))$, ki so bile
že izračunane, če računamo elemente $u_(i j)^((k+1))$ po leksikografskem vrstnem redu.
Če nove vrednosti upobimo v iteracijski formuli, dobimo
#link(
  "https://en.wikipedia.org/wiki/Gauss%E2%80%93Seidel_method",
)[Gauss-Seidlovo iteracijo]

$
  u_(i,j)^((k+1)) = 1/4(u_(i,j-1)^((k+1))+ u_(i-1,j)^((k+1))+u_(i+1,j)^((k))+u_(i,j+1)^((k)))
$<eq:gs>

Konvergenco še izboljšamo, če približek $u_(i j)^((k + 1))$, ki ga dobimo
z Gauss-Seidlovo metodo, malce "pokvarimo" s približkom na prejšnjem koraku 
$u_(i j)^((k))$. Tako dobimo 
#link("https://en.wikipedia.org/wiki/Successive_over-relaxation")[metodo SOR]

$
  u_(i,j)^(("GS")) &= 1/4(u_(i,j-1)^((k+1))+ u_(i-1,j)^((k+1))+u_(i+1,j)^((k))+u_(i,j+1)^((k)))\
  u_(i, j)^((k+1)) &= omega u_(i, j)^(("GS")) + (1 - omega) u_(i, j)^((k))
$

Parameter $omega$ je lahko poljubno število
$(0, 2)$. Pri $omega = 1$ dobimo Gauss-Seidlovo iteracijo.

Prednost iteracijskih metod je, da jih je zelo enostavno implementirati. Za Laplaceovo enačbo je 
en korak Gauss-Seidlove iteracije podan s preprosto zanko.

#figure(
  code_box(
    jlfb("Vaja04/src/Vaja04.jl", "# gs")
  ),
  caption: [Poišči naslednji približek Gauss-Seidlove iteracije za
  diskretizacijo Laplaceove enačbe.]
)<pr:gs>

Napišite še funkciji #jl("korak_jacobi(U0)") in  #jl("korak_sor(U0, omega)"), ki izračunata
naslednji približek za Jacobijevo in SOR iteracijo za sistem za Laplaceovo enačbo. Nato napišite še
funkcijo 

#code_box(jl("x, k = iteracija(korak, x0),")) 

ki, računa zaporedne približke, dokler se rezultat ne spreminja več znotraj določene tolerance.
Argument `korak` je funkcija, ki iz danega približka izračuna naslednjega.

Rešitve so v programih: @pr:jacobi, @pr:sor in @pr:iteracija. 

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
  ), caption: [Približki Gauss-Seidlove iteracije za $k=0, 10, 50$ in končni približek.]
)


Za metodo SOR je hitrost konvergence odvisna od izbire parametra $omega$. Odvisnot od parametra
$omega$ je različna za različne matrike in začetne približke. Oglejmo si odvisnost za
primer sistema, ki ga dobimo z diskretizacijo Laplaceove enačbe.

#code_box(
  jlfb("scripts/04_laplace.jl", "# konvergenca sor")
)

#figure(image("img/04-konv-sor.svg", width:60%), caption:[ Število korakov SOR iteracije je odvisno 
od parametra $omega$.])


== Rešitve

// Uporabili smo naslednje funkcije in knjižnice v `Juliji`:

// #rect(
//   table(columns: 2, stroke: none,
//     [
//       #jl("spdiagm") - ustvari razpršeno matriko z danimi diagonalami
      
//       #jl("kron") - izračunaj Kronekerjev produkt
      
//       #jl("vec") - spremeni matriko v vektor
    
//       #jl("reshape") - preoblikuj vektor v matriko
//     ], 
//     [
//      #jl("surface") - nariši ploskev v prostoru

//      #jl("spy") - grafično predstavi neničelne elemente matrike
    
//     #jl("SparseArrays") - knjižnica za razpršene matrike]
//   )
// )

Funkcije, ki smo jih definirali v `Vaja04/src/Vaja04.jl`.

#figure(
  code_box(
    jlfb("Vaja04/src/Vaja04.jl", "# matrika")
  ),
  caption: [Generiraj matriko za diskretizacijo Laplaceovega operatorja.]
)<pr:matrika>

#figure(
  code_box(
    jlfb("Vaja04/src/Vaja04.jl", "# desne strani")
  ),
  caption: [Izračunaj robne pogoje in desne strani sistema za diskretizacijo
  Laplaceove enačbe.]
)<pr:desne-strani>

#figure(
  code_box(
    jlfb("Vaja04/src/Vaja04.jl", "# resi")
  ),
  caption: [Poišči približno rešitev robnega problema za Laplaceovo enačbo.]
)<pr:resi>

#figure(
  code_box(
    jlfb("Vaja04/src/Vaja04.jl", "# jacobi")
  ),
  caption: [Poišči naslednji približek Jacobijeve iteracije za
  diskretizacijo Laplaceove enačbe.]
)<pr:jacobi>

#figure(
  code_box(
    jlfb("Vaja04/src/Vaja04.jl", "# sor")
  ),
  caption: [Poišči naslednji približek SOR iteracije za
  diskretizacijo Laplaceove enačbe.]
)<pr:sor>

#figure(
  code_box(
    jlfb("Vaja04/src/Vaja04.jl", "# iteracija")
  ),
  caption: [Poišči približek za limito rekurzivnega zaporedja.]
)<pr:iteracija>

// TODO: dodaj teste