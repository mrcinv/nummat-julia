#import "admonitions.typ": opomba
#import "julia.typ": jlb, jl, repl, code_box, pkg, blk

= Uvod v programski jezik Julia

V knjigi bomo uporabili programski jezik #link("https://julialang.org/")[Julia]. Zavoljo
učinkovitega izvajanja, uporabe
#link("https://docs.julialang.org/en/v1/manual/types/")[dinamičnih tipov],
#link("https://docs.julialang.org/en/v1/manual/methods/")[funkcij, specializiranih glede na signaturo],
in dobre podpore za interaktivno uporabo, je Julia zelo primerna za programiranje numeričnih metod
in ilustracijo njihove uporabe. V nadaljevanju sledijo kratka navodila, kako začeti z Julio.

Cilji tega poglavja so:
- naučiti se uporabljati Julio v interaktivni ukazni zanki,
- pripraviti okolje za delo v programskem jeziku Julia,
- ustvariti prvi paket in
- ustvariti prvo poročilo v formatu PDF.

Tekom te vaje bomo pripravili svoj prvi paket v Juliji, ki bo vseboval parametrično enačbo
#link("https://sl.wikipedia.org/wiki/Geronova_lemniskata")[Geronove lemniskate], in napisali teste,
ki bodo preverili pravilnost funkcij v paketu. Nato bomo napisali skripto, ki uporabi funkcije iz
našega paketa in nariše sliko Geronove lemniskate. Na koncu bomo pripravili lično
poročilo v formatu PDF.

== Namestitev in prvi koraki
 
Sledite #link("https://julialang.org/downloads/")[navodilom], namestite
programski jezik Julia in v terminalu poženite ukaz `julia`. Ukaz odpre interaktivno ukazno zanko
(angl. _Read Eval Print Loop_ ali s kratico REPL) in v terminalu se pojavi ukazni pozivnik
#text(green)[`julia>`]. Za ukazni pozivnik lahko napišemo posamezne ukaze, ki jih nato Julia
prevede, izvede in izpiše rezultate. Poskusimo najprej s preprostimi izrazi:

#code_box[
  #repl("1 + 1", "2")
  #repl("sin(pi)", "0.0")
  #repl("x = 1; 2x + x^2", "3")
  #repl("# vse, kar je za znakom #, je komentar, ki se ne izvede", "")
]

=== Funkcije

Funkcije, ki so v programskem jeziku Julia osnovne enote kode, definiramo na več načinov. Kratke
enovrstične funkcije definiramo z izrazom ```jl ime(x) = ...```.

#code_box[
  #repl("f(x) = x^2 + sin(x)", "f (generic function with 1 method)")
  #repl("f(pi/2)", "3.4674011002723395")
]
#pagebreak()
Funkcija z več argumentu definiramo podobno:

#code_box[
  #repl("g(x, y) = x + y^2", "g (generic function with 1 method)")
  #repl("g(1, 2)", "5")
]

Za funkcije, ki zahtevajo več kode, uporabimo ključno besedo ```jl function```:

#code_box[
  #repl(
    "function h(x, y)
  z = x + y
  return z^2
end",
    "h (generic function with 1 method)",
  )
  #repl("h(3, 4)", "49")
]

Funkcije lahko uporabljamo kot vsako drugo spremenljivko. Lahko jih podamo kot
argumente drugim funkcijam in jih združujemo v podatkovne strukture, kot so seznami,
vektorji ali matrike. Funkcije lahko definiramo tudi kot anonimne funkcije. To
so funkcije, ki jih vpeljemo brez imena in jih kasneje tudi ne moremo poklicati po imenu.

#code_box[
  #repl("(x, y) -> sin(x) + y", "#1 (generic function with 1 method)")
]

Anonimne funkcije uporabljamo predvsem kot argumente v drugih funkcijah. Funkcija 
```jl map(f, v)``` na primer zahteva za prvi argument funkcijo `f`, ki jo nato aplicira na vsak
element vektorja:

#code_box[
  #repl("map(x -> x^2, [1, 2, 3])", "3-element Vector{Int64}:
  1
  4
  9")
]

