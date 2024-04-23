#import "@preview/minitoc:0.1.0": *

= 2. domača naloga

Tokratna domača naloga je sestavljena iz dveh delov. V prvem delu morate
implementirati program za računanje vrednosti dane funkcije $f lr((x))$.
V drugem delu pa izračunati eno samo številko. Obe nalogi rešite na
#strong[10 decimalk] \(z relativno natančnostjo $bold(10^(- 10))$)
Uporabite lahko le osnovne operacije, vgrajene osnovne matematične
funkcije `exp`, `sin`, `cos`, …, osnovne operacije z matrikami in
razcepe matrik. Vse ostale algoritme morate implementirati sami.

Namen te naloge ni, da na internetu poiščete optimalen algoritem in ga
implementirate, ampak da uporabite znanje, ki smo ga pridobilili pri tem
predmetu, čeprav na koncu rešitev morda ne bo optimalna. Uporabite lahko
interpolacijo ali aproksimacijo s polinomi, integracijske formule,
Taylorjevo vrsto, zamenjave spremenljivk, itd. Kljub temu pazite na
#strong[časovno in prostorsko zahtevnost], saj bo od tega odvisna tudi
ocena.

Izberite #strong[eno] izmed nalog. Domačo nalogo lahko delate skupaj s
kolegi, vendar morate v tem primeru rešiti toliko različnih nalog, kot
je študentov v skupini.

Če uporabljate drug programski jezik, ravno tako kodi dodajte osnovno
dokumentacijo, teste in demo.

#minitoc(title: [Naloge], target: heading.where(depth: 2), depth:4)

== Naloge s funkcijami
<naloge-s-funkcijami>

#minitoc(title: [Naloge], target: heading.where(depth: 3))


=== Porazdelitvena funkcija normalne slučajne spremenljivke
<porazdelitvena-funkcija-normalne-slučajne-spremenljivke>
Napišite učinkovito funkcijo, ki izračuna vrednosti porazdelitvene
funkcije za standardno normalno porazdeljeno slučajno spremenljivko
$X tilde.op N lr((0 , 1))$.

$ Phi lr((x)) = P lr((X lt.= x)) = 1 / sqrt(2 pi) integral_(- oo)^x e^(- t^2 / 2) d t $

=== Fresnelov integral \(težja)
<fresnelov-integral-težja>
Napišite učinkovito funkcijo, ki izračuna vrednosti Fresnelovega
kosinusa

$ C lr((x)) = sqrt(2 slash pi) integral_0^x cos lr((t^2)) d t dot.basic $

#strong[Namig]: Uporabite pomožni funkciji

$ f lr((x)) = sqrt(2 slash pi) integral_0^oo e^(- 2 x t) cos lr((t^2)) d t $

$ g lr((x)) = sqrt(2 slash pi) integral_0^oo e^(- 2 x t) sin lr((t^2)) d t $

kot je opisano v
#link("https://people.math.sfu.ca/~cbm/aands/")[priročniku Abramowitz in Stegun].

=== Funkcija kvantilov za $N lr((0 , 1))$
<funkcija-kvantilov-za-n01>
Napišite učinkovito funkcijo, ki izračuna funkcijo kvantilov za normalno
porazdeljeno slučajno spremenljivko. Funkcija kvantilov je inverzna
funkcija porazdelitvene funkcije.

=== Integralski sinus \(težja)
<integralski-sinus-težja>
Napišite učinkovito funkcijo, ki izračuna integralski sinus

$ S i lr((x)) = integral_0^x frac(sin lr((t)), t) d t dot.basic $

Uporabite pomožne funkcije, kot je opisano v
#link("https://people.math.sfu.ca/~cbm/aands/page_232.htm")[priročniku Abramowitz in Stegun].

=== Besselova funkcija \(težja)
<besselova-funkcija-težja>
Napišite učinkovito funkcijo, ki izračuna Besselovo funkcijo $J_0$:

$ J_0 lr((x)) = 1 / pi integral_0^pi cos lr((x sin t)) d t dot.basic $

== Naloge s števili
<naloge-s-števili>

#minitoc(title: [Naloge], target: heading.where(depth: 3))

=== Sila težnosti
<sila-težnosti>
Izračunajte velikost sile težnosti med dvema vzporedno postavljenima
enotskima homogenima kockama na razdalji 1. Predpostavite, da so vse
fizikalne konstante, ki nastopajo v problemu, enake 1. Sila med dvema
telesoma $T_1 , T_2 subset bb(R)^3$ je enaka

$ bold(F) = integral_(T_1) integral_(T_2) frac(bold(r)_1 - bold(r_2), ∥bold(r)_1 - bold(r_2)∥^2) d bold(r)_1 d bold(r)_2 dot.basic $

=== Ploščina hipotrohoide
<ploščina-hipotrohoide>
Izračunajte ploščino območja, ki ga omejuje hypotrochoida podana
parametrično z enačbama:

$ x lr((t)) = lr((a plus b)) cos lr((t)) plus b cos lr((frac(a plus b, b) t)) $

$ y lr((t)) = lr((a plus b)) sin lr((t)) plus b sin lr((frac(a plus b, b) t)) $

za parametra $a = 1$ in $b = - 11 / 7$.

#strong[Namig]: Uporabite formulo za
#link("https://sl.wikipedia.org/wiki/Plo%C5%A1%C4%8Dina#Plo%C5%A1%C4%8Dine_krivo%C4%8Drtnih_likov")[ploščino krivočrtnega trikotnika]
pod krivuljo:

$ P = 1 / 2 integral_(t_1)^(t_2) lr((x lr((t)) dot(y) lr((t)) - dot(x) lr((t)) y lr((t)))) d t $

=== Povprečna razdalja \(težja)
<povprečna-razdalja-težja>
Izračunajte povprečno razdaljo med dvema točkama znotraj telesa $T$, ki je enako razliki dveh kock:

$ T = ([- 1 , 1])^3 - ([0 , 1])^3. $

Integral na produktu razlike dveh množic
$(A - B) times (A - B)$ lahko izrazimo kot vsoto integralov:

$ integral_(A - B) integral_(A - B) & f(x, y) d x d y = integral_A integral_A f(x, y) d x d y \
& - 2 integral_A integral_B f(x, y) d x d y + integral_B integral_B f(x, y) d x d y $

=== Ploščina Bézierove krivulje
<ploščina-bézierove-krivulje>
Izračunajte ploščino zanke, ki jo omejuje Bézierova krivulja dana s
kontrolnim poligonom:

$ (0 , 0) , (1 , 1) , (2 , 3) , (1 , 4) , (0 , 4) , (- 1 , 3) , (0 , 1) , (1 , 0). $

#strong[Namig]: Uporabite lahko formulo za
#link("https://en.wikipedia.org/wiki/Area#Area_in_calculus")[ploščino krivočrtnega trikotnika]
pod krivuljo:

$ P = 1 / 2 integral_(t_1)^(t_2) lr((x(t) dot(y)(t) - dot(x)(t) y(t))) d t. $

== Lažje naloge \(ocena največ 9)
<lažje-naloge-ocena-največ-9>
Naloge so namenjen tistim, ki jih je strah eksperimentiranja ali pa za
to preprosto nimajo interesa ali časa. Rešiti morate eno od obeh nalog:

=== Gradientni spust z iskanjem po premici

=== Ineterpolacija z baricentrično formulo
<ineterpolacija-z-baricentrično-formulo>
Napišite program, ki za dano funkcijo $f$ na danem intervalu
$lr([a , b])$ izračuna polinomski interpolant, v Čebiševih točkah.
Vrednosti naj računa z #emph[baricentrično Lagrangevo interpolacijo,] po
formuli

$ l(x) = cases(delim: "{", frac(sum frac(f lr((x_j)) lambda_j, x - x_j), sum frac(lambda_j, x - x_j)) & quad x eq.not x_j, f lr((x_j)) & quad "sicer") $

kjer so vrednosti uteži $lambda_j$ izbrane, tako da je
$product_(i eq.not j) lr((x_j - x_i)) = 1$. Čebiševe točke so
podane na intervalu $lr([- 1 , 1])$ s formulo

$ x_k = cos((2k -1)/(2n) pi), quad k = 0,1 med dots med n-1, $

vrednosti uteži $lambda_k$ pa so enake

$ lambda_k = (- 1)^k cases(delim: "{", 1 & quad 0 lt i lt n, 1 / 2 & quad i = 0 , n & quad "sicer".) $

Za interpolacijo na splošnem intervalu $lr([a , b])$ si pomagaj z
linearno preslikavo na interval $lr([- 1 , 1])$. Program uporabi
za tri različne funkcije $e^(- x^2)$ na $lr([- 1 , 1])$,
$frac(sin x, x)$ na $lr([0 , 10])$ in $lr(|x^2 - 2 x|)$ na
$lr([1 , 3])$. Za vsako funkcijo določi stopnjo polinoma, da napaka
ne bo presegla $10^(- 6)$.

=== Gauss-Legendrove kvadrature
<gauss-legendrove-kvadrature>
Izpelji Gauss-Legendreovo integracijsko pravilo na dveh točkah

$ integral_0^h f lr((x)) d x = A f lr((x_1)) plus B f lr((x_2)) plus R_f $

vključno s formulo za napako $R_f$. Izpelji sestavljeno pravilo za
$integral_a^b f lr((x)) d x$ in napiši program, ki to pravilo uporabi za
približno računanje integrala. Oceni, koliko izračunov funkcijske
vrednosti je potrebnih, za izračun približka za

$ integral_0^5 frac(sin x, x) d x $

na 10 decimalk natančno.
