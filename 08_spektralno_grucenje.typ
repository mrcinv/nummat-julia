#import "admonitions.typ": opomba
#import "julia.typ": jl, jlfb, code_box
= Spektralno razvrščanje v gruče
<spektralno-razvrščanje-v-gruče>

== Naloga


Pokazali bomo metodo razvrščanja v gruče, ki uporabi spektralno analizo
Laplaceove matrike podobnostnega grafa, tako da podatke
preslika v prostor, kjer jih je lažje razvrstiti.
- Napiši funkcijo, ki zgradi podobnostni graf za dane podatke. Podatki so dani kot oblak točk v 
  $RR^d$. V podobnostnem grafu je vsak točka v oblaku vozlišče, s točko $k$ pa povežemo vse točke, 
  ki ležijo v $epsilon$ okolici te točke za primerno izbrani $epsilon$.
- Napiši funkcijo, ki za dano simetrično matriko poišče najmanjših $k$ lastnih parov. 
  Če inverzno iteracijo uporabimo na $n times k$ matriki približkov in s 
  QR razcepom poskrbimo, da so stolpci ortogonalni, potem faktor $Q$ konvergira k lastnim vektorjem, 
  diagonala faktorja $R$ pa k $k$ najmanjšim lastnim vrednostim matrike.
- Funkcijo za iskanje lastnih vektorjev uporabi za Laplaceovo matriko podobnostnega grafa podatkov.
  Za primer podatkov naključno generiraj mešanico 3 Gaussovih porazdelitev.
  Komponente lastnih vektorjev uporabi kot nove koordinate in podatke predstavi v novih koordinatah. 

== Podobnostni graf in Laplaceova matrika
<podobnostni-graf-in-laplaceova-matrika>
Podatke (množico točk v $RR^n$) želimo razvrstiti v več gruč.
Najprej ustvarimo #emph[podobnostni uteženi graf], ki povezuje točke, ki
so si v nekem smislu blizu. Podobnostni graf lahko ustvarimo na več
načinov:

- #strong[$ε$-okolice]: s točko $x_k$ povežemo vse točke, ki ležijo v
  ε-okolici te točke
- #strong[$k$ najbližji sosedi]: $x_k$ povežemo z $x_i$, če je
  $x_i$ med $k$ najbližjimi točkami. Tako dobimo usmerjen graf,
  zato ponavadi upoštevmo povezavo v obe smeri.
- #strong[poln utežen graf]: povežemo vse točke, vendar povezave utežimo
  glede na razdaljo. Pogosto uporabljena utež je nam znana
  #link("https://en.wikipedia.org/wiki/Radial_basis_function")[radialna bazna funkcija]:

  $ w(x_i , x_k) = exp (-(parallel x_i - x_k parallel^2)/(2 sigma^2)) $

  pri kateri s parametrom $sigma$ lahko določamo velikost okolic.

Grafu podobnosti priredimo matriko uteži

$ W = [w_(i j)], $

in #link("https://sl.wikipedia.org/wiki/Laplaceova_matrika")[Laplaceovo matriko]

$ L = D - W, $

kjer je $D = [d_(i j)]$ diagonalna matrika z elementi
$d_(i i) = sum_(j=.not i) w_(i j)$. Laplaceova matrika $L$ je simetrična,
nenegativno definitna in ima vedno eno lastno vrednost $0$ za lastni
vektor iz samih enic.

== Algoritem
<algoritem>
Velja naslednji izrek, da ima Laplaceova matrika natanko toliko lastnih
vektorjev za lastno vrednost 0, kot ima graf komponent za povezanost. Na
prvi pogled se zdi, da bi lahko bile komponente kar naše gruče, a se
izkaže, da to ni najbolje.

- Poiščemo $k$ najmanjših lastnih vrednosti za Laplaceovo matriko
  in izračunamo njihove lastne vektorje.
- Označimo matriko lastnih vektorjev $Q=[v_1, v_2, dots,v_k]$. Stolpci
  $Q^T$ ustrezajo koordinatam točk v novem prostoru.
- Za stolpce matrike $Q^T$ izvedemo nek drug algoritem gručenja
  (npr. algoritem $k$ povprečij).

