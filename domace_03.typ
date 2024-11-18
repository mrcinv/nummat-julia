= Tretja domača naloga

== Navodila
<navodila>

Zahtevana števila izračunajte na #strong[10 decimalk] \(z relativno
natančnostjo $bold(10^(minus 10))$) Uporabite lahko le osnovne
operacije, vgrajene osnovne matematične funkcije `exp`, `sin`, `cos`, …,
osnovne operacije z matrikami in razcepe matrik. Vse ostale algoritme
morate implementirati sami.

Namen te naloge ni, da na internetu poiščete optimalen algoritem in ga
implementirate, ampak da uporabite znanje, ki smo ga pridobili pri tem
predmetu, čeprav na koncu rešitev morda ne bo optimalna. Kljub temu
pazite na #strong[časovno in prostorsko zahtevnost], saj bo od tega
odvisna tudi ocena.

Če uporabljate drug programski jezik, ravno tako kodi dodajte osnovno
dokumentacijo in teste.

== Ničle Airijeve funkcije
<ničle-airijeve-funkcije>
Airyjeva funkcija je dana kot rešitev začetnega problema

$ A i prime.double lr((x)) minus x thin A i lr((x)) eq 0 comma quad A i lr((0)) eq frac(1, 3^(2 / 3) Gamma lr((2 / 3))) thin A i prime lr((0)) eq minus frac(1, 3^(1 / 3) Gamma lr((1 / 3))) dot.basic $
Poiščite čim več ničel funkcije $A i$ na 10 decimalnih mest natančno. Ni
dovoljeno uporabiti vgrajene funkcijo za reševanje diferencialnih enačb.
Lahko pa uporabite Airyjevo funkcijo `airyai` iz paketa
`SpecialFunctions.jl`, da preverite ali ste res dobili pravo ničlo.

#emph[Namig]: Za računanje vrednosti $y lr((x))$ lahko uporabite Magnusovo metodo reda
4 za reševanje enačb oblike

$ y prime lr((x)) eq A lr((x)) y comma $ pri kateri nov približek
$bold(Y)_(k plus 1)$ dobimo takole:

$ A_1 & eq & A lr((x_k plus lr((1 / 2 minus sqrt(3) / 6)) h))\
A_2 & eq & A lr((x_k plus lr((1 / 2 plus sqrt(3) / 6)) h))\
sigma_(k plus 1) & eq & h / 2 lr((A_1 plus A_2)) minus sqrt(3) / 12 h^2 lr([A_1 comma A_2])\
bold(Y)_(k plus 1) & eq & exp lr((sigma_(k plus 1))) bold(Y)_k dot.basic $

Izraz $lr([A comma B])$ je komutator dveh matrik in ga izračunamo kot
$lr([A comma B]) eq A B minus B A$. Eksponentno funkcijo na matriki
\($exp lr((sigma_(k plus 1)))$) pa v programskem jeziku julia dobite z
ukazom `exp`.

== Dolžina implicinto podane krivulje
<dolžina-implicinto-podane-krivulje>
Poiščite približek za dolžino krivulje, ki je dana implicitno z enačbama

$ F_1 lr((x comma y comma z)) & eq x^4 plus y^2 slash 2 plus z^2 eq 12\
F_2 lr((x comma y comma z)) & eq x^2 plus y^2 minus 4 z^2 eq 8 dot.basic $

Krivuljo lahko poiščete kot rešitev diferencialne enačbe

$ dot(bold(x)) lr((t)) eq nabla F_1 times nabla F_2 dot.basic $

== Perioda limitnega cikla
<perioda-limitnega-cikla>
Poiščite periodo limitnega cikla za diferencialno enačbo

$ x prime.double lr((t)) minus 4 lr((1 minus x^2)) x prime lr((t)) plus x eq 0 $
na 10 decimalk natančno.

