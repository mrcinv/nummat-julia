#import "admonitions.typ": admonition, admtitle
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

= Navodila za pripravo domačih nalog 

Ta dokument vsebuje navodila za pripravo domačih nalog. Navodila so napisana za
programski jezik #link("https://julialang.org/")[Julia]. Če uporabljate drug
programski jezik, navodila smiselno prilagodite.

== Kontrolni seznam

Spodaj je seznam delov, ki naj jih vsebuje domača naloga.

- koda (`src\DomacaXY.jl`) 
- testi (`test\runtests.jl`)
- dokument `README.md`
- demo skripta, s katerim generirate rezultate za poročilo
- poročilo v formatu PDF

Preden oddate domačo nalogo, uporabite naslednji _kontrolni seznam_:

- vse funkcije imajo dokumentacijo
- testi pokrivajo vso kodo (glej #link("https://github.com/JuliaCI/Coverage.jl")[Coverage.jl])
- _README_ vsebuje naslednje:
  - ime in priimek avtorja
  - opis naloge
  - navodila kako uporabiti kodo
  - navodila, kako pognati teste
  - navodila, kako generirati poročilo
- _README_ ni predolg
- poročilo vsebuje naslednje:
  - ime in priimek avtorja
  - splošen(matematičen) opis naloge
  - splošen opis rešitve
  - primer uporabe (slikice prosim :-)

== Kako pisati in kako ne

V nadaljevanju je nekaj primerov dobre prakse, kako pisati kodo, teste in
poročilo. Pri pisanju besedil je vedno treba imeti v mislih, komu je poročilo
namenjeno. 

Pisec naj uporabi empatijo do bralca in naj poskuša napisati zgodbo, ki ji
bralec lahko sledi. Tudi, če je pisanje namenjeno strokovnjakom, je dobro, če je
čim več besedila razumljivega tudi širši publiki. Tudi strokovnjaki radi beremo
besedila, ki jih hitro razumemo. Zato je dobro začeti z okvirnim opisom z malo
formulami in splošnimi izrazi. V nadaljevanju lahko besedilo stopnjujemo k vedno
večjim podrobnostim. 

Določene podrobnosti, ki so povezane s konkretno implementacijo, brez škode
izpustimo. 

=== Opis rešitve naj bo okviren

Opis rešitve naj bo zgolj okviren. Izogibajte se uporabi programerskih izrazov
ampak raje uporabljajte matematične. Na primer izraz #text(slababarva)[uporabimo for zanko],
lahko nadomestimo z #text(dobrabarva)[postopek ponavljamo]. Od bralca zahteva
splošen opis manj napora in dobi širšo sliko. Če želite dodati izpeljave, jih
napišite z matematičnimi formulami, ne v programskem jeziku. Koda sodi zgolj v
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

=== Podrobnosti implementacije ne sodijo v poročilo

Podrobnosti implementacije so razvidne iz kode, zato jih nima smisla ponavljati
v poročilu. Algoritme opišete okvirno, tako da izpustite podrobnosti, ki niso
nujno potrebne za razumevanje. Podrobnosti lahko dodate, v nadaljevanju, če
mislite, da so nujne za razumevanje.

#dobro(
  [Algoritem opišemo okvirno, podrobnosti razložimo kasneje],
)[
  V matriki želimo eleminirati spodnji trikotnik. To dosežemo tako, da stolpce
  enega za drugim preslikamo s Hausholderjevimi zrcaljenji. Za vsak stolpec
  poiščemo vektor, preko katerega bomo zrcalili. Vektor poiščemo tako, da bo imela
  zrcalna slika ničle pod diagonalnim elementom.
]

Tu lahko z razlago zaključimo. Če želimo dodati podrobnosti, pa jih navedemo za
okvirno idejo.

#dobro(
  [Podrobnosti sledijo za okvirno razlago],
)[
  Vektor zrcaljenja dobimo kot 
  $ u = [s(k) + A_(k, k), A_(k+1, k), ... A_(n, k)], $ kjer je $s(k)="sign"(A_(k, k))*||A(k:n,k)||$.
  Podmatriko $A(k:n, k+1:n)$ prezrcalimo preko vektorja $u$, tako da podmatriki
  odštejemo matriko 
  $ 2u (u^T A(k:n, k+1:n))/(u^T u). $
  Na $k$-tem koraku prezrcalimo le podmatriko $k:n times k:n$, ostali deli matrike
  pa ostanjejo nespremenjeni.
]

Takojšnje razlaganje podrobnosti, brez predhodnega opisa osnovne ideje, ni
dobro. Bralec težko loči, kaj je zares pomembno in kaj je zgolj manj pomembna
podrobnost.

#slabo(
  [Takoj dodamo vse podrobnosti, ne da bi razložili zakaj],
)[
  Za vsak $k$, poiščemo vektor $u=[s(k) + A_(k, k), A_(k+1, k), ... A_(n, k)]$,
  kjer je $s(k)="sign"(A_(k, k))*||[A_(k,k), ..., A_(n, k)]||$.
   
  Nato matriko popravimo
  $
    A(k:n, k+1:n) = A(k:n, k+1:n) -2*u*(u^T*A(k:n, k+1:n))/(u^T*u).
  $
]