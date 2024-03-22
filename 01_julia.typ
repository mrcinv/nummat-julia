#import "admonitions.typ": opomba
#import "julia.typ": jlb, jl, repl, code_box, pkg

= Uvod v programski jezik Julia

V knjigi bomo za implementacijo algoritmov in ilustracijo uporabe izbrali
programski jezik 
#link("https://julialang.org/")[julia]. Zavoljo učinkovitega izvajanja, uporabe
#link("https://docs.julialang.org/en/v1/manual/types/")[dinamičnih tipov],
#link(
  "https://docs.julialang.org/en/v1/manual/methods/",
)[funkcij specializiranih glede na signaturo]
in dobre podporo za interaktivno uporabo, je #link("https://julialang.org/")[julia] zelo
primerna za implementacijo numeričnih metod in ilustracijo njihove uporabe. V
nadaljevanju sledijo kratka navodila, kako začeti z `julio` in si pripraviti
delovno okolje v katerem bo pisanje kode steklo čim bolj gladko.

Cilji tega poglavja so
- da se naučimo uporabljati Julio v interaktivni ukazni zanki,
- da si pripravimo okolje za delo v programskem jeziku Julia,
- da ustvarimo prvi paket in
- da ustvarimo prvo poročilo v formatu PDF.

Tekom te vaje bomo pripravili svoj prvi paket v Juliji,
ki bo vseboval parametrično enačbo #link(
  "https://sl.wikipedia.org/wiki/Geronova_lemniskata",
)[Geronove lemniskate]. Napisali bomo teste, ki bodo preverili
pravilnost funkcij v paketu. Nato bomo napisali skripto, ki uporabi funkcijo iz našega paketa
in nariše sliko Geronove lemniskate. Na koncu bomo pripravili lično poročilo v formatu PDF. 

== Namestitev in prvi koraki
 
Sledite #link("https://julialang.org/downloads/")[navodilom] in namestite programski jezik Julia.
Nato lahko v terminalu poženete ukaz `julia`. Ukaz odpre interaktivno ukazno zanko 
(angl. _Read Eval Print Loop_ ali s kratico REPL) in v terminalu se pojavi ukazni poziv 
#text(green)[`julia>`]. 
Za ukazni poziv lahko napišemo posamezne ukaze, ki jih nato `julia` prevede, izvede in izpiše 
rezultate. Poskusimo najprej s preprostimi izrazi

#code_box[
#repl("1 + 1", "2")
#repl("sin(pi)", "0.0")
#repl("x = 1; 2x + x^2", "3")
]

=== Funkcije

Funkcije lahko definiramo na več načinov.

#code_box[
#repl("f(x) = x^2 + sin(x)",
"f (generic function with 1 method)"
)
#repl("f(pi/2)", "3.4674011002723395")
]

Za funkcije, ki zahtevajo več kode, uporabimo ```jl function```.

#code_box[
#repl(
"function g(x, y)
  z = x + y
  return z^2
end",
"g (generic function with 1 method)")
]

=== Vektorji in matrike

Vektorje lahko vnesemo z oglatimi oklepaji ```jl []```:

#code_box[
#repl("v = [1, 2, 3]", 
"3-element Vector{Int64}:
  1
  2
  3")
#repl("v[1] # prvi indeks je 1", "1")
#repl("v[2:end] # zadnja dva elementa",
"2-element Vector{Int64}:
 2
 3")
#repl("sin.(v) # funkcije lahko apliciramo na elementih (operator .)", 
"3-element Vector{Float64}:
 0.8414709848078965
 0.9092974268256817
 0.1411200080598672")
]

Matrike vnesemo tako, da elemente v vrstici ločimo s presledki, vrstice pa s podpičji.

#code_box[
#repl("M = [1 2 3; 4 5 6]", 
"2×3 Matrix{Int64}:
 1  2  3
 4  5  6
")
#repl("M[1, :] # prva vrstica",
"3-element Vector{Int64}:
 1
 2
 3")
]

=== Paketi