#opomba(naslov: [Algoritem $k$ povprečij])[

Izberemo si število gruč $k$. Najprej točke naključno razdelimo v $k$ gruč. 
Nato naslednji postopek ponavljamo, dokler se rezultat ne spreminja več
- izračunamo center posamezne gruče $bold(c)_i= 1/(|G_i|)sum_(j in G_i) bold(x)_i$,
- vsako točko razvrstimo v gručo, ki ima najbližji center.

]

== Primer
<primer>
Algoritem preverimo na mešanici treh Gaussovih porazdelitev

```julia
using Plots
using Random
m = 100;
Random.seed!(12)
x = [1 .+ randn(m, 1); -3 .+ randn(m,1); randn(m,1)];
y = [-2 .+ randn(m, 1); -1 .+ randn(m,1); 1 .+ randn(m,1)];
scatter(x, y, title="Oblak točk v ravnini")
savefig("06_oblak.png")
```

#figure([],
  caption: [
    Oblak točk
  ]
)

Izračunamo graf sosednosti z metodo $epsilon$-okolic in poiščemo
laplaceovo matriko dobljenega grafa.

```julia
using SparseArrays
tocke = [(x[i], y[i]) for i=1:3*m]
r = 0.9
G = graf_eps_okolice(tocke, r)
L = LaplaceovaMatrika(G)
spy(sparse(Matrix(L)), title="Porazdelitev neničelnih elementov v laplaceovi matriki")
savefig("06_laplaceova_matrika_grafa.png")
```

#figure([],
  caption: [
    Neničelni elementi Laplaceove matrike
  ]
)

Če izračunamo lastne vektorje in vrednosti laplaceove matrike dobljenega
grafa, dobimo 4 najmanjše lastne vrednosti, ki očitno odstopajo od
ostalih.

```julia
import LinearAlgebra.eigen
razcep = eigen(Matrix(L))
scatter(razcep.values[1:20], title="Prvih 20 lastnih vrednosti laplaceove matrike")
savefig("06_lastne_vrednosti.png")
```

#figure([],
  caption: [
    Lastne vrednosti laplaceove matrike
  ]
)

```julia
scatter(razcep.vectors[:,4], razcep.vectors[:,5], title="Vložitev s komponentami 4. in 5. lastnega vektorja")
savefig("06_vlozitev.png")
```

#figure([],
  caption: [
    Vložitev točk v nov prostor
  ]
)

== Inverzna potenčna metoda
<inverzna-potenčna-metoda>
Ker nas zanima le najmanjših nekaj lastnih vrednosti, lahko njihov
izračun in za izračun lastnih vektrojev uporabimo
#link("https://en.wikipedia.org/wiki/Inverse_iteration")[inverzno potenčno metodo].
Pri inverzni potenčni metodi zgradimo zaporedje približkov z rekurzivno
formulo

$ bold(x)^(lr((k + 1))) = frac(A^(- 1) bold(x)^(lr((n))), parallel A^(- 1) bold(x)^(lr((n))) parallel) $

in zaporedje približkov konvergira k lastnemu vektorju za najmanjšo
lastno vrednost matrike $A$.

#opomba(naslov:
[Namesto inverza uporabite LU razcep ali drugo metodo za reševanje linearnega sistema])[
 Računanje inverza je časovno zelo zahtevna operacija, zato se ji, razen v nizkih dimenzijah,
 če je le mogoče izognemo. V večini primerov ne potrebujemo inverzne matrike $A^(-1)$, ampak le 
 produkt inverzne matrike z vektorjem ali drugo matriko $A^(-1)bold(b)$. Produkt
 $bold(x) = A^(-1)bold(b)$ je rešitev linearnega sistema $A bold(x) = bold(b)$ in metode za
 reševanje sistema so bolj učinkovite kot računanje inverza $A^(-1)$.
 
 Inverz $A^(-1)$ matrike $A$ lahko nadomestimo z razcepom matrike $A$.
 Če na primer uporabimo LU razcep $A=L U$, lahko $A^(-1) bold(b)$ izračunamo tako, da rešimo 
 sistem $A bold(x) = bold(b)$ oziroma $L U bold(x) = bold(b)$ v dveh korakih

 $
 L bold(y)& = bold(b)\
 U bold(x)& = bold(y),
 $

 ki sta časovno toliko zahtevna, kot je množenje z matriko $A^(-1)$. 
 Programski jezik `julia` ima za ta namen prav posebno metodo 
 #link("https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/index.html#LinearAlgebra.factorize")[factorize], ki za različne vrste matrik, izračuna najbolj primeren razcep.
]

