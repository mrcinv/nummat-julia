#import "admonitions.typ": opomba
#import "julia.typ": jlfb, out, repl, blk, code_box, pkg, jl, readlines

= Računanje kvadratnega korena<sec:02-koren>

Računalniški procesorji navadno implementirajo le osnovne številske operacije:
seštevanje, množenje in deljenje. Za računanje drugih matematičnih funkcij
mora nekdo napisati program. Večina programskih jezikov vsebuje implementacijo elementarnih funkcij v standardni knjižnici. V tej vaji si bomo ogledali, kako implementirati korensko funkcijo.


#opomba(
  naslov: [Implementacija elementarnih funkcij v Julii],
[ Lokacijo metod, ki računajo določeno funkcijo, lahko dobite z ukazoma #jl("methods") in #jl("@which").
Tako bo ukaz #jl("methods(sqrt)") izpisal implementacije kvadratnega korena za vse podatkovne tipe,
ki jih Julia podpira. Ukaz #jl("@which(sqrt(2.0))") pa razkrije metodo, ki računa koren za
vrednost `2.0`, to je za števila s plavajočo vejico.]
)

== Naloga

Napiši funkcijo `y = koren(x)`, ki bo izračunala približek za kvadratni koren števila `x`. Poskrbi, da bo rezultat pravilen na 10 decimalnih mest in da bo časovna zahtevnost neodvisna od argumenta `x`.

- Zapiši enačbo, ki ji zadošča kvadratni koren.
- Uporabi #link("https://en.wikipedia.org/wiki/Newton%27s_method")[Newtonovo metodo] in izpelji #link("https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Heron's_method")[Heronovo rekurzivno formulo] za računanje kvadratnega korena.
- Kako je konvergenca odvisna od vrednosti `x`?
- Nariši graf potrebnega števila korakov v odvisnosti od argumenta `x`.
- Uporabi lastnosti #link("https://sl.wikipedia.org/wiki/Plavajo%C4%8Da_vejica")[zapisa s plavajočo vejico] in izpelji formulo za približno vrednost korena, ki uporabi eksponent (funkcija #link("https://docs.julialang.org/en/v1/base/numbers/#Base.Math.exponent")[exponent] v Julii).
- Implementiraj funkcijo `koren(x)`, tako da je časovna zahtevnost neodvisna od argumenta `x`. Grafično preveri, ali funkcija dosega zahtevano natančnost za poljubne vrednosti argumenta `x`.


Preden se lotimo reševanja, ustvarimo projekt za trenutno vajo in ga dodamo v delovno okolje.

#code_box(
    [
        #pkg("generate Vaja02", none, env: "nummat")
        #pkg("develop Vaja02/", none, env: "nummat")
    ]
)

Tako bomo imeli v delovnem okolju dostop do vseh funkcij, ki jih bomo definirali v paketu `Vaja02`.

== Izbira algoritma

Z računanjem kvadratnega korena so se ukvarjali že pred 3500 leti v Babilonu. O tem si lahko več preberete v #link("http://www.presek.si/21/1160-Domajnko.pdf")[članku v reviji Presek]. Če želimo poiskati algoritem za računanje kvadratnega korena, se moramo najprej vprašati, kaj sploh je kvadratni koren. Kvadratni koren števila $x$ je definiran kot pozitivna vrednost $y$, katere kvadrat je enak $x$. Število $y$ je torej pozitivna rešitev enačbe

$ y^2 = x. $ <eq:02koren>

Da bi poiskali vrednost $sqrt(x)$, moramo rešiti _nelinearno enačbo_ @eq:02koren. Za numerično reševanje nelinearnih enačb obstaja cela vrsta metod. Ena najpopularnejših metod je #link("https://sl.wikipedia.org/wiki/Newtonova_metoda")[Newtonova ali tangentna] metoda, ki jo bomo uporabili tudi mi. Pri Newtonovi metodi rešitev enačbe

$ f(x) = 0 $

poiščemo z rekurzivnim zaporedjem približkov