Vsaka funkcija v programskem jeziku Julia ima lahko več različnih definicij, glede na kombinacijo tipov argumentov, ki jih podamo. Posamezno 
definicijo funkcije imenujemo
#link("https://docs.julialang.org/en/v1/manual/methods/#Methods")[metoda]. Ob klicu funkcije Julia izbere najprimernejšo metodo. 

#code_box[
  #repl("k(x::Number) = x^2", "k (generic function with 1 method)")
  #repl("k(x::Vector) = x[1]^2 - x[2]^2", "k (generic function with 2 methods)")
  #repl("k(2)","4")
  #repl("k([1, 2, 3])", "-3")
]

=== Vektorji in matrike

Vektorje vnesemo z oglatimi oklepaji ```jl []```:

#code_box[
  #repl("v = [1, 2, 3]", "3-element Vector{Int64}:
  1
  2
  3")
  #repl("v[1] # vrne prvo komponento vektorja", "1")
  #repl("v[2:end] # vrne zadnji dve komponenti vektorja", "2-element Vector{Int64}:
  2
  3")
  #repl(
    "sin.(v) # funkcijo uporabimo na komponentah vektorja, če imenu dodamo .",
    "3-element Vector{Float64}:
  0.8414709848078965
  0.9092974268256817
  0.1411200080598672",
  )
]

Matrike vnesemo tako, da elemente v vrstici ločimo s presledki, vrstice pa s
podpičji:

#code_box[
  #repl("M = [1 2 3; 4 5 6]", "2×3 Matrix{Int64}:
  1  2  3
  4  5  6
")
]

Za razpone indeksov uporabimo ```jl :```, s ključno besedo ```jl end``` označimo zadnji indeks. Julia avtomatično določi razpon indeksov v matriki:

#code_box[
  #repl("M[1, :] # prva vrstica", "3-element Vector{Int64}:
  1
  2
  3")
  #repl("M[2:end, 1:end-1]", "1×2 Matrix{Int64}:
 4  5")
]

Osnovne operacije delujejo tudi na vektorjih in matrikah. Pri tem moramo vedeti,
da gre za matrične operacije. Tako je na primer `*` operacija množenja matrik ali matrike
z vektorjem in ne morda množenja po komponentah.

#code_box[
  #repl(
    "[1 2; 3 4] * [6, 5] # množenje matrike z vektorjem",
    "2-element Vector{Int64}:
  16
  38",
  )
]

Če želimo operacije izvajati po komponentah, moramo pred operator dodati piko, na kar nas Julia opozori z napako:

#code_box[
#repl(
  "[1, 2] + 1 # seštevanje vektorja in števila ni definirano ",
  "ERROR: MethodError: no method matching +(::Vector{Int64}, ::Int64)
For element-wise addition, use broadcasting with dot syntax: array .+ scalar",)
#repl("[1, 2] .+ 1", "2-element Vector{Int64}:
  2
  3")
]

