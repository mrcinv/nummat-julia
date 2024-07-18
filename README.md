# Numerična matematiki v programskem jeziku Julia

Večina ukazov in programov je napisanih v datoteke v mapi `scripts` in posameznih vajah.

Knjigo prevedi z ukazom

```
typst nummat_jl.typ
```

Vse slike in rezultati programov so shranjene v mapah `ìmg` in `out`. Če jih želimo ponovno ustvariti, poženemo ustrezne programe v `scripts`. Vse slike generiramo ponovno z ukazom

```jl
julia> include("scripts/make.jl")
```