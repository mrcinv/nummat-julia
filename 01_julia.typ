#import "admonitions.typ": opomba
#import "julia.typ": jlfb, jlf, jl, repl, code_box, pkg, blk, readlines

= Uvod v programski jezik Julia
<sec:1-uvod-julia>

V knjigi bomo uporabili programski jezik #link("https://julialang.org/")[Julia] @bezanson_julia_2017. Zavoljo
učinkovitega izvajanja, uporabe
#link("https://docs.julialang.org/en/v1/manual/types/")[dinamičnih tipov] in
#link("https://docs.julialang.org/en/v1/manual/methods/")[metod, specializiranih glede na signaturo],
ter dobre podpore za interaktivno uporabo, je Julia zelo primerna za programiranje numeričnih metod
in ilustracijo njihove uporabe. V nadaljevanju sledijo kratka navodila, kako začeti z Julio.

Cilji tega poglavja so:
- naučiti se uporabljati Julio v interaktivni ukazni zanki,
- pripraviti okolje za delo v programskem jeziku Julia,
- ustvariti prvi paket in
- ustvariti prvo poročilo v formatu PDF.

Tekom te vaje bomo pripravili svoj prvi paket v Julii, ki bo vseboval parametrično enačbo
#link("https://sl.wikipedia.org/wiki/Geronova_lemniskata")[Geronove lemniskate], in napisali teste,
ki bodo preverili pravilnost funkcij v paketu. Nato bomo napisali skripto, ki uporabi funkcije iz
našega paketa in nariše sliko Geronove lemniskate. Na koncu bomo pripravili lično
poročilo v formatu PDF.

== Namestitev in prvi koraki

Programski jezik Julia namestite tako, da sledite #link("https://julialang.org/downloads/")[navodilom],
in v terminalu poženite ukaz `julia`. Ukaz odpre interaktivno ukazno zanko
(angl. _Read Eval Print Loop_ ali s kratico REPL) in v terminalu se pojavi ukazni pozivnik
#text(green)[`julia>`]. Za ukaznim pozivnikom lahko napišemo posamezne ukaze, ki jih nato
Julia prevede, izvede in izpiše rezultate. Poskusimo najprej s preprostimi izrazi:

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
Funkcije z več argumenti definiramo podobno:

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
vektorji ali matrike. Definiramo jih lahko tudi kot anonimne funkcije. To
so funkcije, ki jih vpeljemo brez imena in jih kasneje ne moremo poklicati po imenu.

#code_box[
  #repl("(x, y) -> sin(x) + y", "#1 (generic function with 1 method)")
]

Anonimne funkcije uporabljamo predvsem kot argumente v drugih funkcijah. Funkcija
```jl map(f, v)``` na primer zahteva za prvi argument funkcijo `f`, ki jo nato aplicira na vsak
element vektorja `v`:

#code_box[
  #repl("map(x -> x^2, [1, 2, 3])", "3-element Vector{Int64}:
  1
  4
  9")
]

Vsaka funkcija v programskem jeziku Julia ima lahko več različnih definicij, glede na kombinacijo tipov argumentov, ki jih podamo. Posamezno
definicijo imenujemo
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
  #repl("v[2:end] # vrne komponente vektorja od druge do zadnje", "2-element Vector{Int64}:
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
Izraz ```jl A\b``` vrne rešitev matričnega sistema $A bold(x) = bold(b)$:

#code_box[
  #repl("A = [1 2; 3 4]; # podpičje prepreči izpis rezultata", "")
  #repl(
    "x =  A \ [5, 6] # reši enačbo A * x = [5, 6]",
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
lahko uporabimo tudi za iskanje rešitve predoločenega sistema po metodi najmanjših kvadratov:

#code_box[
  #repl("[1 2; 3 1; 2 2] \ [1, 2, 3] # rešitev za predoločen sistem", "2-element Vector{Float64}:
 0.5999999999999999
 0.5111111111111114")
]

=== Zanke in kontrolne strukture

Za zanko z znanim številom korakov uporabimo ukaz #jl("for"):

#code_box[
  #repl("for i=1:3
  println(\"Trenutni števec je $i\")
end", "Trenutni števec je 1
Trenutni števec je 2
Trenutni števec je 3")
]

