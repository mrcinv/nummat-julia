= Interpolacija z implicitnimi funkcijami
<interpolacija-z-implicitnimi-funkcijami>

Implicitne enačbe oblike $F(x_1, x_2, dots) = 0$ so dober način za opis krivulj in ploskev. Hitri algoritmi za izračun nivojskih krivulj in ploskev kot sta #link("https://en.wikipedia.org/wiki/Marching_cubes")[sprehod po kockah] in #link("https://en.wikipedia.org/wiki/Marching_squares")[sprehod po kvadratih] omogočajo učinkovito predstavitev implicitno podanih ploskev in krivulj s poligonsko mrežo. V tej vaji bomo spoznali, kako poiskati implicitno krivuljo ali ploskev, ki dobro opiše dani oblak točk v ravnini ali prostoru.

== Naloga

- Definiraj podatkovni tip za linearno kombinacijo radialnih baznih funkcij (RBF), ki 
  vsebuje središča RBF $bold(x)_i$ in koeficiente $a_i$ v linearni kombinaciji
  $ F(bold(x)) = sum_(i=1)^n a_i phi(||bold(x) - bold(x_i)||). $
- Napiši sistem za koeficiente v linearni kombinaciji RBF, če so podane
  vrednosti $z_i=F(bold(x_i))$ v središčih RBF. Napiši funkcijo, ki za dane vrednosti $z_i$
  in centre $bold(x_i)$ poišče koeficiente $a_1, a_2 dots a_n$. Katero metodo za reševanja sistema lahko uporabimo?
- Napiši funkcijo `vrednost`, ki izračuna vrednost funkcije $F$ v dani točki. 


== Interpolacija z radialnimi baznimi funkcijami

#link("https://en.wikipedia.org/wiki/Radial_basis_function")[Radialne bazne funkcije \(RBF)] so funkcije, katerih vrednosti so odvisne od razdalje do izhodiščne točke

$ f(bold(x)) = phi lr((parallel bold(x) - bold(x)_0 parallel)) $

Uporabljajo se za interpolacijo ali aproksimacijo s funkcijo oblike

$ sum_i w_i phi lr((parallel bold(x) - bold(x)_i parallel)) , $

npr. za rekonstrukcijo 2D in 3D oblik v računalniški grafiki. Funkcija
$phi$ je navadno pozitivna soda funkcija zvončaste oblike in jo
imenujemo funkcija oblike.

Podan je 2D ali 3D oblak točk
$brace.l bold(x)_1 , dots.h bold(x)_n brace.r$ in realne vrednosti
$brace.l f_1 , dots.h , f_n brace.r$. Napiši funkcijo, ki
interpolira omenjene podatke s funkcijo oblike

$ F lr((bold(x))) eq sum_i w_i phi lr((parallel bold(x) - bold(x)_i parallel)) dot.basic $

To pomeni, da poiščeš vrednosti uteži $w_i$ tako, da bodo izpolnjene
enačbe $ F lr((bold(x_i))) eq f_i dot.basic $

== Naloga
<naloga>
Napiši dve funkciji:

- `w = koeficienti_rbf(phi, x0, f)`, ki poišče vrednosti uteži, če so
  podane funkcija oblike `phi`, oblak točk podan z matriko `x0` in
  tabela vrednosti `f`.
- `z = vrednost_rbf(x, w, x0)`, ki izračuna vrednost
  $ F lr((bold(x))) sum_i w_i phi lr((parallel bold(x) - bold(x)_i parallel)) $
  za argument `x`, pri čemer je `w` vektor uteži $w_i$, `x0` pa oblak
  točk, podan kot matrika.

Funkciji uporabi za interpolacijo točk v ravnini z implicitno podano
krivuljo, kot v naslednjem primeru:

```julia
using Plots
fi = range(0, 2π, length=6)
tocke = [2(1-cos(t)).*(cos(t), sin(t)) for t in fi]
scatter(tocke)
f(x,y) = (x^2 + y^2)^2 + 4x*(x^2 + y^2) - 4y^2
x = y = range(-4, 4, length = 100)
contour!(x, y, f, levels = [0])
```

Točke ležijo na nivojnici funkcije
$f lr((x , y)) eq lr((x^2 plus y^2))^2 plus 4 x lr((x^2 plus y^2)) - 4 y^2$
za nivo $f lr((x , y)) eq 0$.

== Opis krivulj z implicitno interpolacijo
<opis-krivulj-z-implicitno-interpolacijo>
Iz množice točk želimo rekonstruirati krivuljo, ki gre skozi te točke.
Krivulje v ravnini lahko opišemo na različne načine

