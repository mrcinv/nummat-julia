= Osnovni ukazi v jeziku Julia

Programe v jeziku Julia poženemo tako, da v terminalu poženemo ukaz `julia`
#rect(
[
  - *julia* zažene se Julia REPL (Read Eval Print Loop). 
- *julia program.jl* Poženi kodo v datoteki `program.jl`.
- *julia --project="."* aktivira projekt v trenutnem direktoriju.
]
)
== Julia REPL(Read Eval Print Loop)

Z vnosom naslednjih znakov se spremeni način REPL
#let ukaz(ukaz, opis) = [
  - #h(0.2em) *#raw(ukaz)* #h(1em) #opis
]
#rect(
  [
#ukaz("?", [Način dokumentacije (*`help>`*). Vnos *`?ime`* prikaže dokumentacijo za funkcijo `ime`.])
#ukaz(
  ";", [Način zunanje lupine (*`shell>`*). Vnašamo lahko ukaze sistemske lupine.]
) 
#ukaz(
  "]", 
  [Način paketov (*`pkg>`*). Vnašamo lahko ukaze iz modula `Pkg`.]
)
#ukaz(
  "include(\"program.jl\")",
  [Požene kodo iz datoteke `program.jl`.]
)  
#ukaz(
  "using MojPaket",
  [Naloži paket `MojPaket`.]
)
  ]
)  
== Paketi

#ukaz(
  "import(\"Pkg\")",
  [naloži modul `Pkg`]
) 

REPL način paketov (`pkg>`):
#rect(
[
  #ukaz(
  "activate Direktorij", [Aktviraj projekt v mapi `Direktorij`.]
)
#ukaz( 
  "add ImePaketa", [Namesti paket v trenutno aktivirani projekt.]
)
#ukaz(
  "test",  [Poženi teste definirane v `test/runtests.jl`.]
  )
]
)
== Kontrolne strukture

#rect([
  ```jl
  if 1 == 2
    println("Ena je enako dva.")
  end
  ```
  ])
#rect([
  ```jl
  for i=1:10
    println("Indeks v zanki je $i")
  end
  ```
  ])
#rect([
  ```jl
  throw("Zgodilo se je nekaj pričakovano nepričakovanega.")
  ```
])

== Funkcije

#rect(
  [
    ```jl
    f(x,y) = x*y + x  # definicija v eni vrstici
    ```
  ]
)

#rect(
  [
    ```jl
    function mojfun(x, y) # definicija v bloku
     return x*y + y
    end
    ```
  ]
)

#rect(
  [
    ```jl
    fun = (x, y) -> x*y + x # anonimna funkcija
    ```
  ]
)