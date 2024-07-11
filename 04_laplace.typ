#import "admonitions.typ": opomba
#import "@preview/fletcher:0.5.1": diagram, node, edge
#import "@preview/cetz:0.2.2" as cetz: canvas

= Minimalne ploskve 
<minimalne-ploskve-laplaceova-enačba>
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
Namen te vaje je primerjava eksplicitnih in iterativnih metod za reševanje linearnih sistemov enačb. Prav tako se bomo naučili, kako zgradimo matriko sistema in desne strani enačb za spremenljivke, ki niso podane z vektorjem ampak kot elementi matrike. V okviru te vaje opravi naslednje naloge.
 
- Izpelji matematični model za minimalne ploskve s pravokotnim tlorisom.
- Zapiši problem iskanja minimalne ploskve kot #link("https://en.wikipedia.org/wiki/Boundary_value_problem")[robni problem] za #link("https://en.wikipedia.org/wiki/Laplace%27s_equation")[Laplaceovo enačbo] na pravokotniku.
- Robni problem diskretiziraj in zapiši v obliki sistema linearnih enačb.
- Reši sistem linearnih enačb z LU razcepom. Uporabi knjižnico #link("https://docs.julialang.org/en/v1/stdlib/SparseArrays/")[SparseArrays] za varčno hranjenje matrike sistema.
- Preveri, kako se število neničelnih elementov poveča pri LU razcepu razpršene matrike.
- Uporabi iterativne metode (Jacobijeva, Gauss-Seidlova in SOR iteracija) in reši 
  sistem enačb direktno na elementih matrike višinskih vrednosti ploskve brez eksplicitne 
  uporabe matrike sistema.
- Nariši primer minimalne ploskve.
- Animiraj konvergenco iterativnih metod.

== Matematično ozadje
<matematično-ozadje>

Ploskev lahko predstavimo s funkcijo dveh spremenljivk $u (x, y)$, ki predstavlja višino ploskve nad točko $(x, y)$. Naša naloga je poiskati približek za funkcijo $u(x, y)$ na pravokotnem območju.

Funkcija $u(x, y)$, ki opisuje milno opno, zadošča matematična enačbi

$
  Delta u(x,y) = (partial ^2 u)/(partial x^2) + (partial ^2 u)/(partial y^2) = rho(x, y),
$ <eq:Poisson>

znani pod imenom 
#link("https://sl.wikipedia.org/wiki/Poissonova_ena%C4%8Dba")[Poissonova enačba].

Funkcija $rho(x, y)$ je sorazmerna tlačni razliki med zunanjo in notranjo
površino milne opne. Tlačna razlika je lahko posledica višjega tlaka v
notranjosti milnega mehurčka ali pa teže milnice.

Če tlačno razliko zanemarimo, dobimo
#link("https://en.wikipedia.org/wiki/Laplace%27s_equation")[Laplaceovo enačbo]:

$
  Delta u(x, y) = 0.
$<eq:Laplace>

Vrednosti $u(x, y)$ na robu območja so določene z obliko zanke, medtem ko za vrednosti v notranjosti velja enačba @eq:Laplace. Problem za diferencialno enačbo, pri katerem so podane vrednosti na robu, imenujemo #link("https://en.wikipedia.org/wiki/Boundary_value_problem")[robni problem]. 

V nadaljevanju predpostavimo, da je območje pravokotnik $[a, b] times [c, d]$.
Poleg Laplaceove enačbe @eq:Laplace, veljajo za vrednosti funkcije $u(x, y)$
tudi #emph[robni pogoji]:

$
  u(x, c) = f_s (x) \
  u(x, d) = f_z (x) \
  u(a, y) = f_l (y) \
  u(b, y) = f_d (y)\
$

kjer so $f_s, f_z, f_l$ in $f_d$ dane funkcije. Rešitev robnega
problema je tako odvisna od območja, kot tudi od robnih pogojev.

