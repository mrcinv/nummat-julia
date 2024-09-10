#import "admonitions.typ": opomba
#import "julia.typ": jl, code_box, jlfb, repl, blk

= Aproksimacija z linearnim modelom
<aproksimacija-z-linearnim-modelom>

#let co2 = $upright(C O)_2$

== Naloga

- Podatke o koncentraciji #co2 v ozračju aproksimiraj s kombinacijo kvadratnega polinoma
  in sinusnega nihanja s periodo 1 leto.
- Parametre modela poišči z normalnim sistemom in QR razcepom.
- Model uporabi za napoved obnašanja koncentracije #co2 za naslednjih 20 let.

== Linearni model
<linearni-model>
V znanosti pogosto želimo opisati odvisnost dveh količin npr. kako se
spreminja koncentracija #co2 v odvisnosti od časa.
Matematičnemu opisu povezave med dvema ali več količinami pravimo
#strong[matematični model]. Primer modela je Hookov zakon za vzmet, ki
pravi, da je sila vzmeti $F$ sorazmerna z raztezkom $x$:

$ F = k x $

Model povezuje dve količini silo $F$ in raztezek $x$. Poleg tega Hookov
zakon vpelje še koeficient vzmeti $k$. Koeficientu $k$ pravimo
#strong[parameter modela] in ga lahko določimo za vsako vzmet posebej z
meritvami sile in raztezka.

Najpreporstejši je #link("https://en.wikipedia.org/wiki/Linear_model")[linearni model], pri katerem
odvisno količino $y$ zapišemo kot linearno kombinacijo baznih funkcij
$phi_j (x)$ neodvisne spremenljivke $x$:

$ y (x) = M (p , x) = p_1 phi_1 (x) + p_2 phi_2 (x) + dots.h + p_k phi_k (x). $

Koeficientom $p_j$ pravimo parametri modela in jih določimo na podlagi
meritev. Znanstveniki hočejo model, pri katerem imajo parametri $p_i$
preprosto interpretacijo in pomagajo pri razumevanju pojava, ki ga
opisujejo. Zato so bazne funkcije pogosto elementarne funkcije, pri
katerih je jasno razvidna narava odvisnosti.

=== Metoda najmanjših kvadratov
<metoda-najmanjših-kvadratov>
Koeficiente modela, ki najbolje opisujejo izmerjene podatke lahko
poiščemo z metodo najmanjših kvadratov. Napišemo najprej pogoje, ki bi
jim zadoščali parametri, če bi izmerjeni podatki povsem sledili modelu.
Za vsako meritev $y_i = y (x_i)$ bi bila vrednost odvisne količine $y_i$
natanko enaka vrednosti, ki jo predvidi model $M (p , x_i)$. To
predpostavko lahko zapišemo s sistemom enačb

$
y_1 &= M (p , x_1) = p_1 phi_1 (x_1) + dots.h p_k phi_k (x_1)\
y_2 &= M (p , x_2) = p_1 phi_1 (x_2) + dots.h p_k phi_k (x_2)\
dots.v\
y_n &= M (p , x_n) = p_1 phi_1 (x_n) + dots.h p_k phi_k (x_n).
$<eq:11-sistem>

Neznanke v zgornjem sistemu so parametri $p_j$ in za #strong[linearni
model] so enačbe linearne. To je tudi ena glavnih prednosti linearnega
modela. Meritve redko povsem sledijo modelu, zato sistem
@eq:11-sistem v splošnem ni rešljiv, saj je meritev običajno več
kot je parametrov sistema. Sistem @eq:11-sistem je
#strong[predoločen];. Lahko pa poiščemo vrednosti parametrov $p_j$ pri
katerih bo razlika med meritvami in modelom kar se da majhna. Izkaže se,
da je najboljša mera za odstopanje modela od podatkov kar vsota
kvadratov razlik med meritvami in napovedjo modela:

$
  (y_1 - M (p , x_1))^2 + dots.h + (y_n - M (p , x_n))^2 = sum_(i = 1)^n (y_i + M (p , x_i))^2.
$<eq:11-minkvad>

Sistem @eq:11-sistem lahko zapišemo v matrični obliki
$ A upright(bold(p)) = upright(bold(y)) , $ kjer so stolpci matrike
sistema enaki vrednostim baznih funkcij

$ A = mat(
    phi_1 (x_1), phi_2 (x_1), dots.h, phi_k (x_1);
    phi_1 (x_2), phi_2 (x_2), dots.h, phi_k (x_2);
    dots.v, dots.v, dots.down, dots.v;
    phi_1 (x_n), phi_2 (x_n), dots.h, phi_k (x_n))
$

