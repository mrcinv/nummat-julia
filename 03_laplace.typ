#import "admonitions.typ": opomba

= Minimalne ploskve 
<minimalne-ploskve-laplaceova-enačba>
== Naloga
<naloga>
Žično zanko s pravokotnim tlorisom potopimo v milnico, tako da se nanjo napne
milna opna.

Radi bi poiskali obliko milne opne, razpete na žični zanki. Malo brskanja po
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
  caption: [Slika #link(
      "https://de.wikipedia.org/wiki/Olympiastadion_M%C3%BCnchen#/media/File:Olympic_Stadium_Munich_Dachbegehung.JPG",
    )[olimpijskega stadiona v Münchnu].],
)


== Matematično ozadje
<matematično-ozadje>
Ploskev lahko predstavimo s funkcijo dveh spremenljivk
$u lr((x comma y))$, ki predstavlja višino ploskve nad točko
$lr((x comma y))$. Naša naloga bo poiskati funkcijo $u lr((x comma y))$
na tlorisu žične mreže.

Funkcija $u lr((x comma y))$, ki opisuje milno opno, zadošča matematična enačbi,
znani pod imenom
#link(
  "https://sl.wikipedia.org/wiki/Poissonova_ena%C4%8Dba",
)[Poissonova enačba]

$
  Delta u(x,y)= rho(x, y)
$ <eq:Poisson>

Funkcija $rho(x, y)$ je sorazmerna tlačni razliki med zunanjo in notranjo
površino milne opne. Tlačna razlika je lahko posledica višjega tlaka v
notranjosti milnega mehurčka ali pa teže, v primeru opne, napete na žični zanki.
V primeru minimalnih ploskev pa tlačno razliko kar zanemarimo in dobimo
#link(
  "https://en.wikipedia.org/wiki/Laplace%27s_equation",
)[Laplaceovo enačbo]:

$
  Delta u lr((x comma y)) eq 0 dot.basic
$

Če predpostavimo, da je oblika na robu območja določena z obliko zanke, rešujemo
#link("https://en.wikipedia.org/wiki/Boundary_value_problem")[robni problem]
za Laplaceovo enačbo. Predpostavimo, da je območje pravokotnik
$[a comma b] times [c comma d]$. Poleg Laplacove enačbe, veljajo za vrednosti
funkcije $u lr((x comma y))$ tudi #emph[robni pogoji]:

$
  u(x, c) = f_s (x) \
  u(x, d) = f_z (x) \
  u(a, y) = f_l (y) \
  u(b, y) = f_d (y)\
$

kjer so $f_s comma f_z comma f_l$ in $f_d$ dane funkcije. Rešitev robnega
problema je tako odvisna od območja, kot tudi od robnih pogojev.

Za numerično rešitev Laplaceove enačbe za minimalno ploskev dobimo navdih pri
arhitektu Frei Otto, ki je minimalne ploskve
#link(
  "https://youtu.be/-IW7o25NmeA",
)[raziskoval tudi z elastičnimi tkaninami].

== Diskretizacija in linearni sistem enačb
<diskretizacija-in-linearni-sistem-enačb>
Problema se bomo lotili numerično, zato bomo vrednosti
$u lr((x comma y))$ poiskali le v končno mnogo točkah: problem bomo
#emph[diskretizirali]. Za diskretizacijo je najpreprosteje uporabiti enakomerno
razporejeno pravokotno mrežo točk na pravokotniku. Točke na mreži imenujemo
#emph[vozlišča]. Zaradi enostavnosti se omejimo na mreže z enakim razmikom v
obeh koordinatnih smereh. Interval $[a, b])$ razdelimo na $n + 1$ delov,
interval $[c, d]$ pa na $m + 1$ delov in dobimo zaporedje koordinat

$
  a = & x_0, & x_1, & dots & x_(n+1)=b\
  c = & y_0, & y_1, & dots & y_(m+1)=d
$

ki definirajo pravokotno mrežo točk $lr((x_i comma y_j))$. Namesto funkcije $u
colon lr([a comma b]) times lr([c comma d]) arrow.r bb(R)$
tako iščemo le vrednosti

$ u_(i, j) = u(x_i, y_j), #h(1em) i=1, dots n, #h(1em) j=1, dots m $