== Diskretizacija in linearni sistem enačb
<diskretizacija-in-linearni-sistem-enačb>
Problema se bomo lotili numerično, zato bomo vrednosti
$u(x, y)$ poiskali le v končno mnogo točkah: problem bomo
#link("https://en.wikipedia.org/wiki/Discretization")[diskretizirali]. 
Za diskretizacijo je najpreprosteje uporabiti enakomerno razporejeno pravokotno mrežo točk na pravokotniku. Točke na mreži imenujemo #emph[vozlišča]. Zaradi enostavnosti se omejimo na mreže z enakim razmikom v obeh koordinatnih smereh. Interval $[a, b]$
razdelimo na $n + 1$ delov, interval $[c, d]$ pa na $m + 1$ delov in dobimo zaporedje koordinat

$
  a = & x_0, & x_1, & dots & x_(n+1)=b\
  c = & y_0, & y_1, & dots & y_(m+1)=d,
$

ki definirajo pravokotno mrežo točk $(x_i, y_j)$. Namesto funkcije $u
: [a, b] times [c, d] arrow.r bb(R)$
tako iščemo le vrednosti

$ u_(i j) = u(x_i, y_j), #h(1em) i=1, dots n, #h(1em) j=1, dots m $

//#figure([#image("sosedi.png")], caption: [
// sosednja vozlišča
//])

Elemente matrike $u_(i j)$ določimo tako, da je v limiti, ko gre razmik med vozliči proti 
$0$, izpolnjena Laplaceova enačba @eq:Laplace. 

Laplaceovo enačbo lahko diskretiziramo s
#link("https://en.wikipedia.org/wiki/Finite_difference")[končnimi diferencami]. Lahko pa 
dobimo navdih pri arhitektu Frei Otto, ki je minimalne ploskve
#link("https://youtu.be/-IW7o25NmeA")[raziskoval z elastičnimi tkaninami]. Ploskev si 
predstavljamo kot elastično tkanino, ki je fina kvadratna mreža iz elastičnih nitk. Vsako vozlišče v mreži je povezano s 4 sosednjimi vozlišči. 

#figure(
  caption:[Sosednje vrednosti vozlišča $(i,j)$.])[
  #diagram(
    node((1, 0), $u_(i j-1)$),
    edge("d", "-"),
    node((0, 1), $u_(i-1 j)$),
    edge("-"),
    node((1, 1), $u_(i j)$),
    edge("-"),
    node((2, 1), $u_(i+1 j)$),
    node((1, 2), $u_(i j+1)$),
    edge("u", "-")
  )
]

Vozlišče bo v ravnovesju, ko bo vsota vseh sil nanj enaka 0. 

#figure(
  caption:[Sile elastik iz sosednjih vozlišč $(i-1, j)$ in $(i+1, j)$ na vozlišče $(i,j)$.])[
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
    content((x + 0.1, 0.5*y), [$bold(F)_1 prop u_(i-1 j) - u_(i j)$], anchor: "west")
    content((x - 0.1, 1.5*y), [$bold(F)_2 prop u_(i+1 j) - u_(i j)$], anchor: "east")
    content((-0.2, 0), [$u_(i-1 j)$], anchor: "east" )
    content((x + 0.2, y), [$u_(i j)$], anchor: "west" )
    content((2*x + 0.2, 2.5*y), [$u_(i+1 j)$], anchor: "west" )
  })
]

Predpostavimo, da so vozlišča povezana z idealnimi vzmetmi in je sila sorazmerna z vektorjem med položaji vozlišč. Če zapišemo enačbo za komponente sile v smeri $z$, dobimo za točko $(x_i, y_j, u_(i j))$ enačbo

$
  (u_(i-1 j) - u_(i j)) + (u_(i j-1) - u_(i j)) + (u_(i+1 j) - u_(i j)) + (u_(i j+1) - u_i(i, j)) &= 0\
  u_(i-1 j) + u_(i j-1) - 4u_(i j) + u_(i+1 j) + u_(i j+1) &= 0.
$ 

Za vsako vrednost $u_(i j)$ dobimo eno enačbo. Tako dobimo sistem linearnih $n dot m$ enačb za $n dot m$ neznank. Ker so vrednosti na robu določene z robnimi pogoji, moramo elemente $u_(0 j)$, $u_(n plus 1, j)$, $u_(i 0)$ in $u_(i m plus 1)$ prestaviti na desno stran in jih upoštevati kot konstante. 

== Matrika sistema linearnih enačb
<matrika-sistema-linearnih-enačb>
Sisteme linearnih enačb običajno zapišemo v matrični obliki