Posebej uporaben je operator `\`, ki poišče rešitev sistema linearnih enačb.
Izraz ```jl A\b``` vrne rešitev matričnega sistema $A x = b$:

#code_box[
  #repl("A = [1 2; 3 4]; # podpičje prepreči izpis rezultata", "")
  #repl(
    "x =  A \ [5, 6] # rešimo enačbo A * x = [5, 6]",
    "2-element Vector{Float64}:
  -3.9999999999999987
  4.499999999999999",
  )
]

Izračun se izvede v aritmetiki s plavajočo vejico, zato pride do zaokrožitvenih napak in 
rezultat ni povsem točen. Naredimo še preizkus:
#code_box[
  #repl("A * x", "2-element Vector{Float64}:
  5.0
  6.0")
]

Operator `\` deluje za veliko različnih primerov. Med drugim ga 
lahko uporabimo tudi za iskanje rešitve pre-določenega sistema po metodi najmanjših kvadratov:

#code_box[
  #repl("[1 2; 3 1; 2 2] \ [1, 2, 3] # rešitev za predoločen sistem", "2-element Vector{Float64}:
 0.5999999999999999
 0.5111111111111114")
]

=== Moduli

#link("https://docs.julialang.org/en/v1/manual/modules/")[Moduli] pomagajo organizirati 
funkcije v enote in omogočajo uporabo istega imena za različne funkcije in tipe. Module definiramo z ```jl module ImeModula ... end```:

#code_box[
  #repl("module KrNeki
  kaj(x) = x + sin(x)
  čaj(x) = cos(x) - x
  export kaj
end", "Main.KrNeki")
]

Če želimo funkcije, ki so definirane v modulu ```jl ImeModula```, uporabiti izven modula, moramo modul naložiti z ```jl using ImeModula```. Funkcije, ki so izvožene z ukazom ```jl export ime_funkcije``` lahko kličemo kar po imenu, ostalim funkcijam pa moramo dodati ime modula kot predpono. Modulom, ki niso del paketa in so definirani lokalno, moramo dodati piko, ko jih naložimo: 

#code_box[
  #repl("using .KrNeki", "")
  #repl("kaj(1)", "1.8414709848078965")
  #repl("KrNeki.čaj(1)", "-0.45969769413186023")
]

Modul lahko naložimo tudi z ukazom ```jl import ImeModula```. 
V tem primeru moramo vsem funkcijam iz modula dodati ime modula in piko kot predpono.

=== Paketi

Nabor funkcij, ki so na voljo v Juliji, je omejen, zato pogosto uporabimo knjižnice, ki vsebujejo dodatne funkcije. Knjižnica funkcij v Juliji se imenuje #link("https://julialang.org/packages/")[paket]. Funkcije v paketu so združene v modul, ki ima isto ime kot paket.

Julia ima vgrajen upravljalnik s paketi, ki omogoča dostop do paketov, ki so del
Julije, kot tudi tistih, ki jih prispevajo uporabniki. Poglejmo si primer, kako
uporabiti ukaz `norm`, ki izračuna različne norme vektorjev in matrik. Ukaz
`norm` ni del osnovnega nabora funkcij, ampak je del modula `LinearAlgebra`, ki je že
vključen v program Julia. Če želimo uporabiti `norm`, moramo najprej uvoziti
funkcije iz modula `LinearAlgebra` z ukazom ```jl using LinearAlgebra```:

#code_box[
  #repl("norm([1, 2, 3]", "ERROR: UndefVarError: `norm` not defined")
  #repl("using LinearAlgebra", none)
  #repl("norm([1, 2, 3])", "3.7416573867739413")
]

Če želimo uporabiti pakete, ki niso del osnovnega jezika Julia, jih moramo
prenesti z interneta. Za to uporabimo modul `Pkg`. Paketom je namenjen poseben
paketni način vnosa v ukazni zanki. Do paketnega načina pridemo, če za pozivnik vnesemo znak `]`.

#opomba(
  naslov: [Različni načini ukazne zanke],
)[
Julia ukazna zanka (REPL) pozna več načinov, ki so namenjeni različnim
opravilom.
- Osnovni način s pozivom #text(green.darken(20%))[`julia>`] je namenjen vnosu
  kode v Juliji.
- Paketni način s pozivom #text(blue)[`pkg>`] je namenjen upravljanju s paketi. V
  paketni način pridemo, če vnesemo znak `]`.
- Način za pomoč s pozivom #text(orange)[`help?>`] je namenjen pomoči. V način za
  pomoč pridemo z znakom `?`.
- Lupinski način s pozivom #text(red)[`shell>`] je namenjen izvajanju ukazov v
  sistemski lupini. V lupinski način vstopimo z znakom `;`.
- Iz posebnih načinov pridemo nazaj v osnovni način s pritiskom na vračalko(⌫). 
]

Oglejmo si še, kako namestiti knjižnico za ustvarjanje slik in grafov #link("https://docs.juliaplots.org/latest/")[Plots.jl].
Najprej aktiviramo paketni način z vnosom znaka `]` za pozivnikom. Nato paket
dodamo z ukazom `add`.

#code_box[
  #pkg("add Plots", "...")
  #repl("using Plots # naložimo modul s funkcijami iz paketa", none)
  #repl(
    blk("scripts/01_julia.jl","# 01plot"),
    none,
  )
]

#figure(
  image("img/01_graf.svg", width: 60%)
)

=== Datoteke s kodo

Kodo lahko zapišemo tudi v datoteke. Vnašanje ukazov v interaktivni zanki je
uporabno za preproste ukaze na primer namesto kalkulatorja, za resnejše delo pa je bolje kodo shraniti v datoteke. Praviloma imajo datoteke s kodo v jeziku Julia končnico
`.jl`. 

Napišimo preprost skript. Ukaze, ki smo jih vnesli doslej, shranimo v datoteko z
imenom `demo.jl`. Ukaze iz datoteke poženemo z ukazom ```jl include``` v ukazni zanki:

#code_box[
  #repl("include(\"demo.jl\")", "")
]

ali pa v lupini operacijskega sistema:

#code_box[
  #raw("$ julia demo.jl")
]

#opomba(
  naslov: [Urejevalniki in programska okolja za Julijo],
  [
  Za lažje delo z datotekami s kodo potrebujemo dober urejevalnik besedila,
  ki je namenjen programiranju. Če še nimate priljubljenega urejevalnika,
  priporočam #link("https://code.visualstudio.com/")[VS Code] in #link("https://www.julia-vscode.org/")[razširitev za Julio]. 
   
  Če odprete datoteko s kodo v urejevalniku VS Code, lahko s kombinacijo tipk
  `Ctrl + Enter` posamezno vrstico kode
  pošljemo v ukazno zanko za Julio, da se izvede. Na ta način združimo prednosti
  interaktivnega dela in zapisovanja kode v datoteke `.jl`.
  ],
)

Priporočam, da večino kode napišete v datoteke. V nadaljevanju bomo spoznali,
kako organizirati datoteke v projekte in pakete tako, da lahko kodo uporabimo na več 
mestih.

== Priprava delovnega okolja

Z vsako spremembo je treba kodo v interaktivni zanki posodobiti. Paket 
#link("https://timholy.github.io/Revise.jl")[Revise.jl] poskrbi za to, da se
nalaganje zgodi avtomatično vsakič, ko se datoteke spremenijo. Zato namestimo
paket Revise in poskrbimo, da se zažene ob vsakem zagonu interaktivne zanke.

V terminalu poženite program Julia. Naslednji ukazi namestijo paket Revise, ustvarijo mapo `$HOME/.julia/config` in datoteko `startup,jl`, ki naloži paket Revise in se izvede ob vsakem zagonu programa `julia`:

#code_box[
  #repl("# pritisnemo ], da pridemo v paketni način", none)
  #pkg("add Revise", none)
  #repl(
    "startup = \"\"\"
try
  using Revise
catch e
  @warn \"Error initializing Revise\" exception=(e, catch_backtrace())
end
\"\"\"",
    "...",
  )
  #repl("path = homedir() * \"/.julia/config\")", none)
  #repl("mkdir(path)", none)
  #repl("write(path * \"/startup.jl\", startup) # zapišemo startup.jl", none)
]

Okolje za delo z Julio je pripravljeno.

== Priprava korenske mape

Pripravimo najprej korensko mapo, v kateri bomo hranili vse programe, ki jih bomo napisali v nadaljevanju. Imenovali jo bomo `nummat`:

#code_box[
```sh
$ mkdir nummat
```
]

Korenska mapa bo služila kot #link("https://pkgdocs.julialang.org/v1/environments/")[projektno okolje], v katerem bodo zabeleženi vsi paketi, ki jih bomo potrebovali.

#code_box[
  ```sh