Julia podpira tudi sintakso z ukazom #jl("for i in vektor") podobno kot Python. Namesto
razpona #("1:3"), ki je tipa #jl("LinRange") lahko for zanko izvedemo tudi po vektorju:

#code_box[
  #repl("for i in [2, 3, 1]
  println(\"Trenutni števec je $i\")
end", "Trenutni števec je 2
Trenutni števec je 3
Trenutni števec je 1")
]

Julia omogoča še vrsto drugih konstruktov, ki so v bistvu zanke. Poglejmo si, kako lahko
na tri različne načine, kako iz danega vektorja #jl("v = [1, 2, 3]") sestavimo vektor
funkcijskih vrednosti #jl("[f(1), f(2), f(3)]") za dano funkcijo $f$.

#code_box[
  #repl("v = [1, 2, 3]", none)
  #repl("f(x) = x^2", none)
  #repl("[f(xi) for xi in x] # podobno kot v Pythonu","3-element Vector{Int64}:
  1
  4
  9")
  #repl("f.(v) # operator . je alias za funkcijo broadcast, ki funkcijo aplicira na komponente",
   "3-element Vector{Int64}:
  1
  4
  9"
    )
  #repl("map(f, v)","3-element Vector{Int64}:
  1
  4
  9")
]

Zanko lahko izvedemo tudi z ukazom #jl("while"), ki deluje podobno kot v drugih
programskih jezikih.

Podobno kot v drugih programskih jezikih deluje tudi #jl("if") stavek:

#code_box(repl("if 1 < 2
  println(\"1 je manj kot 2\")
else
  println(\"1 je več ali enako 2\")
end", "1 je manj kot 2"))

Rezultat #jl("if") stavka je enak rezultatu veje, ki se izvede.

#code_box(repl("x = if 1 < 2
  1
else
  2
end","1"))

#pagebreak()
Prejšnji izraz #jl("if/else") krajše zapišemo s tričlenskim operatorjem (#jl("pogoj ? a : b")):

#code_box(repl("x = 1 < 2 ? 1 : 2", "1" ))

Če izpustimo #jl("else") del, je rezultat #jl("if") stavka bodisi rezultat telesa, če je pogoj
izpolnjen, bodisi enak vrednosti #jl("nothing"), če pogoj ni izpolnjen:

#code_box[#repl("x = if 1 > 2
  1
end", none)
#repl("typeof(x)", "Nothing")]

=== Podatkovni tipi<sec:02-tipi>

#link("https://docs.julialang.org/en/v1/manual/types/")[Podatkovne tipe] definiramo z ukazom `struct`. Ustvarimo tip, ki predstavlja točko z dvema koordinatama:

#code_box[
  #repl("struct Tocka
  x
  y
end", none)
]

Ko definiramo nov tip, se avtomatično ustvari tudi funkcija z istim imenom, s katero lahko ustvarimo vrednost novo definiranega tipa. Vrednost tipa #jl("Tocka") ustvarimo s funkcijo `Tocka(x, y)`:

#code_box[
  #repl("T = Tocka(1, 2) # ustvari vrednost tipa Tocka", "Tocka(1, 2)")
  #repl("T.x", "1")
  #repl("T.y", "2")
]

Julia omogoča različne definicije iste funkcije za različne podatkovne tipe. Za določitev tipa argumenta funkcije uporabimo operator `::`. Za primer definirajmo funkcijo, ki izračuna razdaljo med dvema točkama:

#code_box[
  #repl("razdalja(T1::Tocka, T2::Tocka) = sqrt((T2.x - T1.x)^2 + (T2.y - T1.y)^2)", "razdalja (generic function with 1 method)")
  #repl("razdalja(Tocka(1, 2), Tocka(2, 1))", "1.4142135623730951")
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

Nabor funkcij, ki so na voljo v Julii, je omejen, zato pogosto uporabimo knjižnice, ki vsebujejo dodatne funkcije.
Knjižnica funkcij v Julii se imenuje #link("https://julialang.org/packages/")[paket]. Funkcije v
paketu so združene v modul, ki ima isto ime kot paket.

