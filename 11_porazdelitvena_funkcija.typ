= Porazdelitvena funkcija normalne porazdelitve

== Naloga

- Implementiraj porazdelitveno funkcijo standardne normalne porazdelitve
  $
    Phi(x) = 1/sqrt(2 pi) integral_(-oo)^x e^(-t^2/2) d t.
  $
- Poskrbi, da je relativna napaka manjša od $0.5 dot 10^{-11}$. Definicijsko območje      
  razdeli na več delov in na vsakem delu uporabi primerno metodo, da zagotoviš relativno 
  natančnost.
- Interval $(-oo, -1]$ transformiraj s funkcijo $1/x$ na interval $[-1, 0]$ in uporabi 
  interpolacijo s polinomom na Čebiševih točkah.
- Na intervalu $[-1, a]$ za primerno izbran $a$ uporabi Legendrove kvadrature.
- Izberi $a$, da je na intervalu $[a, oo)$ vrednost na 10 decimalk enaka $1$. 