#opomba(naslov: [Različni načini ukazne zanke])[
Julia ukazna zanka (REPL) pozna več načinov, ki so namenjeni različnim opravilom.
- Osnovni način s pozivom #text(green)[`julia>`] je namenjen vnosu kode v Juliji.
- Paketni način s pozivom #text(blue)[`pkg>`] je namenjen upravljanju s paketi. V paketni način pridemo, če vnesemo znak `]`.
- Način za pomoč s pozivom #text(yellow)[`help?>`] je namenjen pomoči. V način za pomoč pridemo z znakom `?`.
- Lupinski način s pozivom #text(red)[`shell>`] je namenjen izvajanju ukazov v sistemski lupini. V lupinski način vstopimo z znakom `;`.
]

== Priprava delovnega okolja

Vnašanje ukazov v interaktivni zanki je lahko uporabno namesto kalkulatorja.
Vendar je za resnejše delo bolje kodo shraniti v datoteke. Med razvojem, se
datoteke s kodo nenehno spreminjajo, zato je treba kodo v interaktivni zanki
vseskozi posodabljati. Paket 
#link("https://timholy.github.io/Revise.jl")[Revise.jl] poskrbi za to, da se
nalaganje zgodi avtomatično, ko se datoteke spremenijo. Zato najprej namestimo
paket _Revise_ in poskrbimo, da se zažene ob vsakem zagonu interaktivne zanke.

Odprite julia in sledite ukazom spodaj.

#code_box[
#repl("# pritisnemo ], da pridemo v paketni način", none)
#pkg("add Revise", none)
#pkg("# pritisnemo Backspace, da pridemo iz paketnega načina", none)
#repl(
"startup = \"\"\"
  try
    using Revise
  catch e
    @warn \"Error initializing Revise\" exception=(e, catch_backtrace())
  end
\"\"\"", "...")
#repl("path = homedir() * \"/.julia/config\") # ustvarimo direktorij", none)
#repl("write(path * \"/startup.jl\", startup) # zapišemo startup.jl", none)
]


Okolje za delo z _julio_ je pripravljeno.

#opomba(
  naslov: [Urejevalniki in programska okolja za _julio_],
  [
    Za lažje delo z datotekami s kodo potrebujete dober urejevalnik golega besedila,
    ki je namenjen programiranju. Če še nimate priljubljenega urejevalnika,
    priporočam #link("https://code.visualstudio.com/")[VS Code] in #link("https://www.julia-vscode.org/")[razširitev za Julio].
  ],
)

== Priprava projektne mape

Pripravimo mapo, v kateri bomo hranili programe. Datoteke bomo organizirali
tako, da bo vsaka vaja #link("https://pkgdocs.julialang.org/v1/creating-packages/")[paket] v
svoji mapi, korenska mapa pa bo služila kot
#link("https://pkgdocs.julialang.org/v1/environments/")[delovno okolje]. 

Pripravimo najprej korensko mapo. Imenovali jo bomo `nummat-julia`, lahko si pa
izberete tudi drugo ime.

#code_box[
```sh
$ mkdir nummat-julia
$ cd nummat-julia
$ julia
```
]

Nato v korenski mapi pripravimo 
#link("https://pkgdocs.julialang.org/v1/environments/")[okolje s paketi] in
dodamo nekaj paketov, ki jih bomo potrebovali pri delu v interaktivni zanki.

```shell
julia > # pritisnemo ], da pridemo v način paketov
(@v1.10) pkg> activate . # pripravimo virtualno okolje v korenski mapi
(nummat-julia) pkg> add Plot # paket za risanje grafov 
```

Priporočljivo je uporabiti tudi program za vodenje različic #link("https://git-scm.com/")[Git].
Z naslednjim ukazom v mapi `nummat-julia` ustvarimo repozitorij za `git` in
registriramo novo ustvarjene datoteke.

```shell
$ git init .
$ git add .
$ git commit -m "Začetni vpis"
```

Priporočam pogosto beleženje sprememb z `git commit`. Pogoste potrditve (angl.
commit) olajšajo pregledovanje sprememb in spodbujajo k razdelitvi dela na
majhne zaključene probleme, ki so lažje obvladljivi. 

