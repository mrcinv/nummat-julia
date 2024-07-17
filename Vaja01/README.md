# Vzorčni projekt za vajo

Avtor: Martin Vuk <martin.vuk@fri.uni-lj.si>

Preprost paket, ki definira koordinatne funkcije [Geronove lemniskate](https://sl.wikipedia.org/wiki/Geronova_lemniskata). Primer uporabe je opisan v programu [01uvod.jl](./doc/01uvod.jl), ki ga poženemo z ukazom

```jl
include("Vaja01/doc/01uvod.jl")
```
v interaktivni zanki Julije.

## Testi

Teste poženemo z ukazom:

```
julia --project=Vaja01 -e "import Pkg; Pkg.test()"
```

## Poročilo PDF

Poročilo pripravimo z ukazom:

```
julia --project=@. Vaja01/doc/makedocs.jl
```