$ x_(n+1) = x_n - f(x_n)/(f'(x_n)). $ <eq:02newton>

Če zaporedje @eq:02newton konvergira, potem konvergira k rešitvi enačbe $f(x)=0$.

Enačbo @eq:02koren najprej preoblikujemo v obliko, ki je primerna za reševanje z Newtonovo metodo. Premaknemo vse člene na eno stran, da je na drugi strani nič

$
y^2 - x = 0.
$

V formulo za Newtonovo metodo vstavimo funkcijo $f(y) = y^2 - x$ in odvod $f'(y) = (d f)/(d y) = 2y$, da dobimo formulo:

$
y_(n+1) &= y_n - (y_n^2 - x)/(2y_n) = (2y_n^2 - y_n^2 + x)/(2y_n) = 1/2((y_n^2 + x)/(y_n))\
y_(n+1) &= 1/2(y_n + x/y_n).
$ <eq:02heron>

Rekurzivno formulo @eq:02heron imenujemo
#link("https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Heron's_method")[Heronov obrazec].
Zgornja formula določa zaporedje, ki vedno konvergira bodisi k $sqrt(x)$ ali $-sqrt(x)$, odvisno od
izbire začetnega približka. Poleg tega, da zaporedje hitro konvergira k limiti, je program izjemno
preprost. Poglejmo, kako izračunamo $sqrt(2)$:

#code_box([
#repl(blk("scripts/02_koren.jl","# koren1"), read("out/02_koren_1.out"))
]
)
Vidimo, da se približki začnejo ponavljati že po 4. koraku. To pomeni, da se zaporedje ne bo več spreminjalo in smo dosegli najboljši približek, kot ga lahko predstavimo s 64 bitnimi števili s plavajočo vejico.

Napišimo zgornji program še kot funkcijo. Da lažje spremljamo, kaj se dogaja med izvajanjem kode, uporabimo makro
#jl("@info") iz modula #link("https://docs.julialang.org/en/v1/stdlib/Logging/")[Logging], ki je del standardne knjižnice.

#figure(
  jlfb(
    "Vaja02/src/koren.jl",
    "# koren_heron"
  ),
  caption: [Funkcija, ki računa kvadratni koren s Heronovim obrazcem.]
)

Preskusimo funkcijo #jl("koren_heron") na številu 3.

#jlfb("scripts/02_koren.jl", "# koren3")
#out("out/02_koren_3.out")

#opomba(
  naslov: "Metoda navadne iteracije in tangentna metoda",
  [Metoda računanja kvadratnega korena s Heronovim obrazcem je poseben primer
  #link("https://sl.wikipedia.org/wiki/Newtonova_metoda")[tangentne metode], ki je poseben
  primer #link("https://sl.wikipedia.org/wiki/Metoda_navadne_iteracije")[metode fiksne točke]. Obe metodi sta si bomo podrobneje ogledali kasneje.
  ]
)

== Določitev števila korakov

Funkcija `koren_heron(x, x0, n)` ni uporabna za splošno rabo, saj mora uporabnik poznati tako začetni približek kot tudi število korakov, ki so potrebni, da dosežemo želeno natančnost. Da bi bila funkcija zares uporabna, bi morala sama izbrati začetni približek in število potrebnih korakov. Najprej se bomo naučili poiskati dovolj veliko število korakov, da dosežemo želeno natančnost.

#opomba(naslov: [Relativna in absolutna napaka])[
    Kako vemo, kdaj smo dosegli želeno natančnost? Navadno nekako ocenimo napako približka in jo primerjamo z želeno natančnostjo. To lahko storimo na dva načina, tako da:

    - preverimo, ali je absolutna napaka manjša od *absolutne tolerance* ali
    - preverimo, ali je relativna napaka manjša od *relativne tolerance*.

    Julia za namen primerjave dveh števil ponuja funkcijo #link("https://docs.julialang.org/en/v1/base/math/#Base.isapprox")[`isapprox`], ki pove ali sta dve vrednosti približno enaki. Funkcija `isapprox` omogoča relativno in absolutno primerjavo vrednosti. Primerjava števil z relativno toleranco $delta$ se
    prevede na neenačbo

    $
        | a - b | < delta(max(|a|, |b|)).
    $ <eq:02-isapprox>

    Ko uporabljamo relativno primerjavo, moramo biti previdni, če primerjamo vrednosti s številom $0$. Če je namreč eno od števil, ki ju primerjamo, enako 0 in $delta < 1$, potem neenačba  @eq:02-isapprox nikoli ni izpolnjena.

    *Število $0$ nikoli ni približno enako nobenemu neničelnemu številu, če ju primerjamo z relativno toleranco.*
]