$ A bold(x) = bold(b), $

kjer je $A$ kvadratna matrika, $bold(x)$ in $bold(b)$ pa vektorja. Spremenljivke
$u_(i, j)$ razvrstimo po stolpcih v vektor $bold(x)$, tako da je 
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

#opomba(naslov: [Razvrstitev po stolpih in operator $vec$])[
Eden od načinov, kako lahko elemente matrike razvrstimo v vektor, je po stolpcih. Stolpce
matrike enega za drugim postavimo v vektor. Indeks v vektorju $k$ lahko
izrazimo z indeksi $i,j$ v matriki s formulo
$ k = i+(n-1)j. $ Ta način preoblikovanja matrike v vektor bomo označili s posebnim operatorjem $vec$:
$ 
vec: RR^(n times m) -> RR^(n dot m).
$ 
]

== Izpeljava sistema s Kronekerjevim produktom

Množenje vektorja $bold(x) = "vec"(U)$ z matriko $A$ lahko prestavimo kot
množenje matrike $U$ z matriko $L$ z leve in desne:   

$
  A "vec"(Z) = "vec"(L U + Z U),
$

kjer je $L$ Laplaceova matrika v eni dimenziji, ki ima $-2$ na diagonali in $1$ na spodnji pod-diagonali in zgornji nad-diagonali:

$
L = mat(
  -2, 1, 0, dots, 0;
  1, -2, 1, dots, dots.v;
  dots.v, dots.down, dots.down, dots.down, 0;
  0, dots, 1, -2, 1;
  0, dots, 0,  1, -2;
).
$

Res! Moženje matrike $U$ z matriko $L$ z leve je ekvivalentno množenju stolpcev matrike $U$ z matriko $L$, medtem ko je množenje z matriko $L$ z desne ekvivalentno množenju vrstic matrike $U$ z matriko $L$. Prispevek množenja z leve vsebuje vsoto sil sosednjih vozlišč v smeri $y$, medtem ko množenje z desne vsebuje vsoto sil sosednjih vozlišč v smeri $x$.

Ker velja $"vec"(A X B) = A times.circle B dot "vec"(X)$, lahko matriko $A$ zapišemo s #link("https://sl.wikipedia.org/wiki/Kroneckerjev_produkt")[Kronekerjevim produktom] $times.circle$ matrik $L$ in $I$:

$
  A dot "vec"(U) &= "vec"(L U + U L) = "vec"(L U I + I U L) \
  A^(N, N) &= L^(m, m) times.circle I^(n, n) + I^(m, m) times.circle L^(n, n).
$

#opomba(naslov:[Kroneckerjev produkt in operator $vec$ v Juliji])[
Programski jezik Julia ima vgrajene funkcije `vec` in `kron` za preoblikovanje matrik v vektorje in računanje Kronekerjevega produkta. Z ukazom `reshape` pa lahko iz vektorja 
znova zgradimo matriko.
]

== Primer
<primer>
```julia robni_problem = RobniProblemPravokotnik( LaplaceovOperator{2}, ((0,
pi), (0, pi)), [sin, y->0, sin, y->0] ) Z, x, y = resi(robni_problem) surface(x,
y, Z) savefig("milnica.png") ```

// #figure([#image("milnica.png")], caption: [
// minimalna ploskev
//])

== Napolnitev matrike ob eliminaciji
<napolnitev-matrike-ob-eliminaciji>
Matrika Laplaceovega operatorja ima veliko ničelnih elementov. Takim matrikam
pravimo
#link(
  "https://sl.wikipedia.org/wiki/Redka_matrika",
)[razpršene ali redke matrike]. Razpršenost matirke lahko izkoristimo za
prihranek prostora in časa, kot smo že videli pri
#link("02_tridiagonalni_sistemi.md")[tridiagonalnih matrikah]. Vendar se pri
Gaussovi eliminaciji delež ničelnih elementov matrike pogosto zmanjša. Poglejmo
kako se odreže matrika za Laplaceov operator.

```julia using Plots L = matrika(100,100, LaplaceovOperator(2)) spy(sparse(L),
seriescolor = :blues) ```

