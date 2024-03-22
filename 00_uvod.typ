#heading(outlined: false, numbering: none)[Predgovor] 

Knjiga je prvenstveno namenjena študentom predmeta Numerična matematika na Fakulteti za
računalništvo in informatiko, Univerze v Ljubljani. Vsebuje gradivo za vaje, domače naloge
in stare izpitne naloge. 

Vaje so zasnovane za delo v računalniški učilnici. Vaje so zasnovane tako, da omogočajo študentu, samostojno reševanje in ne zgolj prepisovanje s table. Vsaka vaja se začne z opisom naloge in jasnimi navodili, kaj na naj bo končni rezultat. Nato sledijo vedno bolj podrobni namigi, kako se naloge lotiti. Na ta način lahko študentje rešijo nalogo z različno mero samostojnosti. Na koncu je rešitev naloge, ki ji lahko študentje sledijo brez dodatnega dela. Rešitev vključuje matematične izpeljave, programsko kodo in rezultate, ki jih dobimo, če programsko kodo uporabimo. 

Domače naloge so brez rešitev in naj bi jih študenti oziroma bralec rešili povsem samostojno.
Nekatere stare izpitne naloge so rešene, večina pa nima rešitve. Odločitev, da niso vključene
rešitve za vse izpitne naloge je namerna, saj bralec lahko verodostojno preveri svoje znanje le, če rešuje tudi naloge, za katere nima dostopa do rešitev. 

Kljub temu, da je knjiga namenjena študentom, je zasnovana tako, da je primerna za vse, ki bi se
radi naučili, kako uporabljati in implementirati osnovne algoritme numerične matematike. Primeri
programov so napisnani v programskem jeziku #link("https://julialang.org/")[Julia], ki je zasnovan za
učinkovito izvajanje računsko zahtevnih problemov.

Na tem mestu bi se rad zahvalil Bojanu Orlu, Emilu Žagarju, Petru Kinku, s katerimi sem sodeloval pri numeričnih predmetih na FRI. Veliko idej za naloge, ki so v tej knjigi, prihaja prav od njih. Prav tako bi se zahvalil članom laboratorija LMMRI posebej Neži Mramor Kosta, Damiru Franetiču in Aljažu Zalarju, ki so tako ali drugače prispevali k nastanku te knjige. Moja draga žena Mojca Vilfan je opravila delo urednika, za kar sem ji izjemno hvaležen. Na koncu bi se zahvalil študentom, ki so obiskovali numerične predmete, ki sem jih učil in so me naučili marsikaj novega.

#heading(numbering: none)[Uvod]

Ta knjiga vsebuje gradiva za izvedbo laboratorijskih vaj pri predmetu Numerična matematika na Fakulteti za računalništvo in informatiko, Univerze v Ljubljani. Kljub temu je namenjena vsem, ki bi se želili bolje spoznati z uporabo numeričnih metod in se naučiti uporabljati programski jezik #link("https://julialang.org/")[Julia]. Predpostavljamo, da je bralec vešč programiranja v kakem drugem programskem jeziku in knjige ni namenjena prvemu stiku s programiranjem.

Knjige o numerični matematiki se pogosto posvečajo predvsem matematičnim vprašanjem. Vsebina te knjige pa poskuša nasloviti bolj praktične vidike numerične matematike. Tako so primeri, če je le mogoče, povezani s problemom praktične narave s področja fizke, matematičnega modeliranja in računalništva, pri katerih lahko za rešitev problema uporabimo numerične metode.  

Bralcu svetujemo, da vso kodo napiše in preiskusi sam. Še bolje je, če kodo razšiti in spreminja. Bralca spodbujamo, da se čim bolj igra z napisano kodo. Koda, ki je navedena v tej knjigi, je minimalna različica kode, ki reši določen problem in še ustreza minimalnim standardom pisanja kvalitetne kode. Pogosto izpustimo preverbe ali implementacijo robnih primerov. Včasih opustimo obravnavo pričakovanih napak. Prednost smo dali berljivosti, pred kompletnostjo, da je bralcu lažje razumeti, kaj koda počne. 

#outline(
  title:[Kazalo],
  indent: auto,
  depth: 2
)