in stolpec desnih strani je enak meritvam

$ bold(y) = [y_1 , y_2 , dots.h , y_n]^(sans(T)). $

Pogoj najmanjših kvadratov razlik @eq:11-minkvad za optimalne
vrednosti parametrov $upright(bold(p))_(o p t)$ lahko sedaj zapišemo s
kvadratno vektorsko normo

#let argmin = math.op("argmin")

$ bold(p)_(o p t) = argmin_(bold(p)) norm(A bold(p) - bold(y))_2^2 . $

== Opis sprememb koncentracije CO2
<opis-sprememb-koncentracije-co2>
Na observatoriju
#link("http://www.esrl.noaa.gov/gmd/obop/mlo/")[Mauna Loa] na Hawaiih že
leta spremljajo koncentracijo #co2 v ozračju. Podatke lahko
dobimo na njihovi spletni strani v različnih oblikah. Oglejmo si
tedenska povprečja od začetka maritev leta 1974

#let demo11(koda) = code_box(jlfb("scripts/11_co2.jl", koda))

#demo11("# co2 data")

Nato odstranimo komentarje in izluščimo podatke

#demo11("# plot")

#figure(caption: [Koncentracija atmosferskega #co2 na Mauna Loa v zadnjih desetletjih],
  image("img/11_co2.svg", width: 60%))


Časovni potek koncentracije #co2 matematično opišemo kot
funkcijo koncentracije v odvisnosti od časa

$ y = #co2 (t) . $

Model, ki dobro opisuje spremembe #co2 lahko sestavimo iz
kvadratne funcije, ki opisuje naraščanje letnih povprečij in
periodičnega dela, ki opiše nihanja med letom:

$ co2(bold(p), t) = p_1 + p_2 t + p_3 t^2 + p_4 sin (2 pi t) + p_5 cos (2 pi t) . $

Čas $t$ naj bo podan v letih. Predoločeni sistem @eq:11-sistem, ki
ga dobimo za naš model ima $n times 5$ matriko sistema

$ A = mat(
1, t_1, t_1^2, sin (2 pi t_1), cos (2 pi t_1);
1, t_2, t_2^2, sin (2 pi t_2), cos (2 pi t_2);
dots.v, dots.v, dots.v, dots.v, dots.v;
1, t_n, t_n^2, sin (2 pi t_n), cos (2 pi t_n)) $

desne strani pa so vrednosti koncentracij.


Po metodi najmanjših kvadratov iščemo vrednosti parametrov $bold(p)$ modela $co2(bold(p), t)$,
pri katerih bo vsota kvadratov razlik med napovedjo modela in
izmerjenimi vrednostmi najmanjša. Zapišimo vsoto kvadratov kot evklidsko
normo razlike med vektorjem napovedi modela $A bold(p)$ in vektorjem
izmerjenih vrednosti $bold(y)$. Iščemo torej vektor parametrov $bold(p)$, pri
katerem bo

$ norm(A bold(p) - bold(y))_2^2 $

najmanjša.

== Normalni sistem<normalni-sistem>

Vektor parametrov modela $bold(p)$ izberemo tako, da je napoved modela $A bold(p)$
enaka pravokotni projekciji $bold(y)$ na stolpčni
prostor matrike $A$. Tako lahko izpeljemo #emph[normalni sistem] za dani predoločen sistem
$A bold(p) = bold(y)$:

$
A bold(p)-bold(y) &perp C(A)\
A bold(p)-bold(y) &in N(A^T)\
A^(T) (A bold(p) - bold(y)) &= 0\
A^T A bold(p)&=A^T bold(y)
$<eq:11-normalni-sistem>

Normalni sistem $A^T A bold(p) = A^T bold(y)$ je kvadraten in je
vedno rešljiv, če so le bazne funkcije modela izračunane v izmerjenih vrednostih neodvisne
spremenljivke linearno neodvisne.

#demo11("# normalni")

Problem normalnega sistema @eq:11-normalni-sistem je, da je zelo občutljiv:

#demo11("# cond")
#code_box(raw(read("out/11_cond.out")))

Pravzaprav je že sama matrika $A$ zelo občutljiva. Razlog je v izbiri
baznih funkcij. Če narišemo normirane stolpce $A$ kot funkcije, vidimo,
da so zelo podobni.

#demo11("# baza")

#figure(image("img/11_baza.svg", width: 60%),
  caption: [Normirani prvi trije bazni vektorji (stolpci matrike $A$) ])