Julia ima vgrajen upravljalnik s paketi, ki omogoča dostop do paketov, ki so del
Julie, kot tudi tistih, ki jih prispevajo uporabniki. Poglejmo si primer, kako
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
Ukazna zanka (REPL) v Julii pozna več načinov, ki so namenjeni različnim
opravilom.
- Osnovni način s pozivom #text(green.darken(20%))[`julia>`] je namenjen vnosu
  kode v Julii.
- Paketni način s pozivom #text(blue)[`pkg>`] je namenjen upravljanju s paketi. V
  paketni način pridemo, če vnesemo znak `]`.
- Način za pomoč s pozivom #text(orange)[`help?>`] je namenjen pomoči. V način za
  pomoč pridemo z znakom `?`.
- Lupinski način s pozivom #text(red)[`shell>`] je namenjen izvajanju ukazov v
  sistemski lupini. V lupinski način vstopimo z znakom `;`.
- Iz posebnih načinov pridemo nazaj v osnovni način s pritiskom na vračalko(⌫).
]

Za primer si oglejmo, kako namestiti knjižnico za ustvarjanje slik in grafov
#link("https://docs.juliaplots.org/latest/")[Plots.jl]. Najprej aktiviramo paketni način z vnosom
znaka `]` za pozivnikom. Nato paket dodamo z ukazom `add`:

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

Vnašanje ukazov v interaktivni zanki je uporabno za preproste ukaze, na primer namesto kalkulatorja,
za resnejše delo pa je bolje kodo shraniti v datoteke. Praviloma imajo datoteke s kodo v jeziku
Julia končnico `.jl`.

Napišimo preprost program. Ukaze, ki smo jih vnesli doslej  , shranimo v datoteko z
imenom `01uvod.jl`. Ukaze iz datoteke poženemo z ukazom ```jl include``` v ukazni zanki:

#code_box[
  #repl("include(\"01uvod.jl\")", "")
]

ali pa v lupini operacijskega sistema:

#code_box[
  #raw("$ julia 01uvod.jl")
]

#opomba(naslov: [Urejevalniki in programska okolja za Julio])[
  Za lažje delo z datotekami s kodo potrebujemo dober urejevalnik besedila,
  ki je namenjen programiranju. Če še nimate priljubljenega urejevalnika,
  priporočam #link("https://code.visualstudio.com/")[VS Code] in #link("https://www.julia-vscode.org/")[razširitev za Julio].

  Če odpremo datoteko s kodo v urejevalniku VS Code, lahko s kombinacijo tipk
  `Ctrl + Enter` posamezno vrstico kode pošljemo v ukazno zanko za Julio,
  da se izvede. Na ta način združimo prednosti
  interaktivnega dela in zapisovanja kode v datoteke `.jl`.
  ]

Priporočam, da večino kode napišete v datoteke. V nadaljevanju bomo spoznali,
kako organizirati datoteke v projekte in pakete tako, da lahko kodo uporabimo na več
mestih.

== Avtomatsko posodabljanje kode

Ko uporabimo kodo iz datoteke v interaktivni zanki, je treba ob vsaki spremembi
datoteko ponovno naložiti z ukazom `include`.
Paket #link("https://timholy.github.io/Revise.jl")[Revise.jl] poskrbi za to, da se
nalaganje zgodi avtomatično vsakič, ko se datoteke spremenijo. Zato najprej namestimo
paket Revise in poskrbimo, da se zažene ob vsakem zagonu Julie.

Naslednji ukazi namestijo paket Revise, ustvarijo mapo `$HOME/.julia/config` in datoteko
`startup,jl`, ki naloži modul Revise ob vsakem zagonu programa `julia`:

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
  #repl("path = homedir() * \"/.julia/config\"", none)
  #repl("mkdir(path)", none)
  #repl("write(path * \"/startup.jl\", startup) # zapišemo startup.jl", none)
]

Okolje za delo z Julio je pripravljeno.

== Priprava korenske mape

Programe, ki jih bomo napisali v nadaljevanju, bomo hranili v mapi `nummat`. Ustvarimo jo z ukazom:

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
  naslov: [Projektno okolje v Julii],
)[Projektno okolje je mapa, ki vsebuje datoteko `Project.toml` z informacijami o paketih in zahtevanih različicah paketov.  Projektno okolje aktiviramo z ukazom ```jl Pkg.activate("pot/do/mape/z/okoljem")``` oziroma v paketnem načinu z:

#code_box[
#pkg("activate pot/do/mape/z/okoljem", none)
]

