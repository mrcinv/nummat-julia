#import "julia.typ": code_box, jlfb, jl
#import "admonitions.typ": opomba

= Povprečna razdalja med dvema točkama na kvadratu

== Naloga

- Izpeljite algoritem, ki izračuna integral na več dimenzionalnem kvadru kot
  večkratni integral tako, da za vsako dimenzijo uporabite isto kvadraturno formulo za enkratni integral.
- Pri implementaciji pazite, da ne delate nepotrebnih dodelitev pomnilnika.
- Uporabite algoritem za izračun povprečne razdalje med dvema točkama na enotskem
  kvadratu $[0, 1]^2$ in enotski kocki $[0, 1]^3$.
- Za sestavljeno Simpsonovo formulo in Gauss-Legendrove kvadrature ugotovite, kako napaka
  pada s številom izračunov funkcije, ki jo integriramo. Primerjajte rezultate s preprosto
  Monte-Carlo metodo (računanje vzorčnega povprečja za enostaven slučajni vzorec).

== Kvadrature za večkratni integral

V poglavju o enojnih integralis smo spoznali, da je večina kvadraturnih
formul preprosta utežena vsota

$ integral_a^b f (x) d x approx sum w_k f (x_k), $

kjer so uteži $w_k$ in vozlišča $x_k$ primerno izbrana, da je formula čim bolje zadene pravo
vrednost.

Pri večkratnih integralih se stvari nekoliko zakomplicirajo, a v bistvu
ostanejo enake. Kvadrature so tudi za večkratne integrale večinoma
navadne utežene vsote vrednosti v izbranih točkah na območju.

== Dvojni integral in integral integrala
<dvojni-integral-in-integral-integrala>

Oglejmo si najbolj enostaven primer, ko integriramo funkcijo na kocki
$[a , b]^2$. Dvojni integral lahko zapišemo kot dva gnezdena enojna
integrala #footnote[Več o tem, kdaj je mogoče večkratni integral
zamenjati z gnezdenimi enojnimi integrali pove
#link("https://en.wikipedia.org/wiki/Fubini's_theorem")[Fubinijev izrek];.]

$
integral integral_([a , b]^2) f (x , y) d x d y =
integral_a^b (integral_a^b f (x , y) d y) d x = integral_a^b (integral_a^b f (x , y) d x) d y
$

Najbolj enostavno je izpeljati kvadrature za večkratni integral, če za
vsak od gnezdenih enojnih integralov uporabimo isto kvadraturno formulo

$ integral_a^b f (x) d x approx sum_(k = 1)^n w_k f (x_k) $<eq:14-kvad>

z danimi utežmi $w_1 , w_2 , dots.h w_n$ in vozlišči
$x_1 , x_2 , dots.h x_n$. Če za zunanji integral uporabimo kvadrature
@eq:14-kvad, dobimo:

$
integral integral_([a , b]^2) f (x , y) d x d y = integral_a^b (integral_a^b f (x , y) d y) d x =
sum w_i F y (x_i),
$

kjer je funkcija $F y (x)$ enaka integralu po $y$. Za izračun vrednosti $F_(y)(x_i)$ lahko zopet
uporabimo kvadrature @eq:14-kvad:

$
F y (x_i) = integral_a^b f (x_i , y) d y approx sum w_j f (x_i , y_j)
$

Dvojni integral lahko tako približno izračunamo kot dvojno vsoto

$
integral_a^(b) integral_a^(b) f (x , y) d x d y approx sum_(i , j) w_i w_j f (x_i , y_j) .
$<eq:14-prodkvad2>

Formulo @eq:14-prodkvad2 lahko posplošimo za integrale v več dimenzijah

