#import "julia.typ": jl, code_box, jlfb
#import "admonitions.typ": opomba

= Interpolacija z zlepki<sec:12-zlepki>

Pri interpolaciji iščemo #emph[interpolacijsko funkcijo], ki se v danih točkah ujema z danimi
vrednostmi. Najbolj znana je interpolacija s polininomi. Če je danih točk veliko, je pogosto bolje
namesto ene interpolacijske funkcije z veliko parametri interval razdeliti na več podintervalov in
na vsakem uporabiti različne interpolacijske funkcije z malo parametri.
Funkcijam, ki so definirane z različnimi predpisi na različnih intervalih, pravimo zlepki.

== Naloga

- Podatke iz @hermitovi-podatki[Tabele] interpoliraj s
  #link("https://en.wikipedia.org/wiki/Cubic_Hermite_spline")[Hermitovim kubičnim zlepkom].
  #figure(
  table(columns: 5, stroke: none, align: center,
    table.vline(x: 1),
    table.header($x$, $x_1$, $x_2$, $dots$, $x_n$),
    table.hline(),
    $f(x)$, $y_1$, $y_2$, $dots$, $y_n$,
    $f'(x)$, $d y_1$, $d y_2$, $dots$, $d y_n$),
    caption: [Podatki, ki jih potrebujemo za Hermitov kubični zlepek.]
  )<hermitovi-podatki>
- Uporabi Hermitovo bazo kubičnih polinomov, ki zadoščajo pogojem iz @hermitova-baza[Tabele] in
  jih z linearno preslikavo preslikaj z intervala $[0, 1]$ na interval $[x_i, x_(i+1)]$.

#figure(
    table(
      columns: 5, stroke: none, table.vline(x:1),
      [], [$p(0)$], [$p(1)$], [$p'(0)$], [$p'(1)$],
      table.hline(),
      [$h_(00)$], [$1$], [$0$], [$0$], [$0$],
      [$h_(01)$], [$0$], [$1$], [$0$], [$0$],
      [$h_(10)$], [$0$], [$0$], [$1$], [$0$],
      [$h_(11)$], [$0$], [$0$], [$0$], [$1$]
    ),
caption: [Vrednosti baznih polinomov $h_(i j)(t)$ in njihovih odvodov v točkah $t=0$ in $t=1$]
)<hermitova-baza>
- Definirajte podatkovni tip `HermitovZlepek` za Hermitov kubični zlepek, ki vsebuje podatke iz
  @hermitovi-podatki[Tabele].
- Napišite funkcijo `vrednost(zlepek, x)`, ki izračuna vrednost Hermitovega kubičnega zlepka za dano
  vrednost argumenta $x$. Omogočite,  da se vrednosti tipa #jl("HermitovZlepek")
  #link("https://docs.julialang.org/en/v1/manual/methods/#Function-like-objects")[kliče kot funkcije].
- S Hermitovim zlepkom interpolirajte funkcijo $f(x) = cos(2x) + sin(3x)$ na intervalu $[0, 6]$ v
  $10$ točkah. Napako ocenite s formulo za napako polinomske interpolacije
  $
    f(x) - p_3(x) = (f^((4))(xi))/(4!)(x - x_1)(x - x_2)(x - x_3)(x - x_4)
  $<eq:12-ocena>
  in oceno primerjajte z dejansko napako. Upoštevajte, da je pri Hermitovi interpolaciji $x_1=x_2$
  in $x_3=x_4$. Narišite graf napake.
- Z oceno za napako @eq:12-ocena določite število interpolacijskih točk, pri katerem
  bo napaka Hermitovega zlepka manjša od $10^(-7)$.
- Funkcijo $f(x)$ interpolirajte tudi z Newtonovim polinomom in primerjajte napako z napako
  Hermitovega zlepka.

== Hermitov kubični zlepek<sec:12-hermitov-zlepek>