#opomba(
  naslov: [Na mojem računalniku pa koda dela!],
  [
  Izjava #quote[Na mojem računalniku pa koda dela!]
  je postala sinonim za #link(
    "https://sl.wikipedia.org/wiki/Obnovljivost",
  )[problem ponovljivosti rezultatov], ki jih generiramo z računalnikom. Eden od
  mnogih faktorjev, ki vplivajo na ponovljivost, je tudi dostop do zunanjih
  knjižnic/paketov, ki jih naša koda uporablja in jih ponavadi ne hranimo skupaj s
  kodo. V `julii` lahko pakete, ki jih potrebujemo, deklariramo v datoteki
  `Project.toml`. Vsak direktorij, ki vsebuje datoteko `Project.toml` definira
  bodisi #link("https://pkgdocs.julialang.org/v1/environments/")[delovno okolje] ali
  pa #link("https://pkgdocs.julialang.org/v1/creating-packages/")[paket] in
  omogoča, da preprosto obnovimo vse zunanje pakete, od katerih je odvisna naša
  koda.
   
  Za ponovljivost sistemskega okolja, glej #link("https://www.docker.com/")[docker], #link("https://nixos.org/")[NixOS] in #link("https://guix.gnu.org/")[GNU Guix].
  ],
)

== Priprava paketa za vajo

Ob začetku vsake vaje si bomo v mapi, ki smo jo ustvarili pred tem
(`nummmat-julia`) najprej ustvarili direktorij oziroma paket za _julio_, kjer bo
shranjena koda za določeno vajo. S ponavljanjem postopka priprave paketa za
vsako vajo posebej, se bomo naučili, kako hitro začeti s projektom. Obenem bomo
optimizirali način dela (angl. workflow), da bo pri delu čim manj nepotrebnih
motenj.

```shell
$ cd nummat-julia
$ julia
julia> # pritisnemo ], da pridemo v način pkg
(@v1.10) pkg> generate Vaja00 # 00 bomo kasneje nadomestili z zaporedno številko vaje 
(@v1.10) pkg> activate . 
(nummat-julia) pkg> develop Vaja00
(nummat-julia) pkg> # pritisnemo tipko za brisanje nazaj, da pridemo v navaden način
julia>
```

Zgornji ukazi ustvarijo direktorij `Vaja00` z osnovno strukturo 
#link("https://pkgdocs.julialang.org/v1/creating-packages/")[paketa v Jiliji].
Za bolj obsežen projekt, ki ga želite objaviti, lahko uporabite
#link("https://github.com/JuliaCI/PkgTemplates.jl")[PkgTemplates] ali
#link("https://github.com/tpapp/PkgSkeleton.jl")[PkgSkeleton].

```shell
julia> cd("Vaja00") # pritisnemo ;, da pridemo v način lupine
shell> tree .
.
├── Project.toml
└── src
    └── Vaja00.jl

1 directory, 2 files

```

Direktoriju dodamo še teste, skripte z demnostracijsko kodo in README dokument.

```shell
shell> mkdir test
shell> touch test/runtests.jl
shell> touch README.md
shell> mkdir scripts
shell> touch scripts/demo.jl
shell> tree .
.
├── Manifest.toml
├── Project.toml
├── scripts
│   └── demo.jl
├── src
│   └── Vaja00.jl
└── test
    └── runtests.jl
```

#opomba(
  naslov: [V okolju Windows lupina ne deluje najbolje],
  [
    Zgornji ukazi v lupini v okolju Microsoft Windows mogoče ne bodo delovali. V tem
    primeru lahko mape in datoteke ustvarite v _raziskovalcu_. Lahko pa si okolje za _julio_ ustvarite
    v
    #link(
      "https://learn.microsoft.com/en-us/windows/wsl/install",
    )[Linuxu v Windowsih (WSL)].
  ],
)

=== Geronova lemniskata

Ko je direktorij s paketom `Vaja00` pripravljen, lahko začnemo s pisanjem kode.
Za vajo bomo narisali 
#link(
  "https://sl.wikipedia.org/wiki/Geronova_lemniskata",
)[Geronove lemniskato]. Najprej definiramo koordinatne funkcije

$
  x(t) = (t^2 - 1) / (t^2 + 1) #h(2em)
  y(t) = 2t(t^2 - 1) / (t^2 + 1)^2.
$

Definicije shranimo v datoteki `Vaja00/src/Vaja00.jl`.