$
integral_([a, b]^d) f(x_1, x_2 med dots med x_d) d x_1 d x_2 med dots med d x_d approx
sum_(i_1, i_2 med dots med i_d) product_(j=1)^d w_(i_j) f(x_(i_1), x_(i_2) med dots med x_(i_d)),
$<eq:14-prodkvad>
kjer seštevamo po vseh možnih multi indeksih $(i_1, i_2 med dots med i_d) in {1, 2 med dots med n}^d$.
Podobno lahko z linearno preslikavo formulo @eq:14-prodkvad razširimo na poljuben
$d$-dimenzionalen
Kvadraturni formuli @eq:14-prodkvad, ki jo dobimo na ta način, pravimo #emph[produktna formula].

#opomba(naslov:[Produktne formule trpijo za prekletstvom dimenzionalnosti])[

Število vozlišč, ki jih dobimo, ko uporabimo produktno formulo, narašča eksponentno z
dimenzijo prostora, na katerem integriramo. Zato produktne kvadrature postanejo hitro
(že v dimenzijah nad 6, 7) časovno tako zahtevne, da celo slabše konvergirajo kot metoda
Monte Carlo (@sec:14-monte-carlo).
Pojav imenujemo
#link("https://en.wikipedia.org/wiki/Curse_of_dimensionality")[prekletstvo dimenznionalnosti] in
se pojavi tudi pri drugih problemih, ko dimenzija prostora narašča.

Z dimenzijo narašča delež volumna, ki je „na robu“. Oglejmo si $d-$dimenzionalno
enotsko kocko $[-1,1]^d$. Če interval $[-1,1]$  razdelimo
na točke v notranjosti $[-1/2, 1/2]$ in točke na robu $[-1,1]-[-1/2, 1/2]$, sta v eni dimenziji
oba dela enako dolga. V višjih dimenzijah pa delež točk v kocki, ki so na robu v primerjavi s
točkami v notranjosti narašča. Delež točk v notranjosti lahko preprosto izračunamo:
$
P([-1/2,1/2]^d) = 1/(2^d)
$
in pada eksponentno z dimenzijo $d$. Zato je smiselno na robu uporabiti bolj gosto mrežo kot v
notranjosti. Tako je matematik Sergey A. Smolyak razvil
#link("https://en.wikipedia.org/wiki/Sparse_grid")[razpršene mreže], ki izkoriščajo to idejo in
delno omilijo prekletstvo dimenzionalnosti.
]

== Metoda Monte Carlo
<sec:14-monte-carlo>

Naj bo $X ~ U([a_1, b_1] times [a_2, b_2] med dots med [a_d, b_d])$ enakomerno porazdeljena slučajna
spremenljivka na $B_d = [a_1, b_1] times [a_2, b_2] med dots med [a_d, b_d]$. Potem je pričakovana
vrednost funkcije $f(X)$ slučajne spremenljivke $X$ enaka:
$
E(f(X)) = 1/V(B_d) integral_(B_d) f(x) d x.
$

Po #link("https://en.wikipedia.org/wiki/Central_limit_theorem")[centralnem limitnem izreku] je
vzorčno povprečje za enostaven vzorec $x_1, x_2 med dots med x_n$:

$
overline(f(x)) = 1/(n)(f(x_1) + f(x_2) med dots med f(x_n)) ~ N(mu, sigma)
$
porazdeljeno približno normalno s parametri $mu = E(f(X))$ in $sigma= sigma(f(X))/sqrt(n)$.
Razpršenost porazdelitve pada, ko $n$ narašča, to pa
pomeni, da je vzorčno povprečje za velike vzorce blizu vrednosti:

$
E(f(X)) = 1/V(B_d) integral_(B_d) f(x) d x.
$

Približno vrednost integrala lahko izračunamo kot

$
integral_(B_d) f(x) d x approx overline(f(x)) dot.c V(B_d).
$

Metoda Monte Carlo ne konvergira zelo hitro #footnote[Napaka pada s $sqrt(n)$, kjer je $n$ število
izračunov funkcijske vrednosti.]
ima pa prednost, da ne trpi za
prekletstvom dimenzionalnosti. Zato se jo najpogosteje uporablja za računanje integralov v
višjih dimenzijah.

