#import "admonitions.typ": opomba
#import "julia.typ": jl, code_box, jlfb

= Konvergenčna območja nelinearnih enačb
<konvergencna-obmocja>

== Naloga

- Implementiraj Newtonovo metodo za reševanje sistemov nelinearnih enačb.
- Poišči rešitev dveh nelinearnih enačb z dvema neznankama
  $
    x^3 - 3x y^2 & = 1\
    3x^2 y - y^3 & = 0.
  $<eq:09primer>
- Sistem nelinearnih enačb ima navadno več rešitev. Grafično predstavi, h kateri rešitvi 
  konvergira Newtonova metoda v odvisnosti od začetnega približka. 
  Začetne približke izberi na pravokotni mreži. Vsakemu vozlišču v mreži priredi različne barve,
  glede na to, h kateri rešitvi konvergira Newtonova metoda. Ves postopek zapiši v funkcijo
  `konvergencno_obmocje`.

== Newtonova metoda za sisteme enačb

#let JF=math.op("JF")
#let bx = math.bold("x")
#let bF = math.bold("F")

Sistem nelinearnih enačb lahko zapišemo v obliki

$
  bold(F)(bold(x)) = bold(0), 
$<eq:09enacba>

kjer sta $bold(0) = [0, 0, dots]^T$ in $bx = [x_1, x_2, dots]^T in RR^n$ $n$-dimenzionalna
vektorja in $bF: RR^n -> RR^n$ vektorska funkcija z vektorskim argumentom:

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
    (partial f_n(bx))/(partial x_1), (partial f_n(bx))/(partial x_2), dots, (partial f_n(bx))/(partial x_n);
  ).
$

Naslednji približek $bx^((k+1))$ v Newtonovi iteraciji dobimo kot rešitev linearnega sistema: 

$
  bold(0) = bF(bx^((k))) + JF(bx^((k)))(bx^((k+1)) - bx^((k)))\
  JF(bx^((k)))bx^((k+1)) = JF(bx^((k))) bx^((k)) - bF(bx^((k))).
$

Formulo za naslednji približek $bx^((k+1))$ lahko formalno zapišemo kot:

$
  bx^((k+1)) = bx^((k)) - JF(bx^((k)))^(-1)bF(bx^((k))),
$

pri čemer formule ne smemo jemati dobesedno, saj inverzne matrike $JF(bx^((k)))^(-1)$ dejansko ne
izračunamo. Izraz $JF(bx^((k)))^(-1)bF(bx^((k)))$ poiščemo tako, da rešimo sistem 
$JF(bx^((k)))bx = bF(bx^((k)))$ (npr. z LU razcepom ali kako drugače).


Poglejmo si, kako uporabimo Newtonovo metodo za enačbe @eq:09primer. Spremenljivke $x, y$ postavimo 
v vektor $bx=[x, y]$ in za lažje pisanje programa vpeljemo komponente $x_1=x$ in $x_2=y$.
Funkcija $bF(bx)$ je enaka

$
bF(bx) = vec(x_1^3 - 3x_1 x_2^2 - 1, 3x_1^2 x_2 - x_2^3),
$ 

Jacobijeva matrika $JF(bx)$ pa

$
  JF(bx) = mat(
    3x_1^2 - 3x_2^2, -6x_1 x_2;
    -6x_1 x_2, 3x_1^2 - 3x_2^2
  ).
$

#let vaja9s(koda) = jlfb("scripts/09_newton.jl", koda)

#code_box(
  vaja9s("# primer")
)

Uporabimo funkcijo `newton` in za različne začetne približke, preverimo rezultat.

#code_box[
  #vaja9s("# nicle")
]

#opomba(naslov: [Avtomatsko odvajanje])[
Jacobijevo matriko odvodov lahko učinkovito izračunamo z 
#link("https://en.wikipedia.org/wiki/Automatic_differentiation")[avtomatskim odvajanjem]. V Juliji 
uporabimo funkcijo #jl("jacobian") iz paketa 
#link("https://juliadiff.org/ForwardDiff.jl/stable/")[ForwardDiff].
]

== Konvergenčno območje

#figure(
  image("img/09-fraktal.svg", width: 60%),
  caption:[Newtonova metoda konvergira k različnim rešitvam odvisno od začetnega 
   približka]
)

== Rešitve

Naslednje funkcije smo napisali v `Vaja09/src/Vaja09.jl`.
#let vaja9(koda) = code_box(jlfb("Vaja09/src/Vaja09.jl", koda))

#figure(
  vaja9("# newton"),
  caption: [Newtonova metoda za sisteme enačb.]
)