Uporaba projektnega okolja delno rešuje problem #link(
    "https://sl.wikipedia.org/wiki/Obnovljivost",
  )[ponovljivosti], ki ga najlepše ilustriramo z izjavo #quote[Na mojem računalniku pa koda dela!]. Projektno okolje namreč vsebuje tudi datoteko `Manifest.toml`, ki hrani različice in kontrolne vsote za pakete iz `Project.toml` in vse njihove odvisnosti. Ta informacija omogoča, da Julia naloži vedno iste različice vseh odvisnosti, kot v času, ko je bila datoteka `Manifest.toml` zadnjič posodobljena.

Projektna okolja v Julii so podobna #link("https://docs.python.org/3/library/venv.html")[virtualnim okoljem v Pythonu].
]

Projektnemu okolju dodamo pakete, ki jih bomo uporabili v nadaljevanju. Zaenkrat je to le
paket #link("https://github.com/JuliaPlots/Plots.jl")[Plots.jl], ki ga uporabljamo za risanje grafov:

#code_box[
  #pkg("add Plots", "", env: "nummat")
]

Datoteka `Project.toml` vsebuje le ime paketa `Plots` in identifikacijski niz:

#code_box[
  ```
  [deps]
  Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
  ```
]

Točna verzija paketa `Plots` in vsi paketi, ki jih potrebuje, so zabeleženi  v datoteki `Manifest.toml`.

== Vodenje različic s programom Git

Za vodenje različic priporočam uporabo programa #link("https://git-scm.com/")[Git].
V nadaljevanju bomo opisali, kako v korenski mapi `nummat` pripraviti Git repozitorij in vpisati
datoteke, ki smo jih do sedaj ustvarili.

#opomba(naslov: [Sistem za vodenje različic Git])[
  #link("https://git-scm.com/")[Git] je sistem za vodenje različic, ki je postal _de facto_
standard v razvoju programske opreme in tudi drugod, kjer se dela z besedilnimi
datotekami. Priporočam, da si bralec ustvari svoj Git repozitorij, kjer si uredi
kodo in zapiske, ki jih bo napisal pri spremljanju te knjige.

Git repozitorij lahko hranimo zgolj lokalno na lastnem računalniku, lahko pa ga repliciramo na lastnem strežniku ali na enem od javnih spletnih skladišč
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
Obenem bomo optimizirali potek dela in odpravili ozka grla v postopkih priprave projekta. Ponavljanje vedno istih postopkov nas prisili, da postopke kar se da poenostavimo in ponavljajoča se opravila avtomatiziramo. Na dolgi rok se tako lahko bolj posvečamo dejanskemu reševanju problemov.

Za vajo bomo ustvarili paket `Vaja01`, s katerim bomo narisali
#link(
  "https://sl.wikipedia.org/wiki/Geronova_lemniskata",
)[Geronovo lemniskato].

V mapi `nummat` ustvarimo paket `Vaja01`, v katerega bomo shranili kodo. Nov paket ustvarimo v paketnem načinu z ukazom `generate`:

#code_box[
```shell
$ cd nummat
$ julia
```
#repl(" # pritisnemo ] za vstop v paketni način", none)
#pkg("generate Vaja01", none)
]

Ukaz `generate` ustvari mapo `Vaja01` z osnovno strukturo
#link("https://pkgdocs.julialang.org/v1/creating-packages/")[paketa v Julii]:

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

Paket `Vaja01` nato dodamo v projektno okolje v korenski mapi `nummat`, da bomo lahko kodo iz paketa uporabili v programih in ukazni zanki:

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
enostavnosti bomo v sklopu te knjige projekte ustvarjali s `Pkg.generate`.
]

Osnovna struktura paketa je pripravljena. Paketu bomo v nadaljevanju dodali še:
- kodo (@sec:01koda),
- teste (@sec:01testi) in
- dokumentacijo (@sec:01docs).

== Koda <sec:01koda>