//#figure([#image("sosedi.png")], caption: [
// sosednja vozlišča
//])

Iščemo torej enačbe, ki jim zadoščajo elementi matrike $u_(i, j)$. Laplaceovo
enačbo lahko diskretiziramo z
#link(
  "https://en.wikipedia.org/wiki/Finite_difference",
)[končnimi diferencami], lahko pa izpeljemo enačbe, če si ploskev predstavljamo
kot elastično tkanino, ki je fina kvadratna mreža iz elastičnih nitk. Vsako
vozlišče v mreži je povezano s 4 sosednjimi vozlišči. Vozlišče bo v ravnovesju,
ko bo vsota vseh sil nanj enaka 0. Predpostavimo, da so vozlišča povezana z
idealnimi vzmetmi in je sila sorazmerna z razliko. Če zapišemo enačbo za
komponente sile v smeri $z$, dobimo za točko
$lr((x_i comma y_j comma u_(i j)))$ enačbo

$
  u_(i-1,j) + u_(i,j-1) - 4u_(i,j) + u_(i+1,j) + u_(i,j+1) = 0.
$ 

Za $u_(i j)$ imamo tako sistem linearnih enačb. Ker pa so vrednotsi na robu
določene z robnimi pogoji, moramo elemente $u_(0 j)$,
$u_(n plus 1 comma j)$, $u_(i 0)$ in $u_(i m plus 1)$ prestaviti na desno stran
in jih upoštevati kot konstante.

== Matrika sistema linearnih enačb
<matrika-sistema-linearnih-enačb>
Sisteme linearnih enačb običajno zapišemo v matrični obliki

$ A bold(x) = bold(b), $

kjer je $A$ kvadratna matrika, $bold(x)$ in $bold(b)$ pa vektorja. Spremenljivke
$u_(i, j)$ razvrstimo po stolpcih v vektor.

!!! note "Razvrstitev po stolpih"

``` Eden od načinov, kako lahko elemente matrike razvrstimo v vektor, je, da
stolpce matrike enega za drugim postavimo v vektor. Indeks v vektorju $k$ lahko
izrazimo z indeksi $i,j$ v matriki s formulo
$$k = i+(n-1)j.$$
```

Za $n eq m eq 3$ dobimo $9 times 9$ matriko

```math L = \begin{bmatrix} -4& 1& 0& 1& 0& 0& 0& 0& 0\\ 1& -4& 1& 0& 1& 0& 0&
0& 0\\ 0& 1& -4& 0& 0& 1& 0& 0& 0\\ 1& 0& 0& -4& 1& 0& 1& 0& 0\\ 0& 1& 0& 1& -4&
1& 0& 1& 0\\ 0& 0& 1& 0& 1& -4& 0& 0& 1\\ 0& 0& 0& 1& 0& 0& -4& 1& 0\\ 0& 0& 0&
0& 1& 0& 1& -4& 1\\ 0& 0& 0& 0& 0& 1& 0& 1& -4\\ \end{bmatrix}, ```

ki je sestavljena iz $3 times 3$ blokov

```math \begin{bmatrix}-4&1&0\cr 1&-4&1\cr 0&1&-4\end{bmatrix},\quad
\begin{bmatrix}1&0&0\cr 0&1&0\cr 0&0&1\end{bmatrix}. ```

desne strani pa so

```math \mathbf{b} = -[u_{01}+u_{10}, u_{20}, \ldots u_{n0}+u_{n+1,1},u_{02},
0,\ldots u_{n+1,2}, u_{03}, 0\ldots u_{n, m+1},u_{n,m+1}+u_{n+1,m}]^T. ```

== Izpeljava s Kronekerjevim produktom

Množenje vektorja $bold(x) = "vec"(Z)$ z matriko $L$ lahko prestavimo kot
množenje z matriko

$
  "vec"(L Z + Z L) = L "vec"(Z).
$

Ker velja $"vec"(A X B) = A times.circle B dot "vec"(X)$ je

$
  L^(N, N) = L^(m, m) times.circle I^(n, n) + I^(m, m) times.circle L^(n, n)
$

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

za elemente matrike $U eq lr([u_(i j)])$, ki predstavlja višinske vrednosti na
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
$paren.l 0 comma 2 bracket.r$ Pri $omega eq 1$ dobimo gauss-seidlovo iteracijo.

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
