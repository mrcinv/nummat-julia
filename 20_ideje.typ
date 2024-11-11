= Ideje za nove vaje

== Elastične preslikave

Klasifikacija objektov pri kateri je model za mejno ploskev elastična mreža.
Rešitev se poišče z expectation-maximization algoritmom.
- #link("https://en.wikipedia.org/wiki/Elastic_map")[Elastične preslikave] na Wikipedii

== Logistična regresija z nelinearno mejo

Uporabi avtomatsko odvajanje in poišči klasifikator na podlagi logistične
regresije. Poleg linearne meje uporabi kvadratično ali kakšno drugo nelinearno
mejno družino ploskev.
- #link("https://towardsdatascience.com/logistic-regression-as-a-nonlinear-classifier-bdc6746db734")[o nelinearni logistični regresiji].


== Metoda največjega verjetja


Aproksimacija podatkov z
  #link("https://en.wikipedia.org/wiki/Logistic_function")[logistično funkcijo] s
  #link("https://en.wikipedia.org/wiki/Maximum_likelihood_estimation")[cenilko največjega verjetja].

#let LL = $cal(L)$
Avtomatsko računaje gradienta bomo preiskusili pri iskanju cenilke največjega verjetja z gradientno
metodo. Cenilka največjega verjetja je izbira parametrov $phi$ verjetnostnega modela, pri kateri je
verjetje $LL(phi, x)$ največje za dane podatke $x$ in parametre $phi$. Denimo, da imamo
verjetnostni model za slučajno spremenljivko $X$, ki je odvisen od parametrov $phi$. Slučajna
spremenljivka je lahko tudi vektorska. Verjetnost, da $X$ doseže neko vrednost $bold(x)$ je
podana bodisi s funkcijo gostote verjetnosti $p(bold(x), phi)$ za zvezne spremenljivke ali s
funkcijo verjetnosti $p(bold(x), phi) = P(X=bold(X)| phi)$ za diskretne spremenljivke.
Za dano vrednost slučajne spremenljivke $bold(x)$ je funkcija verjetja funkcija odvisna od $phi$
$
phi -> p(bold(x), phi)
$
