#import "admonitions.typ": opomba, naloga
#import "Julia.typ": jl, code_box, jlfb, repl, blk

= Konvergenčna območja sistemov nelinearnih enačb
<9-poglavje>

Za razliko od sistemov linearnih enačb, ki imajo preproste množice rešitev, so
množice rešitev za sisteme nelinearnih enačb zapletene in nepredvidljive.
Zato tudi reševanje sistemov nelinearnih enačb z numeričnimi metodami ni tako preprosto
kot za sisteme linearnih enačb. Numerične metode lahko
konvergenco k določeni rešitvi zagotovijo le ob dodatnih predpostavkah,
ki jih je težko vnaprej izpolniti. V tej vaji si bomo na preprostem
primeru ogledali, kako se obnaša Newtonova metoda za različne
začetne približke.

== Naloga

- Implementiraj Newtonovo metodo za reševanje sistemov nelinearnih enačb.
- Poišči rešitev dveh nelinearnih enačb z dvema neznankama:
  $
    x^3 - 3x y^2 & = 1,\
    3x^2 y - y^3 & = 0.
  $<eq:09primer>
- Sistem nelinearnih enačb ima navadno več rešitev. Grafično predstavi, h kateri rešitvi
  konvergira Newtonova metoda v odvisnosti od začetnega približka.
  Začetne približke izberi na pravokotni mreži. Vozliščem v mreži priredi različne barve,
  glede na to, h kateri rešitvi konvergira Newtonova metoda. Cel postopek zapiši v funkcijo
  `konvergencno_obmocje`.

== Newtonova metoda za sisteme enačb

#let JF=math.op($J_bold(F)$)
#let bx = math.bold("x")
#let bF = math.bold("F")

Iščemo rešitev sistem $n$ nelinearnih enačb z $n$ neznankami:

$
f_1(x_1, x_2, med dots, med x_n)&=0,\
f_2(x_1, x_2, med dots, med x_n)&=0,\
dots.v\
f_(n)(x_1, x_2, med dots, med x_n)&=0,
$<eq:9-nelin-sistem>
kjer so $f_1, f_2, med dots, med f_n$ nelinearne funkcije več spremenljivk.
Sistem @eq:9-nelin-sistem zapišemo v vektorski obliki:

$
  bold(F)(bold(x)) = bold(0),
$<eq:09enacba>

kjer sta $bold(0) = [0, 0, dots, 0]^T$ in $bx = [x_1, x_2, dots, x_n]^T in RR^n$ $n$-dimenzionalna
vektorja, $bF: RR^n -> RR^n$ pa je vektorska funkcija z vektorskim argumentom.
Komponente vektorske funkcije $F(bold(x))$ so leve strani nelinearnih enačb @eq:9-nelin-sistem:

$
bF(bx) = vec(f_1(x_1, x_2, dots, x_n), f_2(x_1, x_2, dots, x_n), dots.v, f_(n)(x_1, x_2, dots, x_n)).
$

Denimo, da je $bx^((k))$ približek za rešitev enačbe @eq:09enacba. Funkcijo $bF$
lahko, podobno kot funkcijo ene spremenljivke, v točki $bold(x)^((k))$ aproksimiramo z linearno
funkcijo:

$
  bF(bx) = bF(bx^((k))) + JF(bx^((k)))(bx - bx^((k))) + cal(O)((bx - bx^((k)))^2),
$

kjer je $JF$
#link("https://sl.wikipedia.org/wiki/Jacobijeva_matrika_in_determinanta")[Jacobijeva matrika]
parcialnih odvodov komponent $f_(i)$ po koordinatah $x_j$:

$
  JF(bx) = mat(
    (partial f_1)/(partial x_1)(bx), (partial f_1)/(partial x_2)(bx), dots, (partial f_1)/(partial x_n)(bx);
    (partial f_2)/(partial x_1)(bx), (partial f_2)/(partial x_2)(bx), dots, (partial f_2)/(partial x_n)(bx);
    dots.v, dots.v, dots.down, dots.v;
    (partial f_(n))/(partial x_1)(bx), (partial f_(n))/(partial x_2)(bx), dots, (partial f_(n))/(partial x_n)(bx);
  ).
$

Naslednji približek $bx^((k+1))$ v Newtonovi iteraciji dobimo kot rešitev
sistema linearnih enačb:

$
  bF(bx^((k))) + JF(bx^((k)))(bx^((k+1)) - bx^((k))) = bold(0).
  //=> JF(bx^((k)))bx^((k+1)) = JF(bx^((k))) bx^((k)) - bF(bx^((k))).
$

Formulo za naslednji približek $bx^((k+1))$ formalno zapišemo kot:

$
  bx^((k+1)) = bx^((k)) - JF(bx^((k)))^(-1)bF(bx^((k))),
$

pri čemer formule ne smemo jemati dobesedno, saj inverzne matrike $JF(bx^((k)))^(-1)$ dejansko ne
izračunamo. Izraz $JF(bx^((k)))^(-1)bF(bx^((k)))$ poiščemo tako, da rešimo sistem
$JF(bx^((k)))bx = bF(bx^((k)))$ (npr. z LU razcepom ali s kakšno drugo metodo za reševanje
sistemov linearnih enačb).

