#import "julia.typ": jl, code_box, jlfb
#import "admonitions.typ": opomba

= Interpolacija z zlepki<sec:12-zlepki>

== Naloga

- Podatke iz tabele (@hermitovi-podatki) interpolirajte s
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
- Uporabite Hermitovo bazo kubičnih polinomov, ki zadoščajo pogojem iz @hermitova-baza[tabele] in
  jih z linearno preslikavo preslikate z intervala $[0, 1]$ na interval $[x_i, x_(i+1)]$.

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
caption: [Vrednosti baznih polinomov $h_(i j)(t)$ in njihovih odvodov v točkah $t=0$ in $t=1$.]
)<hermitova-baza>
- Definirajte podatkovni tip `HermitovZlepek` za Hermitov kubični zlepek, ki vsebuje podatke iz tabele @hermitovi-podatki.
- Napišite funkcijo `vrednost(zlepek, x)`, ki izračuna vrednost Hermitovega kubičnega zlepka za dano
  vrednost argumenta $x$. Omogočite,  da se vrednosti tipa #jl("HermitovZlepek")"
  #link("https://docs.julialang.org/en/v1/manual/methods/#Function-like-objects")[kliče kot funkcije].
- S Hermitovim zlepkom interpolirajte funkcijo $f(x) = sin(x)$ na intervalu $[0, 3]$ v točkah
  $0, 1, 2, 3$. Napako ocenite s formulo za napako polinomske interpolacije
  $
    f(x) - p_3(x) = (f^((4))(xi))/(4!)(x - x_1)(x - x_2)(x - x_3)(x - x_4)
  $
  in oceno primerjajte z dejansko napako. Upoštevajte, da je pri Hermitovi interpolaciji $x_1=x_2$
  in $x_3=x_4$. Narišite graf napake.
- Hermitov zlepek za funkcijo $sin(x^2)$ primerjajte tudi z Newtonovim polinomom,
  in linearnim zlepkom.
- Hermitov kubični zlepek uporabite za
  #link("https://en.wikipedia.org/wiki/Cubic_Hermite_spline#Interpolating_a_data_set")[interpolacijo zaporedja točk v ravnini]
  s parametričnim zlepkom. Vsako koordinatno funkcijo intepolirajte posebej,
  odvode pa izračunajte z #link("https://en.wikipedia.org/wiki/Finite_difference")[deljenimi diferencami].

== Hermitov kubični zlepek<sec:12-hermitov-zlepek>

#let demo12(koda) = code_box(jlfb("scripts/12_zlepki.jl", koda))

== Ocena za napako

Oceno za napako interpolacije lahko za Hermitov polinomom izračunamo analitično. Ker imamo poleg
vrednosti na voljo odvode interpolacijski točki štejemo dvojno. Tako dobimo naslednjo
formulo za napako
$
  f(x) - p_3(x) = f^((4))(xi)/(4!) (x-x_1)^2(x-x_2)^2.
$
Poiskali bi radi oceno za največjo možno vrednost napake.
Vrednosti $f^((4))(xi)$ ne poznamo in jo lahko zgolj ocenimo. Poleg tega moramo poiskati po
absolutni vrednosti največjo vrednost polinoma $p(x) = (x-x_1)^2(x-x_2)^2$ na intervalu $[x_1, x_2]$.
V krajiščih intervala je vrednost polinoma $p(x)$ enaka nič, zato je maksimum dosežen v notranjosti
in je dosežen v stacionarni točki. Poiščimo torej stacionarno točko $p(x)$, ki leži znotraj
intervala $[x_1, x_2]$. Odvod je enak
$
p'(x) &= 2(x-x_1)(x-x_2)^2 + 2(x-x_1)^2(x-x_2)\
&= 2(x-x_1)(x-x_2)(x-x_2 + x-x_1) =
  4(x-x_1)(x-x_2)(x - (x_1 + x_2)/2).
$
Polinom $p(x)$ ima tri stacionarne točke: dve v krajiščih intervala in eno v središču $(x_1+x_2)/2$.
Vrednost polinoma v središču je tudi maksimalna vrednost dosežena na $[x_1, x_2]$:

$
p((x_1+x_2)/2) = ((x_1+x_2)/2-x_1)^2((x_1+x_2)/2-x_2)^2 = 1/4(x_2-x_1)^4
$
Maksimalno napako lahko ocenimo z
$
|f(x) -p_3(x)|<= (f^((4))(xi))/(4!)(x_2 - x_1)^4/4 =1/(96)f^((4))(xi)(x_2 - x_1)^4.
$
Ocena za napako omogoča, da v naprej izberemo interpolacijske točke, za katere bo napaka manjša od
predpisane. Če želimo, da je napaka manjša od $epsilon$, potem mora biti širina intervala dovolj
majhna

$
|x_2 -x_1| <= root(4, (96)/(f^((4))(xi))epsilon).
$

== Newtonov interpolacijski polinom

Napako ocenimo z
$
f(x) - p_n(x) = (f^((n+1))(xi))/((n+1)!)product_(k=1)^(n) (x-x_i)
$

Naj bodo $x_1, x_2, med dots med x_n$ vrednosti neodvisne spremenljivke in $y_1, y_2, med dots med y_n$
vrednosti neznane funkcije. Interpolacijski polinom, ki interpolira podatke $x_i, y_i$ je polinom $p(x)$,
ki zadošča enačbam
$
p(x_1) &= y_1\
p(x_2) & = y_2\
dots.v\
p(x_n) &= y_n
$<eq:12-int-enacbe>

Newtonov interpolacijski polinom je interpolacijski polinom zapisan v obliki

$
p(x) = a_0 + a_1(x-x_1) +a_2(x-x_1)(x-x_2) + med dots med + a_(n)product_(k=1)^(n-1) (x-x_k),
$

ki uporabi Newtonovo bazo polinomov za dane interpolacijske točke:

$
1, x-x_1, (x-x_1)(x-x_2), med dots med product_(k=1)^(n-2) (x-x_k), product_(k=1)^(n-1) (x-x_k).
$

Koeficiente $a_i$ je lažje izračunati, kot če bi bil polinom zapisan v standardni bazi. Poleg tega
je računanje vrednosti polinoma v standardni bazi lahko numerično nestabilno, če so vrednosti $x_i$
relativno skupaj. Koeficiente $a_i$ lahko poiščemo bodisi tako, da rešimo spodnje trikotni sistem,
ki ga dobimo iz enačb @eq:12-int-enacbe, ali pa z
#link("https://en.wikipedia.org/wiki/Divided_differences")[deljenimi diferencami].
Definiraj podatkovno strukturo za Newtonov interpolacijski polinom in funkcijo
#jl("interpoliraj(x, y, ::Newton)")"

#opomba(naslov:[Vrednosti kot funkcije])[
Na primeru Newtonovega polinoma lahko ilustriramo, kako v Juliji ustvarimo vrednosti, ki se obnašajo
kot funkcije. Tako lahko zapis v programskemu jeziku prilbližamo matematičnemu zapisu.
Za Newtonov interpolacijski polinom smo definirali tip #jl("NewtonovPolinom") in funkcijo
#jl("vrednost"), s katero lahko izračunamo vrednost Newtonovega interpolacijskega polinoma v
dani točki. Vrednost tipa #jl("NewtonovPolinom")  hrani podatke
o koeficientih in hkrati predstavlja polinom. V Juliji lahko definiramo, da se vrednosti
tipa #("NewtonovPolinom") obnašajo kot funkcije:

```jl
(p::NewtonovPolinom)(x) = vrednost(p, x)
```

Vrednosti polinoma v dani točki lahko izračunamo tako, kot bi to naredili v matematičnem zapisu:

```jl
p = NewtonovPolinom([1, 0, 0],[1, 2, 3])
p(1.23)
```
]

== Rešitve

#let vaja12(koda, caption) = figure(code_box(jlfb("Vaja12/src/Vaja12.jl", koda)), caption: caption)

#vaja12("# hermiteint")[Interpoliraj podatke iz @hermitovi-podatki[tabele] s
  Hermitovim kubičnim polinomom]
#vaja12("# HermitovZlepek")[Podatkovni tip za Hermitov kubični zlepek]
#vaja12("# vrednost")[Izračunaj vrednost Hermitovega kubičnega zlepka]

== Testi

#let test12(koda, caption) = figure(code_box(jlfb("Vaja12/test/runtests.jl", koda)),
  caption: caption)

#test12("# hermiteint")[Test za izračun Hermitovega kubičnega polinoma]
#test12("# zlepek")[Test za izračun vrednosti zlepka]