Hermitov kubični zlepek, ki interpolira podatke iz @hermitovi-podatki[Tabele], je sestavljen
iz kubičnih polinomov $p_(k)(x)$ na intervalih $[x_(k), x_(k+1)]$. Kubični polinom je podan s
štirimi parametri, ravno toliko kot je podatkov v krajiščih intervala $[x_(k), x_(x+1)]$.
Zato lahko vsak polinom $p_(k)(x)$ določimo le na podlagi podatkov v točkah $x_k$ in $x_(k+1)$.
Polinom $p_(k)(x)$ poiščemo tako, da interval $[x_k, x_(k+1)]$ preslikamo z linearno preslikavo
na $[0, 1]$ in uporabimo Lagrangeevo bazo $h_(00)(t)$, $h_(01)(t)$, $h_(10)(t)$ in $h_(11)(t)$
za podatke iz @hermitova-baza[tabele]. Polinome poiščemo v standardni bazi
$
h_(i j)(t) = a_0 + a_1 t + a_2 t^2 + a_3t^3.
$
Če izračunamo še odvod $h'_(i j)(t) = a_1 + 2a_2 t + 3a_3 t^2$, dobimo naslednji sistem enačb za
koeficiente baznega polinoma $h_(00)(t)$:

$
h_(00)(0) &= a_0 = 1,\
h'_(00)(0) &= a_1  = 0,\
h_(00)(1) & = a_0 + a_1 + a_2 +a_3=0,\
h'_(00)(1) & = a_1 + 2a_2 +3a_3=0.
$<eq:12-sistem-baza>

Za ostale polinome dobimo podobne sisteme, ki imajo isto matriko sistema, razlikujejo pa se v
desnih straneh. Če desne strani postavimo v matriko, dobimo ravno identično matriko.
Inverzna matrika sistema @eq:12-sistem-baza ima v stolpcih ravno koeficiente baznih polinomov
$h_(i j)(t)$. Inverz izračunamo z Julio.

#let demo12(koda) = code_box(jlfb("scripts/12_zlepki.jl", koda))

#demo12("# baza")
#code_box(raw(read("out/12-baza.out")))

Bazni polinomi so enaki

$
h_(00)(t) &= 1 - 3t^2 + 2t^3,\
h_(01)(t) &= 3t^2 - 2t^3,\
h_(10)(t) &= t - 2t^2 + t^3,\
h_(11)(t) &= -t^2 + t^3.
$

Sedaj moramo še določiti preslikavo z intervala $[x_(k), x_(k+1)]$ na $[0, 1]$. Naj bo
$x in[x_(k), x_(k+1)]$ in $t in [0, 1]$. Potem je preslikava med $x$ in $t$ enaka:

$
t(x) = (x - x_k)/(x_(k+1) - x_(k)),
$<eq:12-tx>

medtem ko je

$
x(t) = x_k + t(x_(k+1)-x_(k))
$

preslikava med $t$ in $x$. Želimo uporabiti bazo $h_(i j)(t)$ in tako interpoliramo polinoma
$p_(k)(x(t))$ na intervalu $[0, 1]$. Vidimo, da je

$
p_(k)(x(0)) = p_(k)(x_k) = y_(k),\
(d)/(d t) p_(k)(x(0)) = p'_(k)(x_k)x'(0) = p'_(k)(x_k)(x_(k+1)-x_(k)) = d y_(k)(x_(k+1)-x_(k)),\
p_(k)(x(1)) = p_(k)(x_(k+1)) = y_(k+1),\
(d)/(d t) p_(k)(x(1)) = p'_(k)(x_k)x'(1) = p'_(k)(x_(k+1))(x_(k+1)-x_(k)) = d y_(k+1)(x_(k+1)-x_(k))
$
in
$
p_(k)(x) = y_k h_(00)(t) + y_(k+1) h_(01)(t) +
  (x_(k+1)-x_(k))(d y_(k)h_(10)(t) + d y_(k+1)h_(11)(t)),
$

kjer $t$ izračunamo kot $t(x)$ iz @eq:12-tx. Sedaj napišemo naslednje funkcije in tipe:
- funkcijo #jl("hermiteint(x, xint, y, dy)"), ki izračuna vrednost Hermitovega polinoma v #jl("x")
  (@pr:12-hermiteint),