$ cd nummat
$ julia
```
  #repl("# s pritiskom na ] vključimo paketni način", none)
  #pkg("activate . # pripravimo projektno okolje v korenski mapi", none) 
  #pkg("", none, env: "nummat")
]

Zgornji ukaz ustvari datoteko `Project.toml` in pripravi novo projektno okolje v mapi `nummat`.

#opomba(
  naslov: [Projektno okolje v Juliji],
)[Projektno okolje je mapa, ki vsebuje datoteko `Project.toml` z informacijami o paketih in zahtevanih različicah paketov.  Projektno okolje aktiviramo z ukazom ```jl Pkg.activate("pot/do/mape/z/okoljem")``` oziroma v paketnem načinu z:

#code_box[
#pkg("activate pot/do/mape/z/okoljem", none)
]

Uporaba projektnega okolja delno rešuje problem #link(
    "https://sl.wikipedia.org/wiki/Obnovljivost",
  )[ponovljivosti], ki ga najlepše ilustriramo z izjavo #quote[Na mojem računalniku pa koda dela!]. Projektno okolje namreč vsebuje tudi datoteko `Manifest.toml`, ki hrani različice in kontrolne vsote za pakete iz `Project.toml` in vse njihove odvisnosti. Ta informacija omogoča, da Julia naloži vedno iste različice vseh odvisnosti, kot v času, ko je bila datoteka `Manifest.toml` zadnjič posodobljena.

Projektna okolja v Juliji so podobna #link("https://docs.python.org/3/library/venv.html")[virtualnim okoljem v Pythonu].
]

Projektnemu okolju dodamo pakete, ki jih bomo potrebovali v nadaljevanju. Zaenkrat je to le
paket #link("https://github.com/JuliaPlots/Plots.jl")[Plots.jl], ki omogoča risanje grafov:

#code_box[
  #pkg("add Plots", "", env: "nummat")
]

== Vodenje različic s programom Git

Priporočamo uporabo programa za vodenje različic #link("https://git-scm.com/")[Git]. V nadaljevanju bomo opisali, kako pripraviti v korenski mapi `nummat` pripraviti Git repozitorij in vpisati datoteke, ki smo jih do sedaj ustvarili.

#opomba(naslov: [Sistem za vodenje različic Git])[
  #link("https://git-scm.com/")[Git] je sistem za vodenje različic, ki je postal _de facto_
standard v razvoju programske opreme pa tudi drugod, kjer se dela s tekstovnimi
datotekami. Priporočamo, da si bralec ustvari svoj Git repozitorij, kjer si uredi
kodo in zapiske, ki jo bo napisal pri spremljanju te knjige. 

Git repozitorij lahko hranimo zgolj lokalno na lastnem računalniku, ali pa ga repliciramo na lastnem strežniku ali na enem od javnih spletnih skladišč
programske kode, na primer #link("https://github.com/")[Github] ali
#link("https://gitlab.com/")[Gitlab].]


Z naslednjim ukazom v mapi `nummat` ustvarimo repozitorij za `git` in
registriramo novo ustvarjene datoteke.

#code_box[
```shell
$ git init .
$ git add .
$ git commit -m "Začetni vpis"
```
]

Z ukazoma `git status` in `git diff` lahko pregledamo, kaj se je spremenilo od zadnjega vpisa. Ko smo zadovoljni s spremembami, jih zabeležimo z ukazoma `git add` in `git commit`. Priporočamo redno uporabo ukaza `git commit`. Pogosti vpisi namreč precej olajšajo nadzor nad spremembami kode in spodbujajo k razdelitvi dela na majhne zaključene probleme, ki so lažje obvladljivi.

== Priprava paketa za vajo

Ob začetku vsake vaje bomo v korenski mapi (`nummat`) najprej ustvarili mapo oziroma #link("https://pkgdocs.julialang.org/v1/creating-packages/")[paket],
v katerem bo shranjena koda za določeno vajo. S ponavljanjem postopka priprave
paketa za vsako vajo posebej se bomo naučili, kako hitro začeti s projektom.
Obenem bomo optimizirali način dela (angl. workflow) in odpravili ozka grla v postopkih priprave projekta. Ponavljanje vedno istih postopkov nas prisili, da postopke kar se da poenostavimo in ponavljajoča se opravila avtomatiziramo. Na dolgi rok se tako lahko bolj posvečamo dejanskemu reševanju problemov.

V mapi `nummat` ustvarimo paket `Vaja01`, v katerega bomo prestavili vso kodo, ki jo bomo napisali v tem poglavju. Nov paket ustvarimo v paketnem načinu z ukazom `generate`:

#code_box[
```shell
$ cd nummat
$ julia
```
#repl(" # pritisnemo ] za vstop v paketni način", none)
#pkg("generate Vaja01", none)
]

Ukaz `generate` ustvari mapo `Vaja01` z osnovno strukturo 
#link("https://pkgdocs.julialang.org/v1/creating-packages/")[paketa v Juliji]:

#code_box[
```shell
$ tree Vaja01
Vaja01
├── Project.toml
└── src
    └── Vaja01.jl

