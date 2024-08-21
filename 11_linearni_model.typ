#import "admonitions.typ": opomba

= Aproksimacija z linearnim modelom
<aproksimacija-z-linearnim-modelom>

== Naloga

- Podatke o koncentraciji $"CO"_2$ v ozračju aproksimiraj s kombinacijo kvadratnega polinoma
  in sinusnega nihanja s periodo 1 leto.
- Parametre modela poišči z normalnim sistemom in QR razcepom.
- Model uporabi za napoved obnašanja koncentracije $"CO"_2$ za naslednjih 20 let.

== Linearni model
<linearni-model>
V znanosti pogosto želimo opisati odvisnost dveh količin npr. kako se
spreminja koncentracija $upright(C O)_2$ v odvisnosti od časa.
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

$ y_i = M (p , x_i) = p_1 phi_1 (x_i) + dots.h p_k phi_k (x_i) $<eq:11-sistem>

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

$ upright(bold(y)) = [y_1 , y_2 , dots.h , y_n]^(sans(T)) . $

Pogoj najmanjših kvadratov razlik @eq:11-minkvad za optimalne
vrednosti parametrov $upright(bold(p))_(o p t)$ lahko sedaj zapišemo s
kvadratno vektorsko normo

#let argmin = math.op("argmin")

$ bold(p)_(o p t) = argmin_(bold(p)) norm(A bold(p) - bold(y))_2^2 . $

== Opis sprememb koncentracije CO2
<opis-sprememb-koncentracije-co2>
Na observatoriju
#link("http://www.esrl.noaa.gov/gmd/obop/mlo/")[Mauna Loa] na Hawaiih že
leta spremljajo koncentracijo $upright(C O)_2$ v ozračju. Podatke lahko
dobimo na njihovi spletni strani v različnih oblikah. Oglejmo si
tedenska povprečja od začetka maritev leta 1974

```@example
using FTPClient
url = "ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_weekly_mlo.txt"
io = download(url)
data = readlines(io)
```

Nato odstranimo komentarje in izluščimo podatke

```@example
using Plots
filter!(l->l[1]!='#', data)
data = strip.(data)
data = [split(line, r"\s+") for line in data]
data = [[parse(Float64, x) for x in line] for line in data]
filter!(l->l[5]>0, data)
t = [l[4] for l in data]
co2 = [l[5] for l in data]
scatter(t, co2, title="Atmosferski CO2 na Mauna Loa",
        xlabel="leto", ylabel="parts per milion (ppm)", label="co2",
        markersize=1)
```

Časovni potek koncentracije $upright(C O)_2$ matematično opišemo kot
funkcijo koncentracije v odvisnosti od časa

$ y = upright(C O)_2 (t) . $

Model, ki dobro opisuje spremembe $upright(C O)_2$ lahko sestavimo iz
kvadratne funcije, ki opisuje naraščanje letnih povprečij in
periodičnega dela, ki opiše nihanja med letom:

$ upright(C O)_2 (t) = p_1 + p_2 t + p_3 t^2 + p_4 sin (2 pi t) + p_5 cos (2 pi t) . $

Čas $t$ naj bo podan v letih. Predoločeni sistem @eq:11-sistem, ki
ga dobimo za naš model ima $n times 5$ matriko sistema

$ A = mat(
1, t_1, t_1^2, sin (2 pi t_1), cos (2 pi t_1);
1, t_2, t_2^2, sin (2 pi t_2), cos (2 pi t_2);
dots.v, dots.v, dots.v, dots.v, dots.v;
1, t_n, t_n^2, sin (2 pi t_n), cos (2 pi t_n)) $

desne strani pa so vrednosti koncentracij.

== Normalni sistem
<normalni-sistem>
Po metodi najmanjših kvadratov iščemo vrednosti parametrov $p$ modela,
pri katerih bo vsota kvadratov razlik med napovedjo modela in
izmerjenimi vrednostmi najmanjša. Zapišimo vsoto kvadratov kot evklidsko
normo razlike med vektorjem napovedi modela $A p$ in vektorjem
izmerjenih vrednosti $y$. Iščemo torej vektor parametrov $p$, pri
katerem bo

$ norm(A bold(p) - bold(y))_2^2 $

najmanjša. Iščemo torej pravokotno projekcijo vektorja $y$ na stolpčni
prostor matrike $A$, katere stolpci so podani kot vrednosti baznih
funkcij, ki nastopajo v modelu.