#figure(
  raw(lang: "jl", block: true, read("Vaja00/src/Vaja00.jl")),
  caption: [Vsebina datoteke `Vaja00.jl`.],
)

V interaktivni zanki lahko sedaj pokličemo novo definirani funkciji.

```jl
import Pkg; Pkg.activate(".")
using Vaja00
lemniskata_x(1.2)
```
Nadaljujemo, ko se prepričamo, da lahko kličemo funkcije iz paketa `Vaja00`.

Kodo, ki bo sledila, bomo sedaj pisali v scripto `Vaja00\doc\demo.jl`. 

#figure(
  jl("Vaja00/doc/demo.jl", 4, 11),
  caption: [Vsebina datoteke `demo.jl`],
)

Skripto poženemo z ukazom:

```jl 
include("Vaja00/doc/demo.jl")
```
Rezultat je slika lemniskate.

#figure(image(width: 60%, "img/01_demo.svg"), caption: [Geronova lemniskata])

#opomba(naslov: [Poganjanje ukaz za ukazom v VsCode])[
  Če uporabljate urejevalnik #link("https://code.visualstudio.com/")[VsCode] in #link("https://github.com/julia-vscode/julia-vscode")[razširitev za Julio], lahko ukaze iz skripte poganjate vrstico za vrstico kar iz urejevalnika. Če pritisnete kombinacijo tipk `Shift + Enter`, se bo izvedla vrstica v kateri je trenutno kazalka.
]

== Testi

V prejšnjem razdelku smo definirali funkcije in napisali skripto, s katero smo
omenjene funkcije uporabili. Naslednji korak je, da dodamo teste, s katerimi
preiskusimo pravilnost napisane kode. 

#opomba(
  naslov: [Avtomatsko testiranje programov],
  [Pomembno je, da pravilnost programov preverimo. Najlažje to naredimo "na roke",
    tako da program poženemo in preverimo rezultat. Testiranja "na roke" ima veliko
    pomankljivosti od tega, da zahteva čas, da je lahko nekonsistentno, in dovzetno
    za napake. Alternativa ročnemu testiranju programov so avtomatski testi.
    Avtomatski testi so preprosti programi, ki izvedejo testirani program in
    rezultate preverijo. Avtomoatski testi so pomemben del #link(
      "https://sl.wikipedia.org/wiki/Agilne_metode_razvoja_programske_opreme",
    )[agilnega razvoja programske opreme] in omogočajo avtomatizacijo procesov
    razvoja programske, ki se imenuje #link(
      "https://en.wikipedia.org/wiki/Continuous_integration",
    )[nenehna integracija].],
)

Uporabili bomo paket #link("https://docs.julialang.org/en/v1/stdlib/Test/")[Test],
ki olajša pisanje testov. Vstopna točka za teste je datoteka `test\runtests.jl`.

Avtomatski test je preprost program, ki pokliče določeno funkcijo in preveri
rezultat.Najbolj enostavno je rezultat kar primerjati z v naprej znanim
rezultatom, za katerega smo prepričani, da je pravilen. Uporabili bomo makroje #link("https://docs.julialang.org/en/v1/stdlib/Test/#Test.@test")[\@test] in #link(
  "https://docs.julialang.org/en/v1/stdlib/Test/#Test.@testset",
)[\@testset] iz paketa `Test`. 

V datoteko `test/runtests.jl` dodamo teste za obe koordinatni funkciji, ki smo
ju definirali:

#figure(
  raw(read("Vaja00/test/runtests.jl"), lang: "jl"),
  caption: [Testi za paket `Vaja00`],
)

Za primerjavo rezultatov smo uporabili operator `≈`, ki je alias za funkcijo #link("https://docs.julialang.org/en/v1/base/math/#Base.isapprox")[isapprox].