//#figure([#image("laplaceova_matrika.png")], caption: [
// Redka struktura Laplaceove matrike
//])

Če izvedemo eliminacijo, se matrika deloma napolni z neničelnimi elementi:

```julia import LinearAlgebra.lu LU = lu(L) spy!(sparse(LU.L), seriescolor =
:blues) spy!(sparse(LU.U), seriescolor = :blues) ```

//#figure([#image("lu_laplaceove_matrike.png")], caption: [
// Napolnitev ob razcepu
//])

== Koda
<koda>
```@index Pages = ["03_minimalne_ploskve.md"] ```

```@autodocs Modules = [NumMat] Pages = ["Laplace2D.jl"]```

== Iteracijske metode <iteracijske-metode>
```@meta
CurrentModule = NumMat
DocTestSetup  = quote
    using NumMat
end
```

V #link("03_minimalne_ploskve.md")[nalogi o minimalnih ploskvah] smo reševali
linearen sistem enačb

```math
u_{i,j-1}+u_{i-1,j}-4u_{ij}+u_{i+1,j}+u_{i,j+1}=0
```

za elemente matrike $U = lr([u_(i j)])$, ki predstavlja višinske vrednosti na
minimalni ploskvi v vozliščih kvadratne mreže. Največ težav smo imeli z zapisom
matrike sistema in desnih strani. Poleg tega je matrika sistema $L$ razpršena
\(ima veliko ničel), ko izvedemo LU razcep ali Gaussovo eliminacijo, veliko teh
ničelnih elementov postane neničelni in matrika se napolni. Pri razpršenih
matrikah tako pogosto uporabimo
#link(
  "https://en.wikipedia.org/wiki/Iterative_method#Linear_systems",
)[iterativne metode]
za reševanje sistemov enačb, pri katerih matrika ostane razpršena in tako lahko
prihranimo veliko na prostorski in časovni zahtevnosti.

!!! note "Ideja iteracijskih metod je preprosta"

```
Enačbe preuredimo tako, da ostane na eni strani le en element s koeficientom 1. Tako dobimo iteracijsko formulo za zaporedje približkov $u_{ij}^{(k)}$. Limita rekurzivnega zaporedja je ena od fiksnih točk rekurzivne enačbo, če zaporedje konvergira. Ker smo rekurzivno enačbo izpeljali iz originalnih enačb, je njena fiksna točka ravno rešitev originalnega sistema.
```

V primeru enačb za laplaceovo enačbo\(minimalne ploskve), tako dobimo rekurzivne
enačbe

```math
u_{ij}^{(k+1)} = \frac{1}{4}\left(u_{i,j-1}^{(k)}+u_{i-1,j}^{(k)}+u_{i+1,j}^{(k)}+u_{i,j+1}^{(k)}\right),
```

ki ustrezajo
#link("https://en.wikipedia.org/wiki/Jacobi_method")[jacobijevi iteraciji]

!!! tip "Pogoji konvergence"

```
Rekli boste, to je preveč enostavno, če enačbe le pruredimo in se potem rešitel kar sama pojavi, če le dovolj dolgo računamo. Gotovo se nekje skriva kak hakelc. Res je! Težave se pojavijo, če zaporedje približkov **ne konvergira dovolj hitro** ali pa sploh ne. Jakobijeva, Gauss-Seidlova in SOR iteracija **ne konvergirajo vedno**, zagotovo pa konvergirajo, če je matrika po vrsticah [diagonalno dominantna](https://sl.wikipedia.org/wiki/Diagonalno_dominantna_matrika).
```

Konvergenco jacobijeve iteracije lahko izboljšamo, če namesto vrednosti na
prejšnjem približku, uporabimo nove vrednosti, ki so bile že izračunani. Če
računamo element $u_(i j)$ po leksikografskem vrstnem redu, bodo elementi $u_(i l)^(lr((k plus 1)))$ za $l lt j$ in
$u_(l j)^(lr((k plus 1)))$ za $l lt i$ že na novo izračunani, ko računamo $u_(i j)^(lr((k plus 1)))$.
Če jih upobimo v iteracijski formuli, dobimo
#link(
  "https://en.wikipedia.org/wiki/Gauss%E2%80%93Seidel_method",
)[gauss-seidlovo iteracijo]