+ #strong[eksplicitno]: $y eq f lr((x))$
+ #strong[parametrično]:
  $lr((x , y)) eq lr((x lr((t)) , y lr((t))))$
+ #strong[implicitno] z enačbo $F lr((x , y)) eq 0$

Tokrat se bomo posvetili implicitni predstavitvi krivulje.

== Problem
<problem>
Imamo točke v ravnini s koordinatami
$lr((x_1 , y_1)) , lr((x_2 , y_2)) , dots.h , lr((x_n , y_n))$.
Iščemo krivuljo, ki gre skozi vse točke. Po možnosti naj bo krivulja
gladka, poleg tega ni nujno, da do zaporedne točke v seznamu, tudi
zaporedne točke na krivulji. Krivuljo iščemo v #strong[implicitni]
obliki, torej v obliki enačbe

$ F lr((x , y)) eq 0 dot.basic $

Iskano krivuljo bomo zapisali kot ničto nivojnico neke funkcije
$F lr((x , y))$. Iščemo torej funkcijo $F lr((x , y))$, za
katero velja

$ F lr((x_i , y_i)) eq 0 quad i lt.eq n dot.basic $

Ta pogoj žal ne zadošča. Dodamo moramo še nekaj točk, ki so znotraj
območja omejenega s krivuljo. Označimo jih z
$lr((x_(n plus 1) , y_(n plus 1))) , dots.h , lr((x_m , y_m))$,
v katerih predpišemo vrednost $1$

$ F lr((x_i , y_i)) eq 1 quad i gt.eq n plus 1 dot.basic $

== Naloga
<naloga-1>
Napiši program, ki za dane točke poišče interpolacijsko funkcijo oblike

$ F lr((bold(x))) eq sum_i d_i phi.alt lr((bold(x) - bold(x)_i)) plus P lr((bold(x))) , $

kjer so

- $bold(x) eq lr((x , y))$
- $P lr((bold(x)))$ polinom stopnje 1 \(linearna funkcija v $x$ in $y$)
- $d_i$ primerno izbrane uteži.
- $phi.alt$ radialna bazna funkcija, ki je odvisna zgolj od razdalje do
  #emph[i]-te točke $r eq parallel bold(x) - bold(x)_i parallel$.
  - \"thin plate\": $phi.alt lr((r)) eq lr(|r|)^2 log lr((lr(|r|)))$ za
    2D in $phi.alt lr((r)) eq lr(|r|)^3$ za 3D
  - Gaussova: $phi.alt lr((r)) eq exp lr((- r^2 slash sigma^2))$
  - racionalni približek za Gaussovo

$ phi.alt lr((r)) eq frac(1, 1 plus r^(2 p)) $

=== Časovna in prostorska zahtevnost
<časovna-in-prostorska-zahtevnost>
- zgraditev matrike: $cal(O) lr((n^2))$
- rešitev sistema: $cal(O) lr((lr((n^2))))$, če uporabimo iteracijske
  metode
- računanje vrednosti funkcije: $cal(O) lr((n))$

== RBF s kompaktnim nosilcem
<rbf-s-kompaktnim-nosilcem>
Matrika sistema, če uporabimo klasične RBF iz prejšnjega razdelka je
polna. Čeprav je večina členov izven diagonale zelo majhnih npr. pri
gaussovi RBF. Zato so \[Morse et. all\]\@ref\(Povezave) prišli na idejo,
da uporabijo RBF s kompaktnim nosilcem. V tem primeru je matrika precej
bolj redka in se tako prostorska kot tudi časovna zahtevnost algoritmov
bistveno zmanjšata.

== Povezave
<povezave>
- Savchenko V. V., Pasko, A. A., Okunev, O. G. and Kunii T. L.
  #emph[Function representation of solids reconstructed from scattered
  surface points and contours], Computer Graphics Forum 14\(4)
  \(1995),#link("http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.48.80&rep=rep1&type=pdf")[pdf]
- G. Turk and J. O\'Brien, #emph[Variational Implicit Surfaces],
  Technical Report GIT-GVU-99-15, Georgia Institute of Tech-nology,
  1998.#link("https://pdfs.semanticscholar.org/a44c/d6b3c709e69f8194fcc2513394ddc410d9be.pdf")[pdf]
- Morse, B. S., Yoo, T. S., Rheingans, P., et al. Interpolating implicit
  surfaces from scattered surface data using compactly supported radial
  basis functions, SMI 2001 International Conference on Shape Modeling
  and Applications, Genova Italy, \(2001)
  #link("https://www.cs.jhu.edu/~misha/Fall13b/Papers/Morse01.pdf")[pdf]
- Predstavitev s #link("https://en.wikipedia.org/wiki/Signed_distance_function")[predznačeno funkcijo razdalje]