#opomba(
  naslov: [Primerjava števil s plavajočo vejico],
  [Pri računanju s števili s plavajočo vejico se izogibajmo primerjanju števil z
  operatorjem `==` bit po bit. Pri izračunih pride do zaokrožitvenih napak. Zato
  se različni načini izračuna za isto število praviloma razlikujejo na zadnjih
  decimalkah v zapisu s plavajočo vejico. Na primer izraz // auto format hack
  ```jl asin(sin(pi/4)) - pi/4 ``` 
  ne vrne točne ničle ampak vrednost `-1.1102230246251565e-16`, ki pa je zelo
  majhno število. Za primerjavo dveh vrednosti `a` in `b` zato ponavadi uporabimo
  izraz
  $
    |a - b| < epsilon,
  $
  kjer je $epsilon$ večji, kot pričakovana zaokrožitvena napaka. Funkcija
  `isapprox` je namenjena ravno zgornji primerjavi.],
)

Preden lahko poženemo teste, moramo ustvariti testno okolje. Sledimo #link(
  "https://docs.julialang.org/en/v1/stdlib/Test/#Workflow-for-Testing-Packages",
)[priporočilom za testiranje paketov]. V mapi `Vaje00/test` ustvarimo novo
okolje in dodamo paket `Test`.

```shell
(nummat-julia) pkg> activate Vaje00/test
(test) pkg> add Test
(test) pkg> activate .
```

Teste poženemo tako, da v `pkg` načinu poženemo ukaz `test Vaja00`

```shell 
(nummat-julia) pkg> test Vaja00 
```

== Dokumentacija

Dokumentacija programske kode je sestavljena iz različnih besedil in drugih virov, npr. videov, ki so namenjeni uporabnikom in razvijalcem programa ali knjižnice. Dokumentacija lahko vključuje komentarje v kodi, navodila za namestitev in uporabo programa in druge vire v raznih formatih z razlagami ozadja, teorije in drugih zadev povezanih s projektom. Dobra dokumentacija lahko veliko pripomore k uspehu določenega programa. Sploh to velja za knjižnice. 

Tudi, če kode ne bo uporabljal nihče drug in verjamite, slabo dokumentirane kode, nihče ne želi uporabljati, bodimo prijazni do nas samih v prihodnosti in pišimo dobro dokumentacijo.

Pisali bomo 3 vrste dokumentacije:
- dokumentacijo posameznih funkcij in tipov, 
- navodila za uporabnika v datoteki `README.md`,
- poročilo v formatu PDF

#opomba(naslov: [Zakaj format PDF])[
  Izbira formata PDF je mogoče presenetljiva za pisanje dokumentacije programske kode. V praksi so precej bolj uporabne HTML strani. Dokumentacija v obliki HTML strani, ki se generira avtomatično v procesu #link("https://en.wikipedia.org/wiki/Continuous_integration")[nenehne integracije] je postala _de facto_ standard.
  
  V kontekstu popravljanja domačih nalog in poročil na vajah pa ima format PDF še vedno prednosti. Saj ga je lažje pregledovati in popravljati.
]

=== Dokumentacija funkcij in tipov

Funkcije in tipe v Julii dokumentiramo tako, da pred definicijo dodamo niz z opisom funkcije. Več o tem si lahko preberete #link("https://docs.julialang.org/en/v1/manual/documentation/")[v priročniku za Julio].

=== Generiranje PDF poročila

Za pisanje dokumentacijo bomo uporabili format
#link("https://en.wikipedia.org/wiki/Markdown")[Markdown], ki 
ga bomo dodali kot komentarje v kodi. Knjižnica 
#link("https://github.com/JunoLab/Weave.jl")[Weave.jl] poskrbi za generiranje PDF poročila.

Za generiranje PDF dokumentov je potrebno namestiti
#link("https://tug.org/")[TeX/LaTeX]. Priporočam namestitev
#link("https://yihui.org/tinytex/")[TinyTeX] ali #link("https://tug.org/texlive/")[TeX Live], ki pa vsebuje vso izvorno kodo in zasede več prostora na disku. Po #link("https://yihui.org/tinytex/#installation")[namestitvi] programa TinyTex moramo  dodamo še nekaj `LaTeX` paketov, ki jih potrebuje paket Weave. V terminalu izvedemo naslednji ukaz

``` 
tlmgr install microtype upquote minted 
```

Poročilo pripravimo v obliki demo skripte. Uporabili bom kar
`Vaja00/doc/demo.jl`, ki smo jo ustvarili, da smo generirali sliko.

