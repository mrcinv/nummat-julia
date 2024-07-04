= Nelinearne enačbe v geometriji


== Naloga

- Implementirajte Newtonovo metodo za sisteme nelinearnih enačb.
- Napišite funkcije, ki poišče presečišča geometrijskih objektov:
   - samopresečišče #link("https://sl.wikipedia.org/wiki/Lissajousova_krivulja")[Lissajousove krivulje]
   $ (x(t), y(t)) = (a sin(n t), b cos(m t)) $
   za parametre $a = b = 1$ in $n=3$ in $m=2$. 
  - poltraka $bold(x)(t) = bold(x_0) + t bold(e)$ in #link("https://en.wikipedia.org/wiki/Implicit_surface")[implicitne ploskve] podane z enačbo 
  $F(x, y, z) = 0$.
- Poiščite minimalno razdaljo med dvema parametrično podanima krivuljama:
  $
  (x_1(t), y_1(t)) = &(2 cos(t) + 1/3, sin(t) + 1/4) \
  (x_2(s), y_2(s)) = &(1/3 cos(s) - 1/2 sin(s), 1/3 cos(s) + 1/2 sin(t)).
  $
  - Zapišite razdaljo med točko na prvi krivulji in točko na drugi krivulji kot funkcijo
    $d(t, s)$ parametrov $t$ in $s$.
  - Minimum funkcije $d(t, s)$ oziroma $d^2(t, s)$ poiščite z #link("https://en.wikipedia.org/wiki/Gradient_descent")[gradientnim spustom].
  - Minimum funkcije $d^2(t, s)$ poiščite z Newtonovo metodo kot rešitev vektorske enačbe $ nabla d^2(t, s) = 0. $
  - Grafično predstavi zaporedja približkov za gradientno metodo in Newtonovo metodo. 
  - Primerjaj konvergenčna območja za gradientno in Newtonovo metodo (glej @konvergencna-obmocja). 