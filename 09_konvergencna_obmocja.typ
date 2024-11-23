#import "admonitions.typ": opomba
#import "julia.typ": jl, code_box, jlfb, repl, blk

= Konvergenčna območja nelinearnih enačb
<9-poglavje>

Za razliko od sistemov linearnih enačb, ki imajo preproste množice rešitev, so
množice rešitev za sisteme nelinearnih enačb zapletene in nepredvidljive.
Zato tudi reševanje nelinearnih sistemov z numeričnimi metodami ni tako preprosto
kot pri linearnih sistemih. Numerične metode lahko
konvergenco k določeni rešitvi zagotovijo le ob dodatnih predpostavkah,
ki jih je težko v naprej izpolniti. V tej vaji si bomo na preprostem
primeru ogledali, kako se obnaša Newtonova metoda, ko izbiramo različne
začetne približke.

== Naloga

- Implementiraj Newtonovo metodo za reševanje sistemov nelinearnih enačb.
- Poišči rešitev dveh nelinearnih enačb z dvema neznankama:
  $
    x^3 - 3x y^2 & = 1\
    3x^2 y - y^3 & = 0.
  $<eq:09primer>
- Sistem nelinearnih enačb ima navadno več rešitev. Grafično predstavi, h kateri rešitvi
  konvergira Newtonova metoda v odvisnosti od začetnega približka.
  Začetne približke izberi na pravokotni mreži. Vozliščem v mreži priredi različne barve,
  glede na to, h kateri rešitvi konvergira Newtonova metoda. Ves postopek zapiši v funkcijo
  `konvergencno_obmocje`.

== Newtonova metoda za sisteme enačb

#let JF=math.op("JF")
#let bx = math.bold("x")
#let bF = math.bold("F")

Išečmo rešitev sistem $n$ nelinearnih enačb z $n$ neznankami:

$
f_1(x_1, x_2, med dots, med x_n)&=0\
f_2(x_1, x_2, med dots, med x_n)&=0\
dots.v\
f_(n)(x_1, x_2, med dots, med x_n)&=0,
$<eq:9-nelin-sistem>
kjer so $f_1, f_2, med dots, med f_n$ nelinearne funkcije več spremenljik.
Sistem @eq:9-nelin-sistem lahko zapišemo v vektorski obliki:

$
  bold(F)(bold(x)) = bold(0),
$<eq:09enacba>

kjer sta $bold(0) = [0, 0, dots]^T$ in $bx = [x_1, x_2, dots]^T in RR^n$ $n$-dimenzionalna
vektorja, $bF: RR^n -> RR^n$ pa vektorska funkcija z vektorskim argumentom.
Komponente vektorske funkcije $F(bold(x))$ so leve strani nelinearnih enačb @eq:9-nelin-sistem:

$
bF(bx) = vec(f_1(x_1, x_2 dots x_n), f_2(x_1, x_2 dots x_n), dots.v, f_(n)(x_1, x_2 dots x_n)).
$

Denimo, da je $bx^((k))$ približek za rešitev enačbe @eq:09enacba. Funkcijo $bF$
lahko, podobno kot funkcijo ene spremenljivke, v točki $bold(x)^((k))$ aproksimiramo z linearno
funkcijo:

$
  bF(bx) = bF(bx^((k))) + JF(bx^((k)))(bx - bx^((k))) + cal(O)((bx - bx^((k)))^2),
$

kjer je $JF(bx)$
#link("https://sl.wikipedia.org/wiki/Jacobijeva_matrika_in_determinanta")[Jacobijeva matrika]
parcialnih odvodov komponent $f_(i)(x_1, x_2, dots)$ po koordinatah $x_j$

$
  JF(bx) = mat(
    (partial f_1(bx))/(partial x_1), (partial f_1(bx))/(partial x_2), dots, (partial f_1(bx))/(partial x_n);
    (partial f_2(bx))/(partial x_1), (partial f_2(bx))/(partial x_2), dots, (partial f_2(bx))/(partial x_n);
    dots.v, dots.v, dots.down, dots.v;
    (partial f_(n)(bx))/(partial x_1), (partial f_(n)(bx))/(partial x_2), dots, (partial f_(n)(bx))/(partial x_n);
  ).
$

Naslednji približek $bx^((k+1))$ v Newtonovi iteraciji dobimo kot rešitev linearnega sistema:

$
  bF(bx^((k))) + JF(bx^((k)))(bx^((k+1)) - bx^((k))) = bold(0)\
  JF(bx^((k)))bx^((k+1)) = JF(bx^((k))) bx^((k)) - bF(bx^((k))).
$

Formulo za naslednji približek $bx^((k+1))$ lahko formalno zapišemo kot:

$
  bx^((k+1)) = bx^((k)) - JF(bx^((k)))^(-1)bF(bx^((k))),
$

pri čemer formule ne smemo jemati dobesedno, saj inverzne matrike $JF(bx^((k)))^(-1)$ dejansko ne
izračunamo. Izraz $JF(bx^((k)))^(-1)bF(bx^((k)))$ poiščemo tako, da rešimo sistem
$JF(bx^((k)))bx = bF(bx^((k)))$ (npr. z LU razcepom ali s kakšno drugo metodo za reševanje
linearnih sistemov).

Napišimo funkcijo #jl("newton(f, jf, x0)"), ki poišče rešitev sistema nelinearnih enačb z Newtonovo
metodo (@pr:09-newton).


Poglejmo si, kako uporabimo Newtonovo metodo za enačbe @eq:09primer. Spremenljivke $x, y$ postavimo
v vektor $bx=[x, y]$ in za lažje pisanje programa vpeljemo komponente $x_1=x$ in $x_2=y$.
Sistem enačb @eq:09primer preuredimo tako, da je na desni strani $0$:
$
x_1^3 - 3x_1x_2^2 - 1 &= 0\
3x_1^2x_2 - x_2^3 &= 0.
$

Funkcija levih strani $bF(bx)$ je enaka

$
bF(bx) = vec(x_1^3 - 3x_1 x_2^2 - 1, 3x_1^2 x_2 - x_2^3),
$

Jacobijeva matrika $JF(bx)$ pa

$
  JF(bx) = mat(
    3x_1^2 - 3x_2^2, -6x_1 x_2;
    6x_1 x_2, 3x_1^2 - 3x_2^2
  ).
$

#let vaja9s(koda) = jlfb("scripts/09_newton.jl", koda)
#let repl9(koda) = blk("scripts/09_newton.jl", koda)

#code_box(
  vaja9s("# primer")
)

#opomba(naslov: [Avtomatsko odvajanje])[
V našem primeru smo Jacobijevo matriko izračunali na roke, saj je bila funkcija
desnih strani preprosta.
Če je funkija $bF$ bolj kompleksna ali je ne poznamo v naprej, lahko Jacobijevo matriko odvodov
učinkovito izračunamo z
#link("https://en.wikipedia.org/wiki/Automatic_differentiation")[avtomatskim odvajanjem]. V Julii
uporabimo funkcijo #jl("jacobian") iz paketa
#link("https://juliadiff.org/ForwardDiff.jl/stable/")[ForwardDiff].
]

Sistem @eq:09primer izhaja iz kompleksne enačbe $z^3 = 1$ in ima tako
3 rešitve:
$
x_1=1, med y_1=0 &quad (z_1=1),\
x_2=-1/2, med y_2=sqrt(3)/2 &quad (z_2= -1/2 + sqrt(3)/2 i) #text[ in]\
x_3=-1/2, med y_3=-sqrt(3)/2 &quad (z_3 = -1/2 - sqrt(3)/2 i).
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

Napišimo funkcijo
#jl("konvergenca(obmocje, metoda, nx, ny)"), ki za dano območje izračuna dele območja, na katerem
Newtonova metoda (@pr:09-konvergenca) konvergira k določeni ničli. Za lažje delo s pravokotnimi območji, si bomo pripravili nekaj pomožnih tipov
in funkcij (@pr:09-box).

Program #jl("konvergencno_obmocje") uporabimo na našem primeru @eq:09primer:

#code_box(
  vaja9s("# obmocje")
)

#figure(
  image("img/09-fraktal.svg", width: 60%),
  caption:[Newtonova metoda konvergira k različnim rešitvam odvisno od začetnega
   približka]
)

== Rešitve

#let vaja9(koda, caption) = figure(caption: caption, code_box(jlfb("Vaja09/src/Vaja09.jl", koda)))

#vaja9("# newton")[Newtonova metoda za sisteme enačb]<pr:09-newton>

#vaja9("# box2d")[Pomožne funkcije za delo s pravokotnimi območji]<pr:09-box>

#vaja9("# konvergenca")[
  Funkcija, ki razišče konvergenco izbrane metode na danem pravokotniku]<pr:09-konvergenca>