V datoteko dodamo besedilo v obliki komentarjev. Komentarje, ki se začnejo z ```jl #'``` paket `Weave` uporabi kot tekst v formatu #link("https://weavejl.mpastell.com/stable/publish/#Supported-Markdown-syntax")[Markdown], medtem ko se koda in navadni komentarji v poročilu izpišejo kot koda. 

#figure(
  ```jl
  #read("Vaja00/doc/demo.jl")
  ```,
  caption: [Vsebina `Vaje00/doc/demo.jl`, po tem, ko smo dodali komentarje s tekstom v formatu Markdown]
)

Poročilo pripravimo z ukazom ```jl Weave.weave```. Ustvarimo še eno skripto `Vaje00\doc\makedocs.jl`, v katero dodamo naslednje vrstice

#figure(raw(
read("Vaja00/doc/makedocs.jl"), lang: "jl"),
caption: [Program za generiranje PDF dokumenta]
)
Skripto poženemo v julii s 
```jl
include("Vaja00/doc/makedocs.jl").
```

Poleg paketa Weave.jl je na voljo še nekaj alternativ:

- #link("https://github.com/JuliaLang/IJulia.jl")[IJulia],
- #link("https://github.com/fredrikekre/Literate.jl")[Literate.jl] ali
- #link("https://quarto.org/docs/computations/julia.html")[Quadro].

=== Povezave

Nekaj zanimivih povezav povezanih s pisanjem dokumentacije:

- #link("https://docs.julialang.org/en/v1/manual/documentation/")[Pisanje dokumentacije] v jeziku Julia.
- #link("https://documenter.juliadocs.org/stable/")[Documenter.jl] je najbolj razširjen paket za pripravo dokumentacije v Julii.
- #link("https://diataxis.fr/")[Diátaxis] je sistematičen pristop k pisanju dokumentacije.
- #link("https://www.writethedocs.org/guide/docs-as-code/")[Dokumentacija kot koda] je ime za način dela, pri katerem z dokumentacijo ravnamo na enak način, kot ravnamo s kodo.

== Zaključek

Za konec preverimo, če vse dela kot bi moralo.

Ustvarili smo direktorij `nummat-julia` in direktorij s prvim 
paketom `nummat-julia\Vaja00`. V terminalu poženemo ukaz `tree .` da preverimo, če smo ustvarili vse datoteke. 

```shell
$ tree .
nummat-julia 
├── Project.toml 
├── Manifest.toml 
├── README.md 
├── Vaja00
| ├── Project.toml 
| ├── Manifest.toml
| ├── doc
| |  ├─ makedocs.jl  
| |  └─ demo.jl
| ├─ src 
| | └─ Vaja00.jl 
| ├─ pdf 
| | ├─ demo.pdf
| | └─ ...
| └── test 
|   └─ runtests.jl 
```

== Povezave

- [Priporočila za stil
  Julia](https://docs.julialang.org/en/v1/manual/style-guide/).
- [Naveti za delo z
  Julijo](https://docs.julialang.org/en/v1/manual/workflow-tips/).

== Git

[Git](https://git-scm.com/) je sistem za vodenje različic, ki je postal de facto
standard v razvoju programske opreme pa tudi drugod, kjer se dela s tekstovnimi
datotekami. Predlagam, da si bralec naredi svoj Git repozitorij, kjer si uredi
kodo in zapiske, ki jo bo napisal pri spremljanju te knjige. Git repozitorij
lahko hranimo zgolj lokalno na lastnem računalniku. Če želimo svojo kodo deliti
ali pa zgolj hraniti varnostno kopijo, ki je dostopna na internetu, lahko
repozitorij repliciramo lastnem strežniku ali na enm od javnih spletnih skladišč
za programsko kodo npr. [Github](https://github.com/) ali
[Gitlab](https://gitlab.com/).

=== Povezave

Spodaj je nekaj povezav, ki bodo bralcu v pomoč pri uporabi programa
[Git](https://git-scm.com/):

- vmesnik za git [Git Extensions](https://gitextensions.github.io/) za Windows,
- [način dela za Github (Github
  flow)](https://docs.github.com/en/get-started/using-github/github-flow),
- [način dela za Gitlab (Gitlab
  Flow)](https://docs.gitlab.com/ee/topics/gitlab_flow.html).