1 directory, 2 files
```
]


Paket nato dodamo v projektno okolje v korenski mapi `nummat`:

#code_box[ 
#pkg("activate . ", none)
#pkg(
  "develop ./Vaja01 # paket dodamo projektnemu okolju",
  none,
  env: "nummat",
)
]



#opomba(
  naslov: [Za obsežnejši projekti uporabite šablone],
)[
Za obsežnejši projekt ali projekt, ki ga želite objaviti, je bolje uporabiti že
pripravljene šablone
#link("https://github.com/JuliaCI/PkgTemplates.jl")[PkgTemplates] ali
#link("https://github.com/tpapp/PkgSkeleton.jl")[PkgSkeleton]. Zavoljo
enostavnosti, bomo v sklopu te knjige projekte ustvarjali s `Pkg.generate`.
]

Paketu `Vaja01` dodamo še teste, skripte in README dokument, tako da bo imela mapa naslednjo strukturo.

#code_box[
```shell
$ tree Vaja01
Vaja01
├── Manifest.toml
├── Project.toml
├── doc
│   └── demo.jl
├── src
│   └── Vaja01.jl
└── test
    └── runtests.jl
```
]

== Koda

Ko je mapa s paketom `Vaja01` pripravljena, lahko začnemo s pisanjem kode. Za vajo bomo narisali 
#link(
  "https://sl.wikipedia.org/wiki/Geronova_lemniskata",
)[Geronove lemniskato]. Najprej definiramo koordinatne funkcije

$
  x(t) = (t^2 - 1) / (t^2 + 1) #h(2em)
  y(t) = 2t(t^2 - 1) / (t^2 + 1)^2.
$

Definicije shranimo v datoteki `Vaja01/src/Vaja01.jl`.

#figure(
  code_box(raw(lang: "jl", block: true, read("Vaja01/src/Vaja01.jl"))),
  caption: [Vsebina datoteke `Vaja01.jl`.],
)

V ukazni zanki lahko sedaj pokličemo novo definirani funkciji.

#code_box[
#pkg("activate .", none)
#repl("using Vaja01", none)
#repl("lemniskata_x(1.2)", "0.180327868852459")
]

Nadaljujemo šele, ko se prepričamo, da lahko pokličemo funkcije iz paketa `Vaja01`.

Kodo, ki bo sledila, bomo sedaj pisali v scripto `Vaja01\doc\demo.jl`. 

#figure(
  code_box(jl("Vaja01/doc/demo.jl", 4, 11)), 
  caption: [Vsebina datoteke `demo.jl`]
)

Skripto poženemo z ukazom:

#code_box[
#repl("include(\"Vaja01/doc/demo.jl\")", none)
]

Rezultat je slika lemniskate.

#figure(
  image(width: 60%, "img/01_demo.svg"),
  caption: [Geronova lemniskata]
)

#opomba(
  naslov: [Poganjanje ukaz za ukazom v VsCode],
)[
Če uporabljate urejevalnik #link("https://code.visualstudio.com/")[VsCode] in
 #link("https://github.com/julia-vscode/julia-vscode")[razširitev za Julio], lahko ukaze
iz skripte poganjate vrstico za vrstico kar iz urejevalnika. Če pritisnete kombinacijo tipk
`Shift + Enter`, se bo izvedla vrstica v kateri je trenutno kazalka.
]

== Testi

V prejšnjem razdelku smo definirali funkcije in napisali skripto, s katero smo
omenjene funkcije uporabili. Naslednji korak je, da dodamo teste, s katerimi
preiskusimo pravilnost napisane kode. 

#opomba(
  naslov: [Avtomatsko testiranje programov],
  [Pomembno je, da pravilnost programov preverimo. Najlažje to naredimo "na roke",
    tako da program poženemo in preverimo rezultat. Testiranja "na roke" ima veliko
    pomankljivosti. Zahteva veliko časa, je lahko nekonsistentno in dovzetno
    za človeške napake. 
    
    Alternativa ročnemu testiranju programov so avtomatski testi.
    To so preprosti programi, ki izvedejo testirani program in
    rezultate preverijo. Avtomatski testi so pomemben del #link(
      "https://sl.wikipedia.org/wiki/Agilne_metode_razvoja_programske_opreme",
    )[agilnega razvoja programske opreme] in omogočajo avtomatizacijo procesov
    razvoja programske opreme, ki se imenuje #link(
      "https://en.wikipedia.org/wiki/Continuous_integration",
    )[nenehna integracija].],
)

Uporabili bomo paket #link("https://docs.julialang.org/en/v1/stdlib/Test/")[Test],
ki olajša pisanje testov. Vstopna točka za teste je datoteka `test\runtests.jl`.

Avtomatski test je preprost program, ki pokliče določeno funkcijo in preveri
rezultat. Najbolj enostavno je rezultat primerjati z v naprej znanim
rezultatom, za katerega smo prepričani, da je pravilen. Uporabili bomo makroje #link("https://docs.julialang.org/en/v1/stdlib/Test/#Test.@test")[\@test] in #link(
  "https://docs.julialang.org/en/v1/stdlib/Test/#Test.@testset",
)[\@testset] iz paketa `Test`.

V datoteko `test/runtests.jl` dodamo teste za obe koordinatni funkciji, ki smo
ju definirali:

#figure(
  code_box(
  raw(read("Vaja01/test/runtests.jl"), lang: "jl")),
  caption: [Testi za paket `Vaja01`],
)

Za primerjavo rezultatov smo uporabili operator `≈`, ki je alias za funkcijo #link("https://docs.julialang.org/en/v1/base/math/#Base.isapprox")[isapprox].

#opomba(
  naslov: [Primerjava števil s plavajočo vejico],
  [Pri računanju s števili s plavajočo vejico se izogibajmo primerjanju števil z
  operatorjem `==`, ki števili primerja bit po bit. 
  Pri izračunih, v katerih nastopajo števila s plavajočo vejico, pride do zaokrožitvenih napak. 
  Zato se različni načini izračuna za isto število praviloma razlikujejo na zadnjih
  decimalkah. Na primer izraz ```jl asin(sin(pi/4)) - pi/4 ``` 
  ne vrne točne ničle ampak vrednost `-1.1102230246251565e-16`, ki pa je zelo
  majhno število. Za približno primerjavo dveh vrednosti `a` in `b` zato uporabimo izraz
  $
    |a - b| < epsilon,
  $
  kjer je $epsilon$ večji, kot pričakovana zaokrožitvena napaka. Funkcija
  `isapprox` je namenjena ravno približni primerjavi.],
)

Preden lahko poženemo teste, moramo ustvariti testno okolje. Sledimo #link(
  "https://docs.julialang.org/en/v1/stdlib/Test/#Workflow-for-Testing-Packages",
)[priporočilom za testiranje paketov]. V mapi `Vaja01/test` ustvarimo novo
okolje in dodamo paket `Test`.

#code_box[
#pkg("activate Vaja01/test", none)
#pkg("add Test", none, env: "test")
#pkg("activate .", none, env: "test")
]

Teste poženemo tako, da v paketnem načinu poženemo ukaz `test Vaja01`.

#code_box[
#pkg("test Vaja01", "Testing Vaja01 
     Testing Running tests
     ...
     ...
Test Summary: | Pass  Total  Time
Koordinata x  |    2      2  0.1s
Test Summary: | Pass  Total  Time
Koordinata y  |    2      2  0.0s
     Testing Vaja01 tests passed", env:"nummat") 
] 

== Dokumentacija

Dokumentacija programske kode je sestavljena iz različnih besedil in drugih
virov, npr. videov, ki so namenjeni uporabnikom in razvijalcem programa ali
knjižnice. Dokumentacija lahko vključuje komentarje v kodi, navodila za
namestitev in uporabo programa in druge vire v raznih formatih z razlagami
ozadja, teorije in drugih zadev povezanih s projektom. Dobra dokumentacija lahko
veliko pripomore k uspehu določenega programa. Sploh to velja za knjižnice. 

Tudi, če kode ne bo uporabljal nihče drug in verjamite, slabo dokumentirane
kode, nihče ne želi uporabljati, bodimo prijazni do nas samih v prihodnosti in
pišimo dobro dokumentacijo.

V tej knjigi bomo pisali 3 vrste dokumentacije:

- dokumentacijo posameznih funkcij in tipov, 
- navodila za uporabnika v datoteki `README.md`,
- poročilo v formatu PDF.

#opomba(
  naslov: [Zakaj format PDF],
)[
  Izbira formata PDF je mogoče presenetljiva za pisanje dokumentacije programske
  kode. V praksi so precej bolj uporabne HTML strani. Dokumentacija v obliki HTML
  strani, ki se generira avtomatično v procesu #link(
    "https://en.wikipedia.org/wiki/Continuous_integration",
  )[nenehne integracije] je postala _de facto_ standard.
   
  V kontekstu popravljanja domačih nalog in poročil na vajah pa ima format PDF še
  vedno prednosti. Saj ga je lažje pregledovati in popravljati.
]

=== Dokumentacija funkcij in tipov

Funkcije in tipe v Julii dokumentiramo tako, da pred definicijo dodamo niz z
opisom funkcije. Več o tem si lahko preberete #link(
  "https://docs.julialang.org/en/v1/manual/documentation/",
)[v priročniku za Julio].

=== Generiranje PDF poročila

Za pisanje dokumentacijo bomo uporabili format
#link("https://en.wikipedia.org/wiki/Markdown")[Markdown], ki ga bomo dodali kot
komentarje v kodi. Knjižnica 
#link("https://github.com/JunoLab/Weave.jl")[Weave.jl] poskrbi za generiranje
PDF poročila.

Za generiranje PDF dokumentov je potrebno namestiti
#link("https://tug.org/")[TeX/LaTeX]. Priporočam namestitev
#link("https://yihui.org/tinytex/")[TinyTeX] ali #link("https://tug.org/texlive/")[TeX Live],
ki pa zasede več prostora na disku.
Po #link("https://yihui.org/tinytex/#installation")[namestitvi] programa
TinyTex moramo dodati še nekaj `LaTeX` paketov, ki jih potrebuje paket Weave. V
terminalu izvedemo naslednji ukaz

#code_box[
```shell
$ tlmgr install microtype upquote minted
```
]

Poročilo pripravimo v obliki demo skripte. Uporabili bom kar
`Vaja01/doc/demo.jl`, ki smo jo ustvarili, da smo generirali sliko.

V datoteko dodamo besedilo v obliki komentarjev. Komentarje, ki se začnejo z
```jl #'```, paket `Weave` uporabi kot tekst v formatu #link(
  "https://weavejl.mpastell.com/stable/publish/#Supported-Markdown-syntax",
)[Markdown], medtem ko se koda in navadni komentarji v poročilu izpišejo kot
koda.