$
  u_(i,j)^((k+1)) = 1/4(u_(i,j-1)^((k+1))+ u_(i-1,j)^((k))+u_(i+1,j)^((k))+u_(i,j+1)^((k)))
$

Konvergenco še izboljšamo, če približek $u_(i j)^(lr((k plus 1)))$, ki ga dobimo
z gauss-seidlovo metodo, malce zmešamo s približkom na prejšnjem koraku $u_(i j)^(lr((k)))$

$
  u_(i,j)^(("GS")) &= 1/4(u_(i,j-1)^((k+1))+ u_(i-1,j)^((k))+u_(i+1,j)^((k))+u_(i,j+1)^((k)))\
  u_(i, j)^((k+1)) &= omega u_(i, j)^(("GS")) + (1 - omega) u_(i, j)^((k))
$

in dobimo
#link("https://en.wikipedia.org/wiki/Successive_over-relaxation")[metodo SOR].
Parameter $omega$ je lahko poljubno število
$paren.l 0, 2 bracket.r$ Pri $omega = 1$ dobimo Gauss-Seidlovo iteracijo.

=== Primer
<primer>
```julia
using Plots
U0 = zeros(20, 20)
x = LinRange(0, pi, 20)
U0[1,:] = sin.(x)
U0[end,:] = sin.(x)
surface(x, x, U0, title="Začetni približek za iteracijo")
savefig("zacetni_priblizek.png")
```

//#figure([#image("zacetni_priblizek.png")], caption: [
//  začetni priblizek za iteracijo
//])

```julia
L = LaplaceovOperator(2)
U = copy(U0)
animation = Animation()
for i=1:200
    U = korak_sor(L, U)
    surface(x, x, U, title="Konvergenca Gauss-Seidlove iteracije")
    frame(animation)
end
mp4(animation, "konvergenca.mp4", fps = 10)
```

`@raw html <video width="600" height="400" controls> <source src="../konvergenca.mp4" type="video/mp4"> <source src="konvergenca.mp4" type="video/mp4"> </video>`

#link("konvergenca.mp4")[Konvergenca Gauss-Seidlove iteracije]

=== Konvergenca
<konvergenca>
Grafično predstavi konvergenco v odvisnoti od izbire $omega$.

```julia
using Plots
n = 50
U = zeros(n,n)
U[:,1] = sin.(LinRange(0, pi, n))
U[:, end] = U[:, 1]
L = LaplaceovOperator(2)
omega = LinRange(0.1, 1.95, 40)
it = [iteracija(x->korak_sor(L, x, om), U; tol=1e-3)[2] for om in omega]
plot(omega, it, title = "Konvergenca SOR v odvisnosti od omega")
savefig("sor_konvergenca.svg")
```

//#figure([#image("sor_konvergenca.svg")], caption: [
//  Konvergenca SOR v odvisnosti od omega
//])

=== Metoda konjugiranih gradientov
<metoda-konjugiranih-gradientov>
Ker je laplaceova matrika diagonalno dominantna z $minus 4$ na diagonali je
negativno definitna. Zato lahko uporabimo
#link(
  "https://en.wikipedia.org/wiki/Conjugate_gradient_method",
)[metodo konjugiranih gradientov]. Algoritem konjugiranih gradientov potrebuje
le množenje z laplaceovo matriko, ne pa tudi samih elementov. Zato lahko
izkoristimo možnosti, ki jih ponuja programski jezik `julia`, da lahko za
#link(
  "https://docs.julialang.org/en/v1.0/manual/methods/",
)[isto funkcijo napišemo različne metode za različne tipe argumentov].

Preprosto napišemo novo metodo za množenje #link("@ref")[`*`], ki sprejme
argumente tipa
#link("@ref%20LaplaceovOperator")[`LaplaceovOperator{2}`] in `Matrix`. Metoda
konjugiranih gradientov še hitreje konvergira kot SOR.

```@example
using NumMat
n = 50
U = zeros(n,n)
U[:,1] = sin.(LinRange(0, pi, n))
U[:, end] = U[:, 1]
L = LaplaceovOperator{2}()
b = desne_strani(L, U)
Z, it = conjgrad(L, b, zeros(n, n))
println("Število korakov: $it")
```
