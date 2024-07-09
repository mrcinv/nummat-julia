== Poissonova enačba na krogu
<poissonova-enačba-na-krogu>
Drug primer, ko dobimo tridiagonalni sistem lineranih enačb, če iščemo
rešitev za robni problem na krogu $x^2 + y^2 lt.eq 1$ za
#link("https://sl.wikipedia.org/wiki/Poissonova_ena%C4%8Dba")[Poissonovo enačbo]

$ triangle.stroked.t u lr((x comma y)) = f(r) $

z robnim pogojem $u lr((x comma y)) = 0$ za $x^2 + y^2 = 1$. Pri
tem je $f(r) = f(sqrt(x^2 + y^2))$ podana funkcija, ki je
odvisna le od razdalje do izhodišča.

#link("https://en.wikipedia.org/wiki/Laplace_operator")[Laplaceov operator]
zapišemo v polarnih koordinatah in enačbo diskretiziramo z metodo
#link("https://en.wikipedia.org/wiki/Finite_difference")[končnih diferenc].