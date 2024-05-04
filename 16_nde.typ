= Aproksimacija z dinamičnim modelom

== Reševanje začetnega problema za NDE

Navadna diferencialna enačba 

$
u'(t) = f(t, u, p)
$

ima enolično rešitev za vsak začetni pogoj $u(t_0) = u_0$. Iskanje rešitve NDE z danim začetnim pogojem imenujemo #link("https://en.wikipedia.org/wiki/Initial_value_problem")[začetni problem]. 

V naslednji vaji bomo napisali knjižnico za reševanje začetnega problema za NDE. Napisali  bomo naslednje:

1. Podatkovno strukturo, ki hrani podatke o začetnemu problemu.
2. Podatkovno strukturo, ki hrani podatke o rešitvi začetnega problema.
3. Različne metode za funkcijo `resi`, ki poiščejo približek za rešitev začetnega problema z različnimi metodami:
  - Eulerjevo metodo,
  - Runge-Kutta reda 2,
  - prediktor korektor z Eulerjevo in implicitno trapezno metodo in kontrolo koraka. 
4. Funkcijo `vrednost`, ki za dano rešitev začetnega problema izračuna vrednost rešitve v vmesnih točkah s #link("https://en.wikipedia.org/wiki/Cubic_Hermite_spline")[Hermitovim kubičnim zlepkom]. Uporabite Hermitovo bazo kubičnih polinomov, ki zadoščajo pogojem v tabeli
#figure(
table(
  columns: 5,
  [], [$p(0)$], [$p(1)$], [$p'(0)$], [$p'(1)$],
  [$h_(00)$], [$1$], [$0$], [$0$], [$0$],
  [$h_(01)$], [$0$], [$1$], [$0$], [$0$],
  [$h_(10)$], [$0$], [$0$], [$1$], [$0$],
  [$h_(11)$], [$0$], [$0$], [$0$], [$1$]

),
caption: [Vrednosti baznih polinomov $h_(i j)(t)$ in njihovih odvodov v točkah $t=0$ in $t=1$.]
)
5. 

== Hermitova interpolacija

Približne metode za začetni problem NDE izračunajo približke za rešitev zgolj v nekaterih vrednostih spremenljivke $t$. Vrednosti rešitve diferencialne enačbe lahko interpoliramo s #link("https://en.wikipedia.org/wiki/Cubic_Hermite_spline")[kubičnim Hermitovim zlepkom]. Hermitov zlepek je na intervalu $(x_i, x_(i+1))$ enak kubičnemu polinomu, ki se z rešitvijo ujema v vrednostih in odvodih v krajiščih intervala $x_i$ in $x_(i+1)$.