#opomba(naslov: [Število pravilnih decimalnih mest])[
    Ko govorimo o številu pravilnih decimalnih mest, imamo navadno v mislih število signifikantnih mest v zapisu s plavajočo vejico. V tem primeru moramo poskrbeti, da je relativna napaka dovolj majhna. Če želimo, da bo 10 signifikantnih mest pravilnih, mora biti relativna napaka manjša od $5 dot 10^(-11)$. Naslednja števila so vsa podana s 5 signifikantnimi mesti:
    $
        1/70 &approx 0.014285, quad 1/7 &approx& 0.14285\
        10/7 &approx 1.4285,  quad 10^(10)/7 &approx& 1428500000.
    $
]

Pri iskanju kvadratnega korena lahko napako ocenimo tako, da primerjamo kvadrat približka z danim argumentom. Pri tem je treba raziskati, kako sta povezani relativni napaki približka za koren in njegovega kvadrata. Naj bo $y$ točna vrednost kvadratnega korena $sqrt(x)$. Če je $hat(y)$ približek z relativno napako $delta$, potem je $hat(y)=y(1+delta)$. Poglejmo, kako je relativna napaka $delta$ povezana z relativno napako kvadrata $hat(y)^2$.
 $
 epsilon = (hat(y)^2 - x)/x = ((y(1 + delta))^2 - x)/x =
 (x(1+delta)^2 - x)/x =  (1 + delta)^2 - 1 = 2delta + delta^2.
 $
Pri tem smo upoštevali, da je $y^2=x$. Relativna napaka kvadrata je enaka $epsilon = 2delta + delta^2$. Ker je $delta^2 << delta$, dobimo dovolj natančno oceno, če $delta^2$ zanemarimo

$
delta = 1/2(epsilon - delta^2) < epsilon/2.
$

Od tod dobimo pogoj, kdaj je približek dovolj natančen. Če je

$
|hat(y)^2 - x| < 2delta dot x
$

potem velja začetna zahteva:

$
|hat(y) - sqrt(x)| < delta dot sqrt(x).
$ <eq:02pogoj>

#opomba(naslov: [Ocene za napako ni vedno lahko poiskati])[
    V primeru računanja kvadratnega korena je bila analiza napak relativno enostavna in smo lahko dobili točno oceno za relativno napako metode. Večinoma ni tako. Točne ocene za napako ni vedno lahko ali sploh mogoče poiskati. Zato pogosto v praksi napako ocenimo na podlagi različnih indicev brez zagotovila, da je ocena točna.

    Pri iterativnih metodah konstruiramo zaporedje približkov $x_n$, ki konvergira k iskanemu številu. Razlika med dvema zaporednima približkoma $|x_(n+1) - x_n|$ je pogosto dovolj dobra ocena za napako iterativne metode. Toda zgolj dejstvo, da je razlika med zaporednima približkoma majhna, še ne zagotavlja, da je razlika do limite prav tako majhna. Če poznamo oceno za hitrost konvergence (oziroma odvod iteracijske funkcije), lahko izpeljemo zvezo med razliko dveh sosednjih približkov in napako metode. Vendar se v praksi pogosto zanašamo, da sta razlika sosednjih približkov in napaka sorazmerni. Problem nastane, če je konvergenca počasna.]

Uporabimo pogoj @eq:02pogoj in napišemo
funkcijo, ki sama določi število korakov iteracije:

#figure(
    jlfb("Vaja02/src/koren.jl", "# koren2"),
    caption: [Metoda `koren(x, y0)`, ki avtomatsko določi število korakov iteracije]
) <code:02-koren-x-y0>

== Izbira začetnega približka

Kako bi učinkovito izbrali dober začetni približek? Dokazati je mogoče, da rekurzivno zaporedje @eq:02heron konvergira ne glede na izbran začetni približek. Problem je, da je število korakov iteracije večje, dlje kot je začetni približek oddaljen od rešitve. Če želimo, da bo časovna zahtevnost funkcije neodvisna od argumenta, moramo poskrbeti, da za poljubni argument uporabimo dovolj dober začetni približek. Poskusimo lahko za začetni približek uporabiti kar samo število $x$. Malce boljši približek dobimo s Taylorjevim razvojem korenske funkcije okrog števila 1

$
sqrt(x) = 1 + 1/2(x-1) + ... approx 1/2 + x/2.
$

Opazimo, da za večja števila, iteracija potrebuje več korakov:

#code_box(
    repl(blk("scripts/02_koren.jl", "# koren5"), read("out/02_koren_5.out"))
)

Začetni približek $1/2 + x/2$ dobro deluje za števila blizu 1. Če isto formulo za začetni približek uporabimo na večjih številih, dobimo večjo relativno napako oziroma potrebujemo več korakov zanke, da pridemo do enake natančnosti. Na isti graf narišimo korensko funkcijo in tangento $1/2 + x/2$:

#code_box(
    jlfb("scripts/02_koren.jl", "# koren6")
)

#figure(
    image("img/02_koren_tangenta.svg", width: 80%),
    caption: [Korenska funkcija in tangenta v $1/2 + x/2$]
)

Za boljši približek, si pomagamo z načinom predstavitve števil v računalniku. Realna števila predstavimo s #link("https://sl.wikipedia.org/wiki/Plavajo%C4%8Da_vejica")[števili s plavajočo vejico]. Število je zapisano v obliki

$
 x = m 2^e,
$

kjer je $1 <= m < 2$ mantisa, $e$ pa eksponent. Za 64 bitna števila s plavajočo vejico se za
zapis mantise uporabi 53 bitov (52 bitov za decimalke, en bit pa za predznak), 11 bitov pa za
eksponent (glej #link("https://en.wikipedia.org/wiki/IEEE_754")[IEE 754 standard]). Koren števila
$x$ potem izračunamo kot

$
sqrt(x) = sqrt(m) dot 2^(e/2).
$

Koren mantise, ki leži na $[1, 2)$, približno ocenimo s tangento v $x=1$

$
sqrt(m) = 1/2 + m/2.
$

Če eksponent delimo z $2$ in upoštevamo ostanek $e = 2d + o$, vrednost $sqrt(2^e)$ zapišemo kot

$
sqrt(2^e) approx 2^d dot cases(1";" quad  o = 0, sqrt(2)";" quad o=1.)
$

Formula za približek je enaka:

$
sqrt(x) approx (1/2 + m/2) dot 2^d dot cases(1";" quad  o = 0, sqrt(2)";" quad o=1)
$

Potenco števila $2^n$ lahko izračunamo s premikom binarnega zapisa števila $1$ v levo za $n$ mest. V Julii za levi premik uporabimo operator #jl("<<"), s funkcijama #jl("exponent") in #jl("significand") pa dobimo eksponent in mantiso števila s plavajočo vejico. Tako lahko zapišemo naslednjo funkcijo za začetni približek:

#figure(
    code_box(
        jlfb("Vaja02/src/koren.jl", "# zacetni")
    ),
    caption: [Funkcija `zacetni(x)`, ki izračuna začetni približek]
)

Primerjajmo izboljšano verzijo začetnega približka s pravo korensko funkcijo.

#code_box(
    jlfb("scripts/02_koren.jl", "# koren7")
)

#figure(
    image("img/02_koren_zacetni.svg", width: 80%),
    caption: [Korenska funkcija in izboljšani začetni približek]
)

== Zaključek