#naloga[
Napiši funkcijo #jl("newton(f, jf, x0)"), ki poišče rešitev sistema nelinearnih enačb z Newtonovo
metodo (@pr:09-newton).
]

Poglejmo, kako uporabimo Newtonovo metodo za enačbe @eq:09primer. Spremenljivke $x, y$ postavimo
v vektor $bx=[x, y]^T$ in za lažje pisanje programa vpeljemo komponente $x_1=x$ in $x_2=y$.
Sistem enačb @eq:09primer preuredimo tako, da je na desni strani $0$:
$
x_1^3 - 3x_1x_2^2 - 1 &= 0,\
3x_1^2x_2 - x_2^3 &= 0.
$

Funkcija levih strani $bF(bx)$ je enaka:

$
bF(bx) = vec(x_1^3 - 3x_1 x_2^2 - 1, 3x_1^2 x_2 - x_2^3),
$

Jacobijeva matrika $JF(bx)$ pa:

$
  JF(bx) = mat(
    3x_1^2 - 3x_2^2, quad -6x_1 x_2;
    6x_1 x_2, quad 3x_1^2 - 3x_2^2
  ).
$

#let vaja9s(koda) = jlfb("scripts/09_newton.jl", koda)
#let repl9(koda) = blk("scripts/09_newton.jl", koda)

#code_box(
  vaja9s("# primer")
)

#opomba(naslov: [Avtomatsko odvajanje])[
V našem primeru smo Jacobijevo matriko izračunali na roke, saj je bila funkcija preprosta.
Če je funkcija $bF$ kompleksnejša ali je ne poznamo vnaprej, lahko Jacobijevo matriko odvodov
učinkovito izračunamo z
#link("https://en.wikipedia.org/wiki/Automatic_differentiation")[avtomatskim odvajanjem]. V Julii
uporabimo funkcijo #jl("jacobian") iz paketa
#link("https://juliadiff.org/ForwardDiff.jl/stable/")[ForwardDiff]@RevelsLubinPapamarkou2016.
]

Sistem @eq:09primer izhaja iz kompleksne enačbe $z^3 = 1$ in ima tako
3 rešitve:
$
x_1=1, quad y_1=0 &quad (z_1=1),\
x_2=-1/2, quad y_2=sqrt(3)/2 &quad (z_2= -1/2 + sqrt(3)/2 i) #text[ in]\
x_3=-1/2, quad y_3=-sqrt(3)/2 &quad (z_3 = -1/2 - sqrt(3)/2 i).
$

Za različne začetne približke Newtonova metoda konvergira k različnim
rešitvam:

#code_box[
  #repl(repl9("# nicle 1"), read("out/09_nicle_1.out"))
  #repl(repl9("# nicle 2"), read("out/09_nicle_2.out"))
  #repl(repl9("# nicle 2"), read("out/09_nicle_2.out"))
]

== Konvergenčno območje

Newtonova metoda je občutljiva glede izbire začetnega približka. Če je začetni približek dovolj blizu neke
rešitve, Newtonova metoda konvergira k tisti rešitvi. Če pa je približek med ničlami, postane
obnašanje Newtonove metode precej nepredvidljivo.

#naloga[
- Definiraj podatkovni tip #jl("Box2d"), ki opiše pravokotnik v ravnini s stranicami vzporednimi koordinatnim osem (@pr:09-box) in
- Napiši funkcijo #jl("konvergenca(obmocje::Box2d, metoda, nx, ny)"), ki za dano #jl("območje") izračuna dele območja, na katerem
   #jl("metoda") konvergira k določeni ničli.
  Argument #jl("metoda") naj bo funkcija oblike #jl("x, it = metoda(x0)"), ki sprejme začetni približek in vrne rešitev ter število iteracij (@pr:09-konvergenca).
]

Program #jl("konvergenca") uporabimo na našem primeru @eq:09primer:

#code_box(
  vaja9s("# obmocje")
)

#figure(
  image("img/09-fraktal.svg", width: 60%),
  caption:[Newtonova metoda konvergira k različnim rešitvam odvisno od začetnega
   približka.]
)

#opomba(naslov: [Kaj smo se naučili?])[
  - Sisteme nelinearnih enačb lahko rešimo z Newtonovo metodo.
  - Sistemi nelinearnih enačb imajo navadno več rešitev.
  - Konvergenca Newtonove metode je odvisna od začetnega približka.
  - Za izbrani začetni približek je težko predvideti, h kateri izmed rešitev bo Newtonova metoda konvergirala.
]
== Rešitve

#let vaja9(koda, caption) = figure(caption: caption, code_box(jlfb("Vaja09/src/Vaja09.jl", koda)))

#vaja9("# newton")[Newtonova metoda za reševanje sistemov nelinearnih enačb]<pr:09-newton>

#vaja9("# box2d")[Pomožne funkcije za delo s pravokotnimi območji]<pr:09-box>

#vaja9("# konvergenca")[
  Funkcija, ki razišče konvergenco izbrane metode na danem pravokotniku.]<pr:09-konvergenca>