$
A bold(p)-bold(y) &perp C(A)\
A bold(p)-bold(y) &in N(A^T)\
A^(T) (A bold(p) - bold(y)) &= 0\
A^T A bold(p)&=A^T bold(y)
$<eq:11-normalni-sistem>

Tako dobimo normalni sistem $A^T A p = A^T y$, ki je kvadraten in je
vedno rešljiv, če so le bazne funkcije modela izračunane v izmerjenih vrednostih neodvisne
spremenljivke linearno neodvisne.

```@example
using LinearAlgebra
A = hcat(ones(size(t)), t, t.^2, cos.(2pi*t), sin.(2pi*t))
N = A'*A # hide
b = A'*co2 # hide
p = N\b # hide
norm(A*p-co2)
```

Problem normalnega sistema @eq:11-normalni-sistem je, da je zelo občutljiv:

```@example
cond(N), cond(A)
```

Pravzaprav je že sama matrika $A$ zelo občutljiva. Razlog je v izbiri
baznih funkcij. Če narišemo normirane stolpce $A$ kot funkcije, vidimo,
da so zelo podobni.

```@example
plot([A[:,1]/norm(A[:,1]), A[:,2]/norm(A[:,2]), A[:,3]/norm(A[:,3])], ylims=[0,0.025], title="Normirani stolpci matrike A")
```

Občutljivost je deloma posledica dejstva, da čas merimo v letih od začetka našega štetja. Vrednosti
$1975$ in $2020$ sta relativno blizu in tako ima vektor vrednosti $t_i$ skoraj enako smer kot vektor
enic. Občutljivost matrike $A$ lahko precej zmanjšamo, če časovno skalo premaknemo, da je $0$ bliže
dejanskim podatkom. Namesto $t$ uporabimo spremenljivko $t - tau$, kjer je $tau$ premik časovne
skale. Najboljša izbira za $tau$ je na sredini podatkov:

```@example
τ = sum(t)/length(t) # hide
A = hcat(ones(size(t)), t.-τ, (t.-τ).^2, cos.(2pi*t), sin.(2pi*t)) # hide
cond(A)
```

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
QR razcepom. Če je $Q R = A$ QR razcep matrike $A$, so stolpci matrike
$Q$ ortonormirana baza stolpčnega prostora matrike $A$, matrika $R$
vsebuje koeficiente v razvoju stolpcev matrike $A$ po ortonormirani bazi
določeni s $Q$. Projekcija na stolpčni prostor ortogonalne matrike še
lažje izračunamo, saj lahko koeficiente izračunamo s skalarnim produktom
s stolpci $Q$. Matrično skalarni produkt s stolpci matrike pomeni
množenje z transponirano matriko.

$ A = Q R\
R p = Q^T y $

```@example
F = qr(A) # hide
Q = Matrix(F.Q) # hide
p = F.R\(Q'*co2) # hide
norm(A*p-co2)
```

Na isti način deluje tudi vgrajen operator `\`, če je matrika dimenzij
$n times k$ in $k < n$.

```@example
p = A\co2
norm(A*p-co2)
```

== Kaj pa CO2?
<kaj-pa-co2>

Koncentracije CO2 se vztrajno povečuje. Kot kaže naš model, je
naraščanje kvadratično in ne le linearno. To pomeni, da ne le, da se
vsako leto poveča koncentracija, pač pa se vsako leto poveča za večjo
vrednost.

```@example
p
```

Koeficient $p_1$ pove povprečno koncentracijo na sredini merilnega
obdobja. Medtem ko odvod $p_2 + 2 p_3 (t - tau)$ pove za koliko se v
povprečju spremeni koncentracija v enem letu.

```@example
plot(t, p[2].+2*p[3]*(t.-τ), title="Letne spremembe CO2")
```

Lahko poskusimo tudi napovedati prihodnost:

```@example
model(t) =  p[1]+ p[2]*(t-τ) + p[3]*(t-τ)^2 + p[4]*cos(2*pi*t) + p[5]*sin(2*pi*t)
model.([2020, 2030, 2050])
```

#opomba(naslov: [Kaj smo se naučili?])[
- Linearni model je opis, pri katerem *parametri* nastopajo *linearno*.
- Parametre modela poiščemo z *metodo najmanjših kvadratov*.
- Za iskanje parametrov po metodi najmanjših kvadratov je numerično najbolj primeren
  *QR-razcep*, če smo v stiski s prostorom, pa lahko uporabimo *normalni sistem*.
- koncentracija CO2 prav zares narašča.
]
