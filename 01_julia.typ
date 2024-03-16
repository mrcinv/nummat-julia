= Uvod v programski jezik Julia

V knjigi bomo za implementacijo algoritmov in ilustracijo uporabe izbrali programski jezik 
#link("https://julialang.org/")[julia]. Zavoljo učinkovitega izvajanja, uporabe
#link("https://docs.julialang.org/en/v1/manual/types/")[dinamičnih tipov],
#link("https://docs.julialang.org/en/v1/manual/methods/")[funkcij specializiranih glede na signaturo] in
dobre podporo za interaktivno uporabo, je #link("https://julialang.org/")[julia] zelo primerna za
implementacijo numeričnih metod in ilustracijo njihove uporabe. V nadaljevanju sledijo kratka
navodila, kako začeti z `julio` in si pripraviti delovno okolje v katerem bo pisanje kode steklo
čim bolj gladko.

== Namestitev in prvi koraki
 
#link("https://julialang.org/downloads/")[Namestite] programski jezik julia. Ko je programski jezik
nameščen, lahko v terminalu poženete ukaz `julia`, ki odpre interaktivno zanko
(*Read Eval Print Loop* ali s kratico REPL). V zanko lahko pišemo posamezne ukaze, ki jih nato 
`julia` prevede in izvede.

== Priprava delovnega okolja

- Odprite terminal (ali windows `cmd`) 
- Poženite ukaze `julia` in namestite paket #link("https://timholy.github.io/Revise.jl/stable/")[Revise.jl]
```shell
$ julia
julia > # pritisnemo `]`, da pridemo v način paketov
(@v1.10) pkg> add Revise
(@v1.10) pkg> # pritisnemo vračalko, da pridemo iz načina paketov
julia> startup = """
       # copy this file to .julia/config/startup.jl
       try
         using Revise
       catch e
         @warn "Error initializing Revise" exception=(e, catch_backtrace())
       end
"""
julia> write(ENV[HOME]*"/.config/julia/startup.jl", startup)
```

=== Priprava začetnega okolja

Pripravimo mapo, v kateri bomo hranili programe

