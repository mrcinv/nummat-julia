
#import "template.typ": conf

#set text(lang: "sl")

#show: doc => conf(
  title: [Numerična matematika #linebreak() v programskem jeziku Julia],
  authors: ("Martin Vuk",),
  doc,
)
#rect[
Kataložni zapis o publikaciji (CIP) pripravili v Narodni in univerzitetni knjižnici
v Ljubljani\
#link("https://cobiss.si/")[COBISS.SI]-ID=#link("https://plus.cobiss.net/cobiss/si/sl/bib/218309379")[218309379]

ISBN 978-961-7059-16-8 (PDF)
]

#v(1fr)

Copyright © 2025 Založba UL FRI. All rights reserved.

Elektronska izdaja knjige je na voljo na:\
URL: http://zalozba.fri.uni-lj.si/vuk2024.pdf\
#let doi(id) = link("https://doi.org/" + id, id)
DOI: #doi("10.51939/0005")\
Datum izdelave PDF: #datetime.today().display("[day]. [month]. [year]")

Recenzenta: doc. dr. Aljaž Zalar, prof. dr. Emil Žagar\ 
Založnik: Založba UL FRI, Ljubljana\
Izdajatelj: UL Fakulteta za računalništvo in informatiko, Ljubljana\
Urednik: prof. dr. Franc Solina

#include "00_uvod.typ"

#include "01_Julia.typ"

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

#include "13_integrali.typ"

#include "14_povprecna_razdalja.typ"

#include "15_avtomatsko_odvajanje.typ"

#include "16_nde.typ"

//#include "17_nde_aproksimacija.typ"

#include "domace.typ"

#bibliography(style: "springer-lecture-notes-in-computer-science","reference.yml")
