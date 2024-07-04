= Interpolacija z zlepki

== Naloga

- Podatke iz tabele
  #figure(
  table(columns: 5, stroke: none, align: center,
    table.vline(x: 1),
    table.header($x$, $x_1$, $x_2$, $dots$, $x_n$),
    table.hline(),
    $f(x)$, $y_1$, $y_2$, $dots$, $y_n$,
    $f'(x)$, $d y_1$, $d y_2$, $dots$, $d y_n$),
    caption: [Podatki, ki jih potrebujemo za Hermitov kubični zlepek.]
  )<hermitovi-podatki>
  interpolirajte s #link("https://en.wikipedia.org/wiki/Cubic_Hermite_spline")[Hermitovim kubičnim zlepkom]. 
- Uporabite Hermitovo bazo kubičnih polinomov, ki zadoščajo pogojem (@hermitova-baza) in  
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
- Napišite funkcijo `vrednost(zlepek, x)`, ki izračuna vrednost Hermitovega kubičnega zlepka v dani vrednosti argumenta $x$. Za podatkovni tip `HermitovZlepek` uporabite sintakso `julije`, ki omogoča, da se #link("https://docs.julialang.org/en/v1/manual/methods/#Function-like-objects")[objekte kliče kot funkcije].
- S Hermitovim zlepkom interpolirajte funkcijo $sin(x^2)$ na intervalu $[0, 5]$. 
  Napako ocenite s formulo za napako polinomske interpolacije
  $
    f(x) - p_3(x) = (f^((4))(xi))/(4!)(x - x_1)(x - x_2)(x - x_3)(x - x_4)
  $
  in oceno primerjajte z dejansko napako. Narišite graf napake in ocene za napako.
- Funkcijo $sin(x^2)$ na intervalu $[0, 5]$ interpolirajte tudi z Newtonovim polinomom, 
  in linearnim zlepkom. 
- Hermitov kubični zlepek uporabite za #link("https://en.wikipedia.org/wiki/Cubic_Hermite_spline#Interpolating_a_data_set")[interpolacijo zaporedja točk v ravnini]   s parametričnim zlepkom (vsako koordinatno funkcijo intepoliramo posebej, odvode pa določimo z #link("https://en.wikipedia.org/wiki/Finite_difference")[deljenimi diferencami]).