= Tretja domača naloga

Zahtevana števila izračunajte na #strong[10 decimalk] \(z relativno
natančnostjo $10^(-10)$) Uporabite lahko le osnovne
operacije, vgrajene osnovne matematične funkcije `exp`, `sin`, `cos`, …,
osnovne operacije z matrikami in razcepe matrik. Vse ostale algoritme
morate implementirati sami.

== Ničle Airijeve funkcije
<ničle-airijeve-funkcije>

Airyjeva funkcija je dana kot rešitev začetnega problema

$ A i prime.double lr((x)) - x thin A i lr((x)) = 0 , quad A i lr((0)) = frac(1, 3^(2 / 3) Gamma lr((2 / 3))) thin A i prime lr((0)) = - frac(1, 3^(1 / 3) Gamma lr((1 / 3))) dot.basic $
Poiščite čim več ničel funkcije $A i$ na 10 decimalnih mest natančno. Ni
dovoljeno uporabiti vgrajene funkcijo za reševanje diferencialnih enačb.
Lahko pa uporabite Airyjevo funkcijo `airyai` iz paketa
`SpecialFunctions.jl`, da preverite ali ste res dobili pravo ničlo.

#emph[Namig]: Za računanje vrednosti lahko uporabite Magnusovo metodo reda
4 za reševanje enačb oblike:

$
  y'(x) = A(x) y(x),
$

pri kateri nov približek $y_(k + 1)$ dobimo takole:

$
  A_1  = & A(x_k + (1 / 2 - sqrt(3) / 6) h)\
  A_2  = & A(x_k + (1 / 2 + sqrt(3) / 6) h)\
sigma_(k + 1)  = & h/2 (A_1 + A_2) - sqrt(3) / 12 h^2 [A_1, A_2]\
 y_(k + 1)  = & exp(sigma_(k + 1)) y_k. $

Izraz $[A, B]$ je komutator dveh matrik in ga izračunamo kot
$[A, B] = A B - B A$. Eksponentno funkcijo na matriki
$exp(sigma_(k + 1))$ pa v programskem jeziku julia dobite z
ukazom `exp`.

== Dolžina implicinto podane krivulje
<dolžina-implicinto-podane-krivulje>
Poiščite približek za dolžino krivulje, ki je dana implicitno z enačbama

$ F_1 lr((x , y , z)) & = x^4 + y^2 slash 2 + z^2 = 12,\
F_2 lr((x , y , z)) & = x^2 + y^2 - 4 z^2 = 8 dot.basic $

Krivuljo lahko poiščete kot rešitev diferencialne enačbe

$ dot(bold(x)) lr((t)) = nabla F_1 times nabla F_2 dot.basic $

== Perioda limitnega cikla
<perioda-limitnega-cikla>
Poiščite periodo
#link("https://en.wikipedia.org/wiki/Limit_cycle")[limitnega cikla] za diferencialno enačbo

$ x prime.double (t) - 4(1 - x^2) x'(t) + x = 0 $

na 10 decimalk natančno.

== Obhod lune
<obhod-lune>
Sondo Appolo pošljite iz Zemljine orbite na
#link("https://en.wikipedia.org/wiki/Free-return_trajectory")[tir z vrnitvijo brez potiska],
ki obkroži Luno in se vrne nazaj v Zemljino orbito. Rešujte sistem diferencialnih enačb, ki ga dobimo v koordinatnem
sistemu, v katerem Zemlja in Luna mirujeta
\(#link("https://en.wikipedia.org/wiki/Three-body_problem#Restricted_three-body_problem")[omejen
  krožni problem treh teles]). Naloge ni potrebno reševati na 10 decimalk.

#heading(numbering: none, depth: 3)[Omejen krožni problem treh teles]

<omejen-krožni-problem-treh-teles>
Označimo z $M$ maso Zemlje in z $m$ maso Lune. Ker je masa sonde
zanemarljiva, Zemlja in Luna krožita okrog skupnega masnega središča.
Enačbe gibanja zapišemo v vrtečem koordinatnem sistemu, kjer masi $M$ in
$m$ mirujeta. Označimo
#let barmu = $overline(mu)$
$
  mu = frac(m, M + m) quad " in " quad barmu = 1 - mu = frac(M, M + m).
$

V brezdimenzijskih koordinatah \(dolžinska enota je kar razdalja med
masama $M$ in $m$) postavimo maso $M$ v točko
$(- mu , 0 , 0)$, maso $m$ pa v točko
$(barmu , 0 , 0)$. Označimo z $R$ in $r$ oddaljenost
satelita s položajem $(x , y , z)$ od mas $M$ in $m$, tj.

$
  R & = R(x , y , z) = sqrt((x + mu))^2 + y^2 + z^2),\
  r & = r(x , y , z)) = sqrt((x - barmu)^2 + y^2 + z^2).
$

Enačbe gibanja sonde so potem:

$
  dot.double(x) & = x + 2 dot(y) - barmu / R^3 lr((x + mu)) - mu / r^3 (x - barmu),\
  dot.double(y) & = y - 2 dot(x) - barmu / R^3 y - mu / r^3 y ,\
  dot.double(z) & = - barmu / R^3 z - mu / r^3 z.
$


== Matematično nihalo (lažja)
<matematično-nihalo>

Kotni odmik $theta(t)$ \(v radianih) pri nedušenem nihanju uteži obešene na vrvici
opišemo z diferencialno enačbo

$
  g / l sin(theta(t)) + dot.double(theta)(t) = 0,
  quad theta(0) = theta_0, med dot(theta)(0) = dot(theta)_0,
$

kjer je $g = 9.80665 m slash s^2$ težni pospešek in $l$ dolžina nihala.
Napiši funkcijo, ki izračuna odmik nihala ob določenem času.
Enačbo drugega reda prevedi na sistem prvega reda in računajte z
metodo #link("https://en.wikipedia.org/wiki/Dormand%E2%80%93Prince_method")[DOPRI5]
@Orel_2004.

Za različne začetne pogoje primerjaj rešitev z
nihanjem harmoničnega nihala, ki je dano z enačbo
$
g/l theta(t) + dot.double(theta)(t) = 0.
$
Pri harmoničnem nihalu je nihajni čas neodvisen od začetnih pogojev, medtem ko
je pri matematičnem nihalu nihajni čas narašča, ko se veča energija nihala (začetni odmik).
Nariši graf odvisnosti nihajnega časa matematičnega nihala od energije nihala.