Ko smo enkrat izbrali dober začetni približek, tudi Newtonova iteracija hitreje konvergira, ne glede na velikost argumenta. Tako
lahko definiramo metodo #jl("koren(x)") brez dodatnega argumenta.

#figure(
    jlfb("Vaja02/src/koren.jl", "# koren_x"),
    caption: [Funkcija `koren(x)`]
) <code:02-koren-x>

#opomba(naslov: [Julia omogoča več definicij iste funkcije])[
    Julia uporablja posebno vrsto #link("https://en.wikipedia.org/wiki/Polymorphism_(computer_science)")[polimorfizma] imenovano #link("https://docs.julialang.org/en/v1/manual/methods/#Methods")[večlična razdelitev] (angl. multiple dispatch). Za razliko od polmorfizma
    v objektno orientiranih jezikih, kjer se metoda izbere ne le na podlagi razreda
    objekta, ki to metodo kliče, se v Julii metodo izbere na podlagi tipov vseh vhodnih argumentov.
    Ta lastnost omogoča pisanje generične kodo, ki deluje za zelo različne vhodne argumente.

    Večlična razdelitev omogoča, da za isto funkcijo definiramo več različic, ki se uporabijo glede na to, katere argumente podamo funkciji. Tako smo definirali dve metodi za funkcijo `koren`. Prva metoda sprejme 2 argumenta, druga pa en argument. Ko pokličemo #jl("koren(2.0, 1.0)"), se izvede različica @code:02-koren-x-y0, ko pa pokličemo #jl("koren(2.0)"), se izvede @code:02-koren-x.

    Metode, ki so definirane za neko funkcijo #jl("fun"), lahko vidimo z ukazom #jl("methods(fun)"). Metodo, ki se uporabi za določen klic funkcije, lahko poiščemo z makrojem #jl("@which"), npr. #jl("@which koren(2.0, 1.0)").
]

Opazimo, da se število korakov ne spreminja več z naraščanjem argumenta, kar pomeni, da je časovna zahtevnost funkcije ```jl koren(x)``` neodvisna od izbire argumenta.

#code_box(
    repl(blk("scripts/02_koren.jl", "# koren8"), read("out/02_koren_8.out"))
)


#opomba(naslov: [Hitro računanje obratne vrednosti kvadratnega korena])[
Pri razvoju računalniških iger, ki poskušajo verno prikazati 3-dimenzionalni svet na zaslonu, se veliko uporablja normiranje
vektorjev. Pri normiranju je treba komponente vektorja deliti z normo vektorja, ki je enaka korenu vsote kvadratov komponent. Kot smo
spoznali pri računanju kvadratnega korena s Heronovim obrazcem, je posebej problematično poiskati ustrezen začetni približek, ki je dovolj blizu pravi rešitvi. Tega problema so se zavedali tudi inženirji igre Quake, ki so razvili posebej zvit, skoraj magičen način za izračun funkcije $1/sqrt(x).$
Metoda uporabi posebno vrednost `0x5f3759df`, da pride do dobrega začetnega
približka, nato pa še en korak #link("https://sl.wikipedia.org/wiki/Newtonova_metoda")[Newtonove metode].
Več o #link("https://en.wikipedia.org/wiki/Fast_inverse_square_root")[računanju obratne vrednosti kvadratnega korena].
]

#opomba(naslov: [Kaj smo se naučili?])[
- Tudi za izračun preprostih funkcij potrebujemo numeričen algoritem.
- Pri iterativnih metodah je pomembna izbira dobraga začetnega približka.
- Numerični algoritmi so pogosto preprosti, vendar moramo paziti, da
  je napaka omejena.
]

// #figure(
//   table(columns: 1, align: left,
//   [ #jl("exponent") - vrni eksponenet števila s plavajočo vejico],
//   [ #jl("significand") - vrni mantiso števila s plavajočo vejico],
//     [
//      #jl("surface") - nariši ploskev v prostoru],

//      [#jl("spy") - grafično predstavi neničelne elemente matrike]
//   ),
//   caption: [Funkcije v Julii, ki smo jih uporabili v @sec:02-koren.]
// )