== Obhod lune
<obhod-lune>
Sondo Appolo pošljite iz Zemljine orbite na tir z vrnitvijo brez potiska
\(free-return trajectory), ki obkroži Luno in se vrne nazaj v Zemljino
orbito. Rešujte sistem diferencialnih enačb, ki ga dobimo v koordinatnem
sistemu, v katerem Zemlja in Luna mirujeta \(omejen krožni problem treh
teles). Naloge ni potrebno reševati na 10 decimalk.

=== Omejen krožni problem treh teles
<omejen-krožni-problem-treh-teles>
Označimo z $M$ maso Zemlje in z $m$ maso Lune. Ker je masa sonde
zanemarljiva, Zemlja in Luna krožita okrog skupnega masnega središča.
Enačbe gibanja zapišemo v vrtečem koordinatnem sistemu, kjer masi $M$ in
$m$ mirujeta. Označimo

$ mu eq frac(m, M plus m) quad upright(" ter ") quad mu^(‾) eq 1 minus mu eq frac(M, M plus m) upright(". ") $

V brezdimenzijskih koordinatah \(dolžinska enota je kar razdalja med
masama $M$ in $m$) postavimo maso $M$ v točko
$lr((minus mu comma 0 comma 0))$, maso $m$ pa v točko
$lr((mu^(‾) comma 0 comma 0))$. Označimo z $R$ in $r$ oddaljenost
satelita s položajem $lr((x comma y comma z))$ od mas $M$ in $m$, tj.

$ R & eq R lr((x comma y comma z)) eq sqrt(lr((x plus mu))^2 plus y^2 plus z^2) comma\
r & eq r lr((x comma y comma z)) eq sqrt(lr((x minus mu^(‾)))^2 plus y^2 plus z^2) dot.basic $

Enačbe gibanja sonde so potem:

$ x^(̈) & eq x plus 2 dot(y) minus mu^(‾) / R^3 lr((x plus mu)) minus mu / r^3 lr((x minus mu^(‾))) comma\
y^(̈) & eq y minus 2 dot(x) minus mu^(‾) / R^3 y minus mu / r^3 y comma\
z^(̈) & eq minus mu^(‾) / R^3 z minus mu / r^3 z dot.basic $

== Perioda geostacionarne orbite

Oblika planeta Zemlja ni čisto pravilna krogla. Zato tudi gravitacijsko polje ne deluje v vseh smereh enako. Gravitacijsko polje lahko zapišemo kot odvod gravitacijskega potenciala

$
F_g(bold(r)) = m dot gradient V(bold(r)),
$

kjer je $V(bold(r))$ skalarna funkcija položaja $bold(r)$.
#link("https://en.wikipedia.org/wiki/Gravity_of_Earth")[Zemljina gravitacija]
#link("https://en.wikipedia.org/wiki/Geopotential_model")[Zemljin gravitacijski potencial].


== Matematično nihalo \(ocena največ 9)
<matematično-nihalo>

Kotni odmik $theta(t)$ \(v radianih) pri nedušenem nihanju uteži obešene na vrvici
opišemo z diferencialno enačbo

$
g / l sin(theta(t)) + theta^(prime prime)(t) = 0,
  quad theta(0) = theta_0, med theta^prime(0) = theta_0^prime,
$
kjer je $g eq 9.80665 m slash s^2$ težni pospešek in $l$ dolžina nihala.
Napišite funkcijo, ki izračuna odmik nihala ob določenem času.
Enačbo drugega reda prevedite na sistem prvega reda in računajte z
metodo #link("https://en.wikipedia.org/wiki/Dormand%E2%80%93Prince_method")[DOPRI5]
(algoritem 7.5 v @orel).

Za različne začetne pogoje primerjajte rešitev z
nihanjem harmoničnega nihala, ki je dano z enačbo
$
g/l theta(t) + dot.double(theta(t)) = 0.
$
Pri harmoničnem nihalu je nihajni čas neodvisen od začetnih pogojev, medtem ko
je pri matematičnem nihalu nihajni čas narašča, ko se veča energija nihala.
Narišite graf odvisnosti nihajnega časa matematičnega nihala od energije nihala.