Laplaceova matrika je simetrična, zato so lastni vektorji ortogonalni.
Lastne vektorje lahko tako poiščemo tako, da iteracijo izvajamo na več
vektorjih hkrati in nato na dobljeni bazi izvedemo ortogonalizacijo s QR
razcepom, da zaporedje lastnih vektorjev za lastne vrednosti, ki so
najbližje najmanjši lastni vrednosti.

Laplaceova matrika grafa je simetrična in negativno semi definitna.
Poleg tega je zelo veliko elementov enakih 0. Zato za rešitev sistema
uporabimo iterativno metodo
#link("https://en.wikipedia.org/wiki/Conjugate_gradient_method")[konjugiranih gradientov].
Za uporabo metode konjugiranih gradientov zadošča, da učinkovito
izračunamo množenje matrike z vektorjem. Težava je, ker ima Laplaceova
matrika grafa tudi lastno vrednost $0$, zato metoda konjugiranih gradientov ne
konvergira. Težavo lahko rešimo s premikom. Namesto, da računamo lastne
vrednosti in vektorje matrike $L$, iščemo lastne vrednosti in vektorje
malce premaknjene matrike $L + epsilon I$, ki ima enake lastne
vektorje, kot $L$.

#opomba()[
Programski jezik julia omogoča polimorfizem v obliki 
#link("https://docs.julialang.org/en/v1/manual/methods/index.html")[večlične
dodelitve]. Tako
lahko za isto funkcijo definiramo različne metode. Za razliko od polmorfizma
v objektno orientiranih jezikih, se metoda izbere ne le na podlagi tipa
objekta, ki to metodo kliče, ampak na podlagi tipov vseh vhodnih argumentov.
To lastnost lahko s pridom uporabimo, da lahko pišemo generično kodo, ki
deluje za veliko različnih vhodnih argumentov. Primer je funkcija
#jl("conjgrad"), ki jo lahko uporabimo tako za polne matrike, matrike tipa
`SparseArray` ali pa tipa `LaplaceovaMatrika` za katerega smo posebej
definirali operator množenja #jl("*").
]

$ L bold(x^(lr((k + 1)))) = bold(x^(lr((k)))) $

Primerjajmo inverzno potenčno metodo z vgrajeno metodo za iskanje
lastnih vrednosti s polno matriko

```julia
import Base:*, size
struct PremikMatrike
   premik
   matrika
end
*(p::PremikMatrike, x) = p.matrika*x + p.premik.*x
size(p::PremikMatrike) = size(p.matrika)

Lp = PremikMatrike(0.01, L)
l, v = inverzna_iteracija(Lp, 5, (Lp, x) -> conjgrad(Lp, x)[1])
```

== Algoritem k-povprečij
<algoritem-k-povprečij>
```julia
nove_tocke =  [tocka for tocka in zip(razcep.vectors[:,4], razcep.vectors[:,5])]
gruce = kmeans(nove_tocke, 3)

p1 = scatter(tocke[findall(gruce .== 1)], color=:blue, title="Originalne točke")
scatter!(p1, tocke[findall(gruce .== 2)], color=:red)
scatter!(p1, tocke[findall(gruce .== 3)], color=:green)

p2 = scatter(nove_tocke[findall(gruce .== 1)], color=:blue, title="Preslikane točke")
scatter!(p2, nove_tocke[findall(gruce .== 2)], color=:red)
scatter!(p2, nove_tocke[findall(gruce .== 3)], color=:green)

plot(p1,p2)
savefig("06_gruce.png")
```

#figure([],
  caption: [
    Gruče
  ]
)

== Literatura
<literatura>
- A tutorial on spectral clustering @von_luxburg_tutorial_2007
- Knjižnica
  #link("http://danspielman.github.io/Laplacians.jl/latest/index.html")[Laplacians.jl]