Ko je mapa s paketom `Vaja01` pripravljena, lahko začnemo. Napisali bomo funkcije, ki izračunajo koordinate
Geronove lemniskate:

$
  x(t) = (t^2 - 1) / (t^2 + 1), quad
  y(t) = (2t(t^2 - 1)) / (t^2 + 1)^2.
$

V urejevalniku odpremo datoteko `Vaja01/src/Vaja01.jl` in vanjo shranimo definiciji:

#figure(
  code_box(raw(lang: "jl", block: true, read("Vaja01/src/Vaja01.jl"))),
  caption: [Definicije funkcij v paketu `Vaja01`]
)<pr:Vaja01>

Funkcije iz datoteke `Vaja01/src/Vaja01.jl` lahko uvozimo z ukazom ```jl using Vaja01```, če smo paket `Vaja01` dodali v projektno okolje (`Project.toml`). V mapo `src` sodijo splošno uporabne funkcije, ki jih želimo uporabiti v drugih
programih. V interaktivni zanki lahko sedaj pokličemo novo definirani funkciji:

#code_box[
#repl("using Vaja01", none)
#repl("lemniskata_x(1.2)", "0.180327868852459")
]

V datoteko `Vaja01/doc/01uvod.jl` bomo zapisali preprost program, ki uporabi kodo iz paketa `Vaja01` in nariše lemniskato:

#code_box(jlf("Vaja01/doc/01uvod.jl", 4, 11))

Program `01uvod.jl` poženemo z ukazom:

#code_box[
#repl("include(\"Vaja01/doc/01uvod.jl\")", none)
]

#opomba(
  naslov: [Poganjanje ukaz za ukazom v VS Code],
)[
Če uporabljate urejevalnik #link("https://code.visualstudio.com/")[VS Code] in
 #link("https://github.com/julia-vscode/julia-vscode")[razširitev za Julio], lahko ukaze
iz programa poganjate vrstico za vrstico kar iz urejevalnika. Če pritisnete kombinacijo tipk
`Shift + Enter`, se bo izvedla vrstica, v kateri je trenutno kazalka.
]

Rezultat je slika lemniskate.

#figure(
  image(width: 60%, "img/01_demo.svg"),
  caption: [Geronova lemniskata]
)

== Testi <sec:01testi>

Naslednji korak je, da dodamo avtomatske teste, s katerimi preizkusimo pravilnost kode, ki
smo jo napisali v prejšnjem poglavju. Avtomatski test je preprost program, ki pokliče določeno funkcijo in preveri rezultat.

#opomba(
  naslov: [Avtomatsko testiranje programov],
  [Pomembno je, da pravilnost programov preverimo. Najlažje to naredimo "na roke",
    tako da program poženemo in preverimo rezultat. Testiranje "na roke" ima veliko
    pomankljivosti. Zahteva veliko časa, je lahko nekonsistentno in je dovzetno
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
ki olajša pisanje testov. Vstopna točka za teste je datoteka `test/runtests.jl`. Uporabili bomo makroje #link("https://docs.julialang.org/en/v1/stdlib/Test/#Test.@test")[\@test] in #link(
  "https://docs.julialang.org/en/v1/stdlib/Test/#Test.@testset",
)[\@testset] iz paketa `Test`.

V datoteko `test/runtests.jl` dodamo teste za obe koordinatni funkciji, ki primerjajo izračunane vrednosti s pravimi vrednostmi, ki smo jih izračunali
"na roke":

#figure(
  code_box(
  raw(read("Vaja01/test/runtests.jl"), lang: "jl")),
  caption: [Test funkcij #jl("lemniskata_x") in #jl("lemniskata_y")],
)

#opomba(
  naslov: [Primerjava števil s plavajočo vejico],
  [Pri računanju s števili s plavajočo vejico se izogibajmo primerjanju števil z
  operatorjem `==`, ki števili primerja bit po bit.
  Pri izračunih, v katerih nastopajo števila s plavajočo vejico, pride do zaokrožitvenih napak.
  Zato se različni načini izračuna za isto število praviloma razlikujejo na zadnjih
  decimalkah. Na primer izraz ```jl asin(sin(pi/4)) - pi/4 ```
  ne vrne točne ničle ampak vrednost `-1.1102230246251565e-16`, ki pa je zelo
  majhno število. Za približno primerjavo dveh vrednosti `a` in `b` zato uporabimo izraz
  #math.equation(block: true, numbering: none)[$
    |a - b| < epsilon,
  $]
  kjer je $epsilon$ večji od pričakovane zaokrožitvene napake. V Julii lahko za približno primerjavo števil in vektorjev uporabimo operator `≈`, ki je alias za funkcijo #link("https://docs.julialang.org/en/v1/base/math/#Base.isapprox")[isapprox].],
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

