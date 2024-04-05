
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

#include "03_laplace.typ"

//#include "06_spektralno_grucenje.typ"

#include "domace.typ"

#bibliography("reference.yml")