- podatkovni tip #jl("HermitovZlepek") in funkcijo #jl("vrednost(x, Z::HermitovZlepek)"), ki
  izračuna vrednost Hermitovega zlepka #jl("z") v dani točki #jl("x") (@pr:12-zlepek).

  #opomba(naslov:[Vrednosti kot funkcije])[
  Na primeru Hermitovega zlepka lahko ilustriramo, kako v Julii ustvarimo vrednosti, ki se obnašajo
  kot funkcije. Tako lahko zapis v programskemu jeziku približamo matematičnemu zapisu.
  Za Hermitov zlepek smo definirali tip #jl("HermitovZlepek") in funkcijo
  #jl("vrednost"), s katero lahko izračunamo vrednost Hermitovega zlepka v
  dani točki. Vrednost tipa #jl("HermitovZlepek") hrani interpolacijske podatke
  in hkrati predstavlja zlepek kot funkcjo. V Julii lahko definiramo, da se vrednosti
  tipa #("HermitovZlepek")
  #link("https://docs.julialang.org/en/v1/manual/methods/#Function-like-objects")[obnašajo kot funkcije]:

  ```jl
  (z::HermitovZlepek)(x) = vrednost(z, x)
  ```

  Vrednosti zlepka v dani točki izračunamo tako, kot bi to naredili v matematičnem zapisu:

  ```jl
  z = HermitovZlepek([0, 1, 2], [1, 2, 3], [2, 1, 2])
  z(1.23)
  ```
  ]

Napisane funkcije preiskusimo tako, da funkcijo $f(x) = cos(2x) + sin(3x)$ interpoliramo v 10
ekvidistančnih točkah na intervalu $[0, 6]$:

#demo12("# zlepek")

Na eno sliko naričemo graf funkcije in zlepka, na drugo pa napako interpolacije (razliko
med funkcijo in zlepkom):

#demo12("# zl int")
#demo12("# zl napaka")

#figure(kind: image, table(stroke: none, columns: 2,
image("img/12-interpolacija.svg"), image("img/12-napaka.svg")),
  caption:[Levo: Graf funkcije $f(x)=cos(2x) + sin(3x)$ in Hermitovega zlepka, ki interpolira
  funkcijo $f(x)$ na 10 točkah (levo). Graf napake interpolacije (desno). Zlepek interpolira tudi vrednosti
  odvodov, zato ima napaka v interpolacijskih točkah stacionarne točke.])

== Ocena za napako

Oceno za napako interpolacije lahko za Hermitov polinomom izračunamo analitično.
Napako polinomske interpolacije v splošnem zapišemo kot
$
f(x) - p_(n)(x) = (f^((n+1))(xi))/((n+1)!)product_(k=1)^(n) (x-x_i),
$
kjer je $xi$ neznana vrednost znotraj interpolacijskega območja, ki je odvisna od vrednosti $x$.
Ker imamo poleg vrednosti na voljo tudi odvode, interpolacijski točki štejemo dvojno.
Tako dobimo naslednjo formulo za napako:
$
  f(x) - p_3(x) = (f^((4))(xi))/(4!) (x-x_1)^2(x-x_2)^2.
$
Poiščimo še oceno za največjo vrednost napake.
Vrednosti $f^((4))(xi)$ ne poznamo in jo lahko zgolj ocenimo. Poleg tega moramo poiskati po
absolutni vrednosti največjo vrednost polinoma $p(x) = (x-x_1)^2(x-x_2)^2$ na intervalu $[x_1, x_2]$.
V krajiščih intervala je vrednost polinoma $p(x)$ enaka nič, zato je maksimum dosežen v notranjosti
in je dosežen v stacionarni točki. Poiščimo torej stacionarno točko $p(x)$, ki leži znotraj
intervala $[x_1, x_2]$. Odvod je enak
$
p'(x) &= 2(x-x_1)(x-x_2)^2 + 2(x-x_1)^2(x-x_2)\
&= 2(x-x_1)(x-x_2)(x-x_2 + x-x_1) \
&= 4(x-x_1)(x-x_2)(x - (x_1 + x_2)/2).
$
Polinom $p(x)$ ima tri stacionarne točke: dve v krajiščih intervala in eno v njegovem
središču $(x_1+x_2)/2$. Vrednost polinoma v središču je tudi največja vrednost, dosežena
na $[x_1, x_2]$:

$
p((x_1+x_2)/2) = ((x_1+x_2)/2-x_1)^2((x_1+x_2)/2-x_2)^2 = 1/4(x_2-x_1)^4.
$
Največjo napako lahko ocenimo z
$
|f(x) -p_3(x)|<= (f^((4))(xi))/(4!)(x_2 - x_1)^4/4 =1/(96)f^((4))(xi)(x_2 - x_1)^4.
$<eq:12-ocena-hermite>

Če želimo uporabiti oceno @eq:12-ocena-hermite, moramo poznati oceno za četrti odvod funkcije. Za
približno oceno uporabimo avtomatsko odvajanje in narišemo graf četrtega odvoda:

#demo12("# 4. odvod")

#figure(image("img/12-odvod.svg", width: 60%), caption: [Četrti odvod funkcije $f(x)=cos(2x) +sin(3x)$
na intervalu $[0, 6]$])

Ocena za napako omogoča, da vnaprej izberemo interpolacijske točke, za katere bo napaka manjša od
predpisane. Če želimo, da je napaka manjša od $epsilon$, potem mora biti širina intervala manjša od:

$
|x_2 -x_1| <= root(4, (96)/(f^((4))(xi))epsilon).
$

Peverimo še numerično, ali izračunana formula deluje:

#demo12("# predpisana napaka")

#figure(image("img/12-napaka-eps.svg", width: 60%), caption: [Napaka interpolacije, pri čemer smo
število interpolacijskih točk izbrali tako, da je napaka mnjša od $10^(-6)$.])

#opomba(naslov:[Teoretične ocene za napako niso vedno uporabne])[
Za določitev napake smo uporabili oceno @eq:12-ocena-hermite. Pri tem smo meje za četrti odvod, ki
nastopa v oceni, določili kar z grafa. V praksi teoretične ocene, kakršna je @eq:12-ocena,
ni mogoče vedno uporabiti, saj je nepraktično določiti meje za višje odvode.
Pogosto zato uporabimo manj eksaktne načine, da dobimo vsaj neko informacijo o napaki, četudi ni
povsem zanesljiva.
]

== Newtonov interpolacijski polinom

Naj bodo $x_1, x_2, med dots med x_n$ vrednosti neodvisne spremenljivke in $y_1, y_2, med dots med y_n$
vrednosti neznane funkcije. Interpolacijski polinom, ki interpolira podatke $x_i, y_i$, je polinom $p(x)$,
za katerega velja:
$
p(x_1) &= y_1,\
p(x_2) & = y_2,\
dots.v\
p(x_(n)) &= y_(n).
$<eq:12-int-enacbe>

Newtonov interpolacijski polinom je interpolacijski polinom, zapisan v obliki:

$
p(x) = a_0 + a_1(x-x_1) +a_2(x-x_1)(x-x_2) + med dots med + a_(n)product_(k=1)^(n-1) (x-x_k).
$

Pri tem smo uporabili Newtonovo bazo polinomov za dane interpolacijske točke:

$
1, x-x_1, (x-x_1)(x-x_2), med dots, med product_(k=1)^(n-2) (x-x_k) #text[ in ] product_(k=1)^(n-1) (x-x_k).
$