== Dokumentacija <sec:01docs>

Dokumentacija programske kode je sestavljena iz različnih besedil in drugih
virov, npr. videov, ki so namenjeni uporabnikom in razvijalcem programa ali
knjižnice. Dokumentacija vključuje komentarje v kodi, navodila za
namestitev in uporabo programa ter druge vire z razlagami ozadja,
teorije in drugih zadev, povezanih s projektom. Dobra dokumentacija lahko veliko
pripomore k uspehu določenega programa. To še posebej velja za knjižnice.

Slabo dokumentirane kode ne želi nihče uporabljati. Tudi če vemo, da kode ne bo
uporabljal nihče drug razen nas samih, bodimo prijazni do samega sebe v prihodnosti
in pišimo dobro dokumentacijo.

V tej knjigi bomo pisali tri vrste dokumentacije:

- dokumentacijo za posamezne funkcije v sami kodi,
- navodila za uporabnika v datoteki `README.md`,
- poročilo v formatu PDF.

#opomba(
  naslov: [Zakaj format PDF],
)[
  Izbira formata PDF je mogoče presenetljiva za pisanje dokumentacije programske
  kode. V praksi so precej uporabnejše HTML strani. Dokumentacija v obliki HTML
  strani, ki se generira avtomatično v procesu #link(
    "https://en.wikipedia.org/wiki/Continuous_integration",
  )[nenehne integracije], je postala _de facto_ standard. V kontekstu popravljanja domačih nalog in poročil za vaje pa ima format PDF še vedno prednosti, saj ga je lažje pregledovati in popravljati.
]

=== Dokumentacija funkcij in tipov

Funkcije in podatkovne tipe v Julii dokumentiramo tako, da pred definicijo dodamo niz z
opisom funkcije, kot smo to naredili v programu @pr:Vaja01. Več o tem si lahko preberete #link(
  "https://docs.julialang.org/en/v1/manual/documentation/",
)[v poglavju o dokumentaciji] priročnika za Julio.

=== README dokument

Dokument README (preberi me) je namenjen najbolj osnovnim informacijam o paketu. Dokument je vstopna točka za dokumentacijo in navadno vsebuje:
- kratek opis projekta,
- povezavo na dokumentacijo,
- navodila za osnovno uporabo in
- navodila za namestitev.
#figure(
code_box(
  raw(lang:"md", read("Vaja01/README.md"))
),
caption: [Vsebina datoteke README.md, ki vsebuje osnove informacije o projektu.]
)


=== PDF poročilo

V nadaljevanju bomo opisali, kako poročilo pripraviti s paketom #link("https://github.com/JunoLab/Weave.jl")[Weave.jl]. Paket `Weave.jl` omogoča mešanje besedila in programske kode v enem dokumentu: #link("https://en.wikipedia.org/wiki/Literate_programming")[literarnemu programu], kot ga je opisal D. E. Knuth (@knuth84).
Za pisanje besedila bomo uporabili format #link("https://en.wikipedia.org/wiki/Markdown")[Markdown], ki ga bomo dodali kot komentarje v kodi.

Za generiranje PDF dokumentov je potrebno namestiti
#link("https://tug.org/")[TeX/LaTeX]. Priporočam namestitev
#link("https://yihui.org/tinytex/")[TinyTeX] ali #link("https://tug.org/texlive/")[TeX Live], ki pa zasede več prostora na disku.
Po #link("https://yihui.org/tinytex/#installation")[namestitvi] programa
TinyTex moramo dodati še nekaj `LaTeX` paketov, ki jih potrebuje paket Weave. V
terminalu izvedemo naslednji ukaz

#code_box[
```shell
$ tlmgr install microtype upquote minted
```
]

