#import "admonitions.typ": admonition, admtitle, opomba
#import "julia.typ": code_box, repl, pkg

#let dobro(naslov, vsebina) = {
  let title = admtitle("Dobro!", naslov)
  admonition(title: title, color: lime.desaturate(40%), vsebina)
}
#let slabo(naslov, vsebina) = {
  let title = admtitle("Slabo!", naslov)
  admonition(title: title, color: red.desaturate(40%), vsebina)
}
#let dobrabarva = green.darken(40%)
#let slababarva = red
#show link: set text(blue)

= Navodila za pripravo domačih nalog
<sec:navodila-domace>

V nadaljevanju so navodila za pripravo domačih nalog v programskem jeziku
#link("https://julialang.org/")[Julia]. Navodila so uporabna tudi za reševanje v kakšnem drugem programskem jeziku. V tem primeru jih
smiselno prilagodimo.

== Kontrolni seznam

Seznam delov, ki jih mora vsebovati vsaka domača naloga:

- koda (`src\DomacaXY.jl`),
- testi (`test\runtests.jl`),
- dokument `README.md`,
- demo skripta, s katero ustvarite rezultate za poročilo,
- poročilo v formatu PDF.

Preden končaš domačo nalogo, uporabi naslednji _kontrolni seznam_:

- vse funkcije imajo dokumentacijo,
- testi pokrivajo večino kode,
- _README_ vsebuje naslednje:
  - ime in priimek avtorja,
  - opis naloge,
  - navodila kako uporabiti kodo,
  - navodila, kako pognati teste,
  - navodila, kako ustvariti poročilo,
- _README_ ni predolg,
- poročilo vsebuje naslednje:
  - ime in priimek avtorja,
  - splošen (matematični) opis naloge,
  - splošen opis rešitve,
  - primer uporabe (slikice prosim :-).

== Kako pisati in kako ne

V nadaljevanju je nekaj primerov dobre prakse, kako pisati kodo, teste in
poročilo. Pri pisanju besedil je vedno treba imeti v mislih, komu je poročilo
namenjeno.

Pisec naj uporabi empatijo do bralca in naj poskuša napisati zgodbo, ki ji
bralec lahko sledi. Tudi če je pisanje namenjeno strokovnjakom, je dobro, da je
čim več besedila razumljivega tudi širši publiki. Tudi strokovnjaki radi beremo
besedila, ki jih hitro razumemo. Zato je dobro začeti z okvirnim opisom z malo
formulami in splošnimi izrazi. V nadaljevanju besedilo stopnjujemo k vedno podrobnejšim informacijam.

Določene podrobnosti, ki so povezane s konkretno implementacijo, brez škode
izpustimo.

== Opis rešitve naj bo okviren

Opis rešitve naj bo zgolj okviren. Izogibaj se uporabi programerskih izrazov.
Raje uporabi matematične. Na primer: izraz #text(slababarva)[uporabimo "for" zanko], nadomesti s #text(dobrabarva)[postopek ponavljamo]. Od bralca zahteva
splošen opis manj napora in mu da širšo sliko. Če želiš dodati izpeljave, jih
napiši z matematičnimi formulami, ne v programskem jeziku. Koda sodi zgolj v
del, kjer je opisana uporaba za konkreten primer.

#dobro(
  "Splošen opis algoritma",
)[
  Algoritem za LU razcep smo prilagodili tridiagonalni strukturi matrike. Namesto
  trojne zanke smo uporabili le enojno, saj je pod pivotnim elementom neničelen le
  en element. Časovna zahtevnost algoritma je tako z $cal(O)(n^3)$ padla na zgolj $cal(O)(n)$.
]

#slabo(
  "Podrobna razlaga kode, vrstico po vrstico",
)[
V programu za LU razcep smo uporabili for zanko od 2 do velikosti matrike. V
prvi vrstici zanke smo izračunali `L.s[i]`, tako da smo element `T.s[i]` delili
z `U.z[i-1]`. Nato smo izračunali diagonalni element, tako da smo uporabili
formulo `U.d[i]-L.s[i]*U.d[i-1]`. Na koncu zanke smo vrnili matriki `L` in `U`.
]