```shell
$ mkdir nummat-julia
$ cd nummat-julia
$ julia
```
Nato pripravimo [okolje s paketi](https://pkgdocs.julialang.org/v1/environments/)

```jl
julia > # pritisnemo ], da pridemo v način paketov
(@v1.10) pkg> activate . # pripravimo virtualno okolje 
``` 

== Priprava okolja

Ob začetku vsake vaje si najprej ustvarimo direktorij oziroma paket za Julio, kjer bo shranjeno
naše delo

```shell
$ mkdir nummat && cd nummat
$ julia
julia> # pritisnemo ], da pridemo v način pkg
(@v1.10) pkg> activate . 
(nummat) pkg> generate VajaXY
(nummat) pkg> develop VajaXY
(VajaXY) pkg> # pritisnemo tipko za brisanje nazaj, da zopet pridemo v navaden način
julia>
```

Zgornji ukazi ustvarijo direktorij `VajaXY` z osnovno struktura 
#link("https://pkgdocs.julialang.org/v1/creating-packages/")[paketa v Jiliji]. Za bolj obsežen projekt,
ki ga želite objaviti, lahko uporabite #link("https://github.com/JuliaCI/PkgTemplates.jl")[PkgTemplates]
ali #link("https://github.com/tpapp/PkgSkeleton.jl")[PkgSkeleton].

```shell
julia> cd("VajaXY") # pritisnemo ;, da pridemo v način lupine
shell> tree .
.
├── Project.toml
└── src
    └── VajaXY.jl

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
│   └── VajaXY.jl
└── test
    └── runtests.jl
```

Ko je direktorij s kodo pripravljen lahko naložimo kodo iz `VajaXY.jl` v ukazni vrstici

```shell
julia> using VajaXY
julia> VajaXY.moja_super_funkcija()
```

Boljša možnost je, da kodo uporabimo v scripti npr. `scripts\demo.jl`.

```jl
# demo.jl vsebuje primere uporabe funkcije iz modula/paketa VajaXY
using VajaXY

VajaXY.moja_super_funkcija()
```

Scripto nato poženemo z ukazom `ìnclude`.

```shell
julia> include("scripts/demo.jl")
```

Začetno strukturo paketa si lahko shranimo v šablono.

=== Testi

Vstopna točka za teste je `test\runtests.jl`. Paket [Test](https://docs.julialang.org/en/v1/stdlib/Test/) omogoča pisanje enotskih testov, ki se lahko avtomatično izvedejo v sistemu [nenehne integracije (Continuous Integration)](https://en.wikipedia.org/wiki/Continuous_integration).

V juliji teste pišemo z makroji #link("https://docs.julialang.org/en/v1/stdlib/Test/#Test.@test")[\@test] in #link("https://docs.julialang.org/en/v1/stdlib/Test/#Test.@testset")[\@testset]. Če `test/runtests.jl` lahko napišemo

```jl
using Test, VajaXY

@test VajaXY.funkcija_ki_vrne_ena() == 1
```

Lahko teste poženemo tako, da v `pkg` načinu poženemo ukaz `test`

```shell
(VajaXY) pkg> test

    Testing Running tests...
    Testing VajaXY tests passed
```

=== Dokumentacija

Za pisanje dokumentacijo navadno uporabimo format [Markdown](https://en.wikipedia.org/wiki/Markdown). S paketom [Documenter](https://documenter.juliadocs.org/stable/) lahko komentarje v kodi in markdown dokumentente združimo in generiramo HTML ali PDF dokumentacijo s povezavo na izvorno kodo.

Za pripravo posameznih poročil lahko uporabite [IJulia](https://github.com/JuliaLang/IJulia.jl), [Weave.jl](https://github.com/JunoLab/Weave.jl), [Literate.jl](https://github.com/fredrikekre/Literate.jl) ali [Quadro](https://quarto.org/docs/computations/julia.html).

== Organizacija direktorijev

- `vaje` direktorij z vajami
- `vaje/VajaXY` vsaka vaja ima svoj direktorij
- posamezen direktorij za vajo je organiziran kot paket s kodo, testi in dokumentacijo

        vaje
         └── Vaja01
           ├── Project.toml
           ├── README.md
           ├── src
           |   └─ Vaja01.jl
           ├── test
           |   └─ runtests.jl
           ├── doc
           |   ├─  makedocs.jl
           |   └─ index.md
           └─ scripts
              └─ demo.jl

== Delovno okolje

Za hitrejše in lažje delo z programskim jezikom `julia` uporabite [Revise](https://timholy.github.io/Revise.jl/stable/). Pred začetkom dela poženite

```julia
julia> using Revise
```

Namestite `startup.jl` v `.julia/config/startup.jl`, da se `Revise` zažene ob zagonu `julia`.

== Generiranje PDF dokumentov

Za generiranje PDF dokumentov s paketi [Documenter](https://documenter.juliadocs.org/stable/) ali [Weave.jl](https://github.com/JunoLab/Weave.jl) je potrebno namestiti [TeX/LaTeX](https://tug.org/). Priporočam uporabo [TinyTeX](https://yihui.org/tinytex/).
Po [namestitvi](https://yihui.org/tinytex/#installation) tinytex, dodamo še nekaj `LaTeX` paketov, tako da v terminalu izvedemo naslednji ukaz

```
tlmgr install microtype upquote minted
```

== Povezave

- [Način dela za Gitlab (Gitlab Flow)](https://docs.gitlab.com/ee/topics/gitlab_flow.html).
- [Priporočila za stil Julia](https://docs.julialang.org/en/v1/manual/style-guide/).
- [Naveti za delo z Julijo](https://docs.julialang.org/en/v1/manual/workflow-tips/).

== Git

[Git](https://git-scm.com/) je sistem za vodenje različic, ki je postal de facto standard v razvoju programske opreme pa tudi drugod, kjer se dela s tekstovnimi datotekami. Predlagam, da si bralec naredi svoj Git repozitorij, kjer si uredi kodo in zapiske, ki jo bo napisal pri spremljanju te knjige. Git repozitorij lahko hranimo zgolj lokalno na lastnem računalniku. Če želimo svojo kodo deliti ali pa zgolj hraniti varnostno kopijo, ki je dostopna na internetu, lahko repozitorij repliciramo lastnem strežniku ali na enm od javnih spletnih skladišč za programsko kodo npr. [Github](https://github.com/) ali [Gitlab](https://gitlab.com/).

=== Povezave

Spodaj je nekaj povezav, ki bodo bralcu v pomoč pri uporabi programa [Git](https://git-scm.com/):

- vmesnik za git [Git Extensions](https://gitextensions.github.io/) za Windows,
- [način dela za Github (Github flow)](https://docs.github.com/en/get-started/using-github/github-flow),
- [način dela za Gitlab (Gitlab Flow)](https://docs.gitlab.com/ee/topics/gitlab_flow.html).
