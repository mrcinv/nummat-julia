#import "julia.typ": jl, jlb, out, readlines, blk

#import "template.typ": conf

#set text(
  lang: "sl"
)

#show: doc => conf(
  title: [Numerična matematika in programski jezik Julia],
  authors: ("Martin Vuk",),
  doc
)

#include "00_uvod.typ"

#include "01_julia.typ"

#include "02_koren.typ"