== Podrobnosti implementacije ne sodijo v poročilo

Podrobnosti implementacije so razvidne iz kode, zato jih nima smisla ponavljati
v poročilu. Algoritme opišemo okvirno, tako da izpustimo podrobnosti, ki niso
nujno potrebne za razumevanje. Podrobnosti lahko dodamo v nadaljevanju, če so potrebne.

#dobro(
  [Algoritem opišemo okvirno, podrobnosti razložimo kasneje],
)[
  V matriki želimo eliminirati spodnji trikotnik. To dosežemo tako, da stolpce
  enega za drugim preslikamo s Householderjevimi zrcaljenji. Za vsak stolpec
  poiščemo vektor, preko katerega zrcalimo. Vektor poiščemo tako, da ima
  zrcalna slika ničle pod diagonalnim elementom.
]

Tu lahko z razlago zaključimo. Če želimo dodati podrobnosti, jih navedemo za
okvirno idejo.

#dobro(
  [Podrobnosti sledijo za okvirno razlago],
)[
  Vektor zrcaljenja dobimo kot:
  $ u = [s(k) + A_(k, k), A_(k+1, k), ... A_(n, k)], $ kjer je $s(k)="sign"(A_(k, k))*||A(k:n,k)||$.
  Podmatriko $A(k:n, k+1:n)$ prezrcalimo preko vektorja $u$, tako da podmatriki
  odštejemo matriko:
  $ 2u (u^T A(k:n, k+1:n))/(u^T u). $
  Na $k$-tem koraku prezrcalimo le podmatriko $k:n times k:n$, ostali deli matrike
  pa ostanejo nespremenjeni.
]

Takojšnje razlaganje podrobnosti, brez predhodnega opisa osnovne ideje, ni
dobro, saj bralec težko razloči, kaj je zares pomembno in kaj ne.

#slabo(
  [Takoj dodamo vse podrobnosti, ne da bi razložili namen],
)[
  Za vsak $k$ poiščemo vektor $u=[s(k) + A_(k, k), A_(k+1, k), ... A_(n, k)]$,
  kjer je $s(k)="sign"(A_(k, k))*||[A_(k,k), ..., A_(n, k)]||$.

  Nato matriko popravimo:
  $
    A(k:n, k+1:n) = A(k:n, k+1:n) -2*u*(u^T*A(k:n, k+1:n))/(u^T*u).
  $
]

Če implementacija vsebuje posebnosti, kot na primer uporabo posebne podatkovne
strukture ali algoritma, jih lahko opišemo v poročilu. Vendar tudi tu
pazimo, da bralca ne obremenjujemo s podrobnostmi.

#dobro(
  [Posebnosti implementacije opišemo v grobem in se ne spuščamo v podrobnosti],
)[
Za tridiagonalne matrike definiramo posebno podatkovno strukturo `Tridiag`, ki
hrani le neničelne elemente matrike. Julia omogoča, da LU razcep tridiagonalne
matrike implementiramo kot specializirano metodo funkcije `lu` iz paketa
`LinearAlgebra`. Pri tem upoštevamo posebnosti tridiagonalne matrike in
algoritem za LU razcep prilagodimo tako, da se časovna in prostorska zahtevnost
zmanjšata na $cal(O)(n)$.
]

Pazimo, da v poročilu ne povzemamo direktno posameznih korakov kode.

#slabo(
  [Opisovanje, kaj počnejo posamezni koraki kode, ne sodi v poročilo.],
)[
Za tridiagonalne matrike definiramo podatkovni tip `Tridiag`, ki ima 3 atribute
`s`, `d` in `z`. Atribut `s` vsebuje elemente pod diagonalo, ...

LU razcep implementiramo kot metodo za funkcijo `LinearAlgebra.lu`. V `for`
zanki izračunamo naslednje:
1. element `l[i]=a[i, i-1]/a[i-1, i-1]`
2. ...

]

== Kako pisati avtomatske teste

Nekaj nasvetov, kako lahko testiramo kodo:
- Na roke poiščemo rešitev za preprost primer in jo primerjamo z rezultati
  funkcije.
