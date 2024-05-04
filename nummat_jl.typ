
#import "template.typ": conf

#set text(lang: "sl")

#show: doc => conf(
  title: [Numerična matematika #linebreak() v programskem jeziku Julia],
  authors: ("Martin Vuk",),
  doc,
)

#include "00_uvod.typ"

#include "01_julia.typ"

#include "02_koren.typ"

= Tridiagonalni sistemi

#include "03_laplace.typ"

= Implicitna interpolacija

= Invariantna porazdelitev Markovske verige

= Spektralno gručenje

= Nelinearne enačbe in geometrija

= Konvergenčna območja nelinearnih enačb

= Interpolacija z zlepki

= Aproksimacija z linearnim modelom

= Aproksimacija s polinomi Čebiševa

= Povprečna razdalja med dvema točkama na kvadratu

= Gaussove kvadrature

= Avtomatsko odvajanje z dualnimi števili

#include "16_nde.typ"

= Perioda geostacionarne orbite
//#include "06_spektralno_grucenje.typ"

#include "domace.typ"

#bibliography("reference.yml")