Koeficiente $a_i$ je namreč lažje izračunati, kot če bi bil polinom zapisan v standardni bazi. Poleg tega
je računanje vrednosti polinoma v standardni bazi lahko numerično nestabilno, če so vrednosti $x_i$
relativno blizu. Koeficiente $a_i$ lahko poiščemo bodisi tako, da rešimo spodnje trikotni sistem,
ki ga dobimo iz enačb @eq:12-int-enacbe, ali pa z
#link("https://en.wikipedia.org/wiki/Divided_differences")[deljenimi diferencami].
Definirali bomo naslednje tipe in funkcije:
- podatkovno strukturo za Newtonov interpolacijski polinom #jl("NewtonovPolinom") (@pr:12-newton),
- funkcijo #jl("vrednost(p, x)"), ki izračuna vrednost Newtonovega polinoma v dani točki (@pr:12-vrednost-newton),
- funkcijo #jl("interpoliraj(NewtonovPolinom, x, y)"), ki poišče koeficiente polinoma za dane
  interpolacijske podatke (@pr:12-interpoliraj).


== Rungejev pojav

Pri nizkih stopnjah polinomov se z večanjem števila interpolacijskih točk napaka interpolacije
zmanjšuje. A le do neke mere! Če stopnjo polinoma preveč povečamo, začne napaka
naraščati.

#demo12("# runge")

#demo12("# run napaka")

#figure(kind: image, table(stroke: none, columns: 2,
  image("img/12-runge.svg"), image("img/12-runge-napaka.svg")),
  caption: [Interpolacija s polinomi visokih stopenj na ekvidistančnih točkah
  na robu območja močno niha. Interpolacija funkcije $f(x)=cos(2x) + sin(3x)$ s polinomom
  stopnje $65$ (levo). Razlika med funkcijo in interpolacijskim polinomom (desno).]
  )

Opazimo, da se napaka na robu znatno poveča. Povečanje je posledica velikih
oscilacij, ki se pojavijo na robu, če interpoliramo s polinomom visoke stopnje na
ekvidistančnih točkah. To je znan pojav pod imenom
#link("https://en.wikipedia.org/wiki/Runge's_phenomenon")[Rungejev pojav].
Problemu se izognemo, če namesto ekvidistančnih točk uporabimo
#link("https://en.wikipedia.org/wiki/Chebyshev_nodes")[Čebiševe točke].

#opomba(naslov: [Kaj smo se naučili?])[
- Metodo deljenih diferenc in Newtonov polinom lahko uporabimo tudi, če so poleg vrednosti podani
  tudi odvodi.
- Zaradi Rungejevega pojava interpolacija s polinomi visokih stopenj na ekvidistančnih točkah
  ni najboljša izbira. Interpolacija na Čebiševih točkah deluje tudi za visoke stopnje polinoma.
- Zlepki so enostavni za uporabo, učinkoviti (malo operacij za izračun) in imajo v določenih
  primerih boljše lastnosti od polinomov visokih stopenj.
]
== Rešitve

#let vaja12(koda, caption) = figure(code_box(jlfb("Vaja12/src/Vaja12.jl", koda)), caption: caption)

#vaja12("# hermiteint")[Funkcija, ki interpolira podatke iz @hermitovi-podatki[tabele] s
  Hermitovim kubičnim polinomom.]
#vaja12("# HermitovZlepek")[Podatkovni tip za Hermitov kubični zlepek]<pr:12-hermite>
#vaja12("# vrednost")[Funkcija, ki izračuna vrednost Hermitovega kubičnega zlepka.]<pr:12-vrednost-hermite>

#vaja12("# NewtonovPolinom")[Podatkovni tip za polinom v Newtonovi obliki]<pr:12-newton>
#vaja12("# np vrednost")[Funkcija, ki izračuna vrednost Newtonovega polinoma.]<pr:12-vrednost-newton>
#vaja12("# interpoliraj")[Izračun koeficientov Newtonovega polinoma z deljenimi diferencami]<pr:12-interpoliraj>

== Testi

#let test12(koda, caption) = figure(code_box(jlfb("Vaja12/test/runtests.jl", koda)),
  caption: caption)

#test12("# hermiteint")[Test za izračun Hermitovega kubičnega polinoma]<pr:12-hermiteint>
#test12("# zlepek")[Test za izračun vrednosti zlepka]<pr:12-zlepek>
#test12("# newton")[Test za izračun vrednosti Newtonovega polinoma]
#test12("# interpoliraj")[Test za izračun koeficientov Newtonovega interpolacijskega polinoma]
