
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

#include "03a_tridiagonalni_sistemi.typ"

#include "03_laplace.typ"

#include "04_implicitna_interpolacija.typ"

#include "04a_fizikalna_graf.typ"

#include "05_page_rank.typ"

#include "06_spektralno_grucenje.typ"

#include "07_nelinearne_geometrija.typ"

#include "08_konvergencna_obmocja.typ"

#include "09_hermitov_zlepek.typ"

#include "11_porazdelitvena_funkcija.typ"

#include "12_povprecna_razdalja.typ"

#include "13_avtomatsko_odvajanje.typ"

#include "14_nde.typ"

#include "15_nde_aproksimacija.typ"

#include "domace.typ"

#bibliography("reference.yml")


