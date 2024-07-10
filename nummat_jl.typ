
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

#include "03_tridiag.typ"

#include "04_laplace.typ"

#include "05_implicitna_interpolacija.typ"

#include "06_fizikalna_graf.typ"

#include "07_page_rank.typ"

#include "08_spektralno_grucenje.typ"

#include "09_konvergencna_obmocja.typ"

#include "10_nelinearne_geometrija.typ"

#include "11_linearni_model.typ"

#include "12_hermitov_zlepek.typ"

#include "13_porazdelitvena_funkcija.typ"

#include "14_povprecna_razdalja.typ"

#include "15_avtomatsko_odvajanje.typ"

#include "16_nde.typ"

#include "17_nde_aproksimacija.typ"

#include "domace.typ"

#bibliography("reference.yml")