Poročilo pripravimo v obliki literarnega programa. Uporabili bom kar datoteko
`Vaja01/doc/01uvod.jl`, s katero smo pripravili sliko.
V datoteko dodamo besedilo v obliki komentarjev. Če želimo, da se komentarji uporabijo kot besedilo v formatu #link(
  "https://weavejl.mpastell.com/stable/publish/#Supported-Markdown-syntax",
)[Markdown], uporabimo ```jl #'```. Koda in navadni komentarji se v poročilu izpišejo nespremenjeni.

#figure(
  code_box[
  #raw(lang: "jl", block:true, readlines("Vaja01/doc/01uvod.jl", 1, 13))
  ],
  caption: [Vsebina datoteke `01uvod.jl`, iz katere generiramo poročilo.
    Vrstice, ki se začnejo z znakoma `#'`, so v formatu Markdown in bodo v poročilo vključene kot
    oblikovano besedilo.],
)

Poročilo pripravimo z ukazom ```jl Weave.weave```. Ustvarimo program
`Vaja01/doc/makedocs.jl`, ki pripravi pdf dokument:

#figure(code_box(
  raw(read("Vaja01/doc/makedocs.jl"), lang: "jl")
  ),
  caption: [Program za pripravo PDF dokumenta],
)

Program poženemo z ukazom ```jl include("Vaja01/doc/makedocs.jl")``` v Julii. Preden poženemo program `makedocs.jl`, moramo projektnemu okolju `nummat` dodati paket `Weave.jl`.

#code_box[
  #pkg("add Weave", none, env: "nummat")
  #repl("include(\"Vaja01/doc/makedocs.jl\")", none)
]

Poročilo se shrani v datoteko `Vaja01/pdf/01uvod.pdf`.

#figure(
  rect(
  image("img/01uvod.pdf.png", width: 60%)
  ),
  caption: [Poročilo v PDF formatu]
)

#opomba(
  naslov: [Alternativni paketi za pripravo PDF dokumentov],
)[
Poleg paketa `Weave.jl` je na voljo še nekaj programov, ki so primerni za pripravo PDF dokumentov s programi v Julii:

- #link("https://github.com/JuliaLang/IJulia.jl")[IJulia],
- #link("https://github.com/fredrikekre/Literate.jl")[Literate.jl] in
- #link("https://quarto.org/docs/computations/julia.html")[Quadro].

Če potrebujemo več nadzora pri pripravi PDF dokumenta, priporočam uporabo naslednjih programov:

- #link("https://tug.org/")[TeX/LaTeX],
- #link("https://pandoc.org/")[pandoc],
- #link("https://asciidoctor.org/")[AsciiDoctor],
- #link("https://typst.app/")[Typst].
]

#opomba(naslov: [Povezave na temo pisanja dokumentacije])[
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
  ravnamo na enak način kot s kodo.
]

== Zaključek

Ustvarili smo svoj prvi paket, ki vsebuje kodo, avtomatske teste in dokumentacijo. Mapa `Vaja01` bi morala imeti naslednjo strukturo:

#code_box[
```shell
$ tree Vaja01
Vaja01
├── Manifest.toml
├── Project.toml
├── README.md
├── doc
│   ├── 01uvod.jl
│   └── makedocs.jl
├── src
│   └── Vaja01.jl
└── test
    ├── Manifest.toml
    ├── Project.toml
    └── runtests.jl
```
]

Preden nadaljujete, ponovno preverite, če vse deluje tako, kot bi moralo. V Julii aktivirajte projektno okolje:

#code_box[
  #repl("# pritisnite ] za vstop v paketni način", none)
  #pkg("activate .", none)
]

Nato najprej poženemo teste:

#code_box[
  #pkg("test Vaja01", "...
  Testing Vaja01 tests passed", env: "nummat")
]

Na koncu pa poženemo še program `01uvod.jl`:

#code_box[
  #repl("include(\"Vaja01/doc/01uvod.jl\")", none)
]

in pripravimo poročilo:

#code_box[
  #repl("include(\"Vaja01/doc/makedocs.jl\")", none)
]

Priporočam, da si pred branjem naslednjih poglavij vzamete čas in poskrbite, da se zgornji
ukazi izvedejo brez napak.