#figure(
  code_box[
  #raw(lang: "jl", block:true, read("Vaja01/doc/demo.jl"))
  ],
  caption: [Vsebina `Vaja01/doc/demo.jl`, po tem, ko smo dodali komentarje s tekstom v
  formatu Markdown],
)

Poročilo pripravimo z ukazom ```jl Weave.weave```. Ustvarimo še eno skripto
`Vaja01\doc\makedocs.jl`, v katero dodamo naslednje vrstice

#figure(code_box(
  raw(read("Vaja01/doc/makedocs.jl"), lang: "jl")
  ),
  caption: [Program za generiranje PDF dokumenta],
)
Skripto poženemo v julii z ukazom ```jl include("Vaja01/doc/makedocs.jl")```. Poročilo najdemo  v datoteki `Vaja01/pdf/demo.pdf`.

Poleg paketa Weave.jl je na voljo še nekaj programov, ki so primerni za pripravo poročil:

- #link("https://github.com/JuliaLang/IJulia.jl")[IJulia],
- #link("https://github.com/fredrikekre/Literate.jl")[Literate.jl] ali
- #link("https://quarto.org/docs/computations/julia.html")[Quadro].

Navedimo še nekaj zanimivih povezav, ki so povezane s pisanjem dokumentacije:

- #link(
    "https://docs.julialang.org/en/v1/manual/documentation/",
  )[Pisanje dokumentacije] v jeziku Julia.
- #link("https://docs.julialang.org/en/v1/manual/style-guide/")[Priporočila za stil] za programski jezik Julia.
- #link("https://documenter.juliadocs.org/stable/")[Documenter.jl] je najbolj
  razširjen paket za pripravo dokumentacije v Julii.
- #link("https://diataxis.fr/")[Diátaxis] je sistematičen pristop k pisanju
  dokumentacije.
- #link(
    "https://www.writethedocs.org/guide/docs-as-code/",
  )[Dokumentacija kot koda] je ime za način dela, pri katerem z dokumentacijo
  ravnamo na enak način, kot ravnamo s kodo.