Občutljivost je deloma posledica dejstva, da čas merimo v letih od začetka našega štetja. Vrednosti
$1975$ in $2020$ sta relativno blizu in tako ima vektor vrednosti $t_i$ skoraj enako smer kot vektor
enic. Občutljivost matrike $A$ lahko precej zmanjšamo, če časovno skalo premaknemo, da je $0$ bliže
dejanskim podatkom. Namesto $t$ uporabimo spremenljivko $t - tau$, kjer je $tau$ premik časovne
skale. Najboljša izbira za $tau$ je na sredini podatkov:


#demo11("# premik")

#code_box(raw(read("out/11_cond_premik.out")))

Matrika $A$ je sedaj precej dlje od singularne matrike in posledično je
tudi normalni sistem manj občutljiv.

#opomba(naslov:[Prednosti normalnega sistema])[
Čeprav je normalni sistem zelo občutljiv, se v praksi izkaže, da napaka vendarle ni tako velika.
Ima pa normalni sistem nekatere prednosti pred QR razcepom.

Dimenzije normalnega sistema so dane s številom parametrov in so bistveno manjše, kot dimenzije
matrike predoločenega sistema $A$. Zato je prostor, ki ga potrebujemo za normalni sistem bistveno
manjši od prostora, ki ga potrebujemo za QR razcep.

Druga prednost normalnega sistema je, da ga
lahko posodobimo, če dobimo nove podatke. To je uporabno, če na primer podatke dobivamo v toku.
Normalni sistem lahko posodobimo, vsakič, ko dobimo nov podatek, ne da bi bilo treba hraniti
prejšnje podatke.
]

== QR razcep
<qr-razcep>

Normalni sistem se redko uporablja v praksi. Standarden postopek za
iskanje rešitve predoločenega sistema z metodo najmanjših kvadratov je s
QR razcepom. Pri QR razcepu $Q R = A$ matrike $A$, so stolpci matrike
$Q$ ortonormirana baza stolpčnega prostora matrike $A$, matrika $R$
vsebuje koeficiente v razvoju stolpcev matrike $A$ po ortonormirani bazi
določeni s $Q$. Projekcija na stolpčni prostor ortogonalne matrike še
lažje izračunamo, saj lahko koeficiente izračunamo s skalarnim produktom
s stolpci $Q$. Če predoločeni sistem $A bold(p) = bold(y)$ pomnožimo z
desne s $Q^T$ in upoštevamo, da je $Q^T Q = I$, dobimo zopet kvadratni sistem za vektor parametrov
$bold(p)$:

$
A bold(p) &= bold(y)\
Q R bold(p) &= bold(y) \
Q^T Q R bold(p)& = Q^T bold(y)\
R bold(p) &= Q^T bold(y).
$

Matrika $R$ je zgornje trikotna, tako da lahko sistem rešimo z obratnim vstavljanjem. V Juliji lahko
uporabimo funkcijo #jl("qr"), ki vrne posebni podatkovni tip posebej namenjen
QR razcepu matrike:

#demo11("# qr")
#code_box(raw(read("out/11_razlika.out")))

Razcep QR uporabi tudi vgrajen operator `\`, če je matrika s katero delimo dimenzij
$n times k$ in $k < n$.

== Kaj pa CO2?
<kaj-pa-co2>

Koncentracije CO2 se vztrajno povečuje. Kot kaže naš model, je
naraščanje kvadratično in ne le linearno. To pomeni, da ne le, da se
vsako leto poveča koncentracija, pač pa se vsako leto poveča za večjo
vrednost.

#repl("p_qr", read("out/11_p_qr.out"))

Koeficient $p_1$ pove povprečno koncentracijo na sredini merilnega
obdobja, $p_2$ in $p_3$ sta koeficienta pri linearnem in kvadratnem členu, medtem ko
je amplituda letnih nihanj enaka velikosti vektorja $[p_4, p_5]$. Če odmislimo nihanja zaradi letnih
časov, dobimo trend naraščanja:

#demo11("# trend")

#figure(image("img/11_trend.svg", width: 60%), caption: [Rezultati modela brez letnih nihanj])

Lahko poskusimo tudi napovedati prihodnost:

#demo11("# napoved")
#code_box(raw(read("out/11_napoved.out")))

#opomba(naslov: [Kaj smo se naučili?])[
- Linearni model je funkcija, pri kateri #emph[parametri] nastopajo #emph[linearno].
- Parametre modela poiščemo z #emph[metodo najmanjših kvadratov].
- Za iskanje parametrov po metodi najmanjših kvadratov je numerično najbolj primeren
  #emph[QR razcep], če smo v stiski s prostorom, pa lahko uporabimo #emph[normalni sistem].
- Štetje z začetkom ob Kristusovem rojstvu numerično ni vedno najboljše.
- Koncentracija #co2 prav zares narašča.
]