- Ustvarimo testne podatke, za katere je znana rešitev. Na primer za testiranje
  kode, ki reši sistem `Ax=b`, izberemo `A` in `x` in izračunamo desne strani kot
  `b=A*x`.
- Preverimo lastnost rešitve. Za enačbe `f(x)=0` lahko rešitev, ki jo izračuna
  program, preprosto vstavimo nazaj v enačbo in preverimo, ali je enačba izpolnjena.
- Red metode lahko preverimo tako, da naredimo simulacijo in primerjamo red
  metode z redom programa, ki ga eksperimentalno določimo.
- Če je le mogoče, v testih ne uporabljamo rezultatov, ki jih proizvede koda sama.
  Ko je koda dovolj časa v uporabi, lahko rezultate kode same uporabimo za #link("https://en.wikipedia.org/wiki/Regression_testing")[regresijske teste].

== Pokritost kode s testi <sec:pokritost-testi>

Pri pisanju testov je pomembno, da testi izvedejo vse veje v kodi. Delež kode,
ki se izvede med testi, imenujemo #link(
  "https://en.wikipedia.org/wiki/Code_coverage",
)[pokritost kode (angl. Code Coverage)]. V Julii lahko pokritost kode dobimo
z argumentom ```jl coverage=true```, ki ga dodamo metodi `Pkg.test`:

#code_box(
  repl("import Pkg; Pkg.test(\"DomacaXY\"; coverage=true)", none)
)

Zgornji ukaz bo za vsako datoteko iz mape `src` ustvaril ustrezno datoteko s končnico `.cov`, v kateri je shranjena informacija o tem, kateri deli kode so bili uporabljeni med izvajanjem testov.
Za pripravo povzetka o pokritosti kode uporabimo paket
#link("https://github.com/JuliaCI/Coverage.jl")[Coverage.jl]:

#code_box[
  ```jl
  using Coverage
  cov = process_folder("DomacaXY")
  pokrite_vrstice, vse_vrstice = get_summary(cov)
  delez = pokrite_vrstice / vse_vrstice
  println("Pokritost kode s testi: $(round(delez*100))%.")
  ```
]


== Priprava zahteve za združitev na GitLab

Za lažjo komunikacijo predlagam, da rešitev domače naloge postaviš v
svojo vejo in ustvariš zahtevo za združitev (_Pull request_ na GitHub
oziroma _Merge request_ na GitLabu). V nadaljevanju bomo opisali, kako to
storiš, če repozitorij z domačimi nalogami gostiš na GitLabu.
Postopek za GitHub in druge platforme je podoben.

Preden začneš z delom, ustvari vejo na svoji delovni kopiji repozitorija in jo
potisno na GitLab. Ime veje naj bo `domača-X`, se pravi `domaca-01` za prvo domačo nalogo in tako naprej. To narediš z ukazom

```sh
$ git checkout -b domaca-01
$ git push -u origin domaca-01
```

Stikalo `-u` pove gitu, naj z domačo vejo sledi veji na GitLabu.

Med delom sproti dodajaj vnose z `git commit` in jih prenesi na GitLab z ukazom `git push`.
Ko je domača naloga končana, na GitLabu ustvari zahtevo za združitev
(angl. Merge request):
- Klikni na zavihek `Merge requests` in nato na gumb `New merge request`.
- Na desni strani izberi vejo `domaca-01` in klikni na gumb `Compare branches and continue`.
- Ko je koda pripravljena na pregled, odstrani besedo `Draft:` v naslovu in
  v komentarju povabi asistenta k pregledu. To storiš tako, da v komentar dodaš uporabniško ime asistenta
  (npr. `@mojZlobniAsistent`):
  ```
  @mojZlobniAsistent Prosim za pregled.
  ```

#opomba(naslov: [Pri domačih nalogah se posvetuj s kolegi])[
Nič ni narobe, če za pomoč pri domači nalogi prosiš kolega.
Seveda moraš kodo in poročilo napisati sam, lahko pa kolega prosiš
za pregled kode v zahtevi za združitev ali za pomoč, če kaj ne dela.

Domačo nalogo lahko rešujete skupinsko, vendar morate v tem primeru
rešiti toliko različnih nalog, kot vas je v skupini.
]