Definirajmo sedaj naslednje:
- nov podatkovni tip `MonteCarlo(rng, n)`
- novo metodo `integriraj(integral::VeckrantiIntegral, mc::MonteCarlo)`, ki dani integral izračuna
  z metodo Monte Carlo (@pr:14-mc).

== Povprečna razdalja med točkama na kvadratu $[0 , 1]^2$
<povprečna-razdalja-med-točkama-na-kvadratu-012>

Povprečna razdaljo lahko izračunamo s štirikratnem integralom

$ bar(d) = integral_([0 , 1]^4) sqrt((x_1 - x_2)^2 + (y_1 - y_2)^2) d x_1 d x_2 d y_1 d y_2 . $

Za izračun bomo uporabili produktno kvadraturo s sestavljeno Simpsonovo
formulo in metodo Monte Carlo.

```
using NumMat, LinearAlgebra
## povprečna razdalja med točkama v kocki [0,1]^2
f(x) = norm(x[1:2]-x[3:4]); # razdalja
x0 = LinRange(0, 1, 7); w = (x0[2]-x0[1])/3*[1 4 2 4 2 4 1];
I = ndquad(f, x0, w, 4)
```

Poskusimo še z metodo Monte Carlo, kjer vozlišča izberemo slučajno
enakomerno na izbranem območju.

```
function mcquad(fun, n, dim)
    Ef = 0
    for i=1:n
      Ef += fun(rand(dim))
    end
    return Ef/n
end
mcquad(f, 100000, 6)
```

Poglejmo si, kako je s hitrostjo konvergence pri produktnih kvadraturah.

```@example
using Plots, Random
Random.seed!(1234)
ndquad_simpson(f, n, dim) = ndquad(f, LinRange(0, 1, 2n+1),
                            1/(6n)*vcat([1], repeat([4,2], n-1), [4, 1]), dim)
dim = 4
I = ndquad_simpson(f, 20, dim)
n = 3:15
napake_s = []
napake_mc = []
for nk in n
    push!(napake_s, ndquad_simpson(f, nk, dim) - I)
    push!(napake_mc, mcquad(f, (2nk+1)^4, dim) - I)
end
scatter((2n.+1).^4, abs.(napake_s), scale=:log10, label="simpson")
scatter!((2n.+1).^4, abs.(napake_mc), scale=:log10, label="Monte Carlo", title="Napake v odvisnosti od števila izračunov")
```

Z zbranimi podatki lahko določimo približni red simpsonove produktne
metode za 4 kratne integrale

```@example
konst, red = hcat(ones(size(n)), log.((2n.+1).^4))\log.(abs.(napake_s))
println("Napaka produktne simpsonove formule pada z n^(", red, "), kjer je n število izračunov funkcijske vrednosti.")
```

Podobno lahko vsaj približno ocenimo hitrost konvergence za metodo Monte
Carlo. Pri čemer se moramo zavedati, da je vrednost in tudi napaka
odvisna od zaporedja slučajnih vozlišč, zato je ocena zgolj okvirna:

```@example
konst, red = hcat(ones(size(n)), log.((2n.+1).^4))\log.(abs.(napake_mc))
println("Napaka pri Monte Carlo pada približno z n^(", red, ") za izbrane vzorce.")
```

== Rešitve

#let vaja14(koda, caption) = figure(code_box(jlfb("Vaja14/src/Vaja14.jl", koda)), caption: caption)

#vaja14("# VeckratniIntegral")[Podakovni tip, ki opiše večkratni integral]<pr:14-veckratni-integral>
#vaja14("# preslikaj")[Preslikaj kvadraturo na drug interval]<pr:14-preslikaj>
#vaja14("# integriraj")[Izračunaj večkratni integral s produktno kvadraturo]<pr:14-integriraj>
#vaja14("# naslednji!")[Izračunaj naslednji multiindeks
$(i_1, i_2 med dots med i_d) in {1, 2 med dots med n}^d$ ]<pr:14-naslednji>
#vaja14("# mc")[Izračunaj večkratni integral z metodo Monte Carlo]<pr:14-mc>
