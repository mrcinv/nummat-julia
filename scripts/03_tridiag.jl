using Random

begin
  Random.seed!(2)
  # sprehod
  """
  Simuliraj `n` korakov slučajnega sprehoda s prehodnima verjetnostima `p`
  in `1-p`.
  """
  function sprehod(p, n)
    x = zeros(n)
    for i = 1:n-1
      x[i+1] = rand() < p ? x[i] + 1 : x[i] - 1
    end
    return x
  end

  using Plots
  x = sprehod(0.5, 100)
  plot(x, label=false)
  scatter!(x, title="Prvih 100 korakov slučajnega sprehoda \$p=q=\\frac{1}{2}\$",
    label="\$X_m\$")
  # sprehod
end
savefig("img/03a_sprehod.svg")

# matrika_sprehod
using Vaja03
"""
  N = matrika_sprehod(k, p)

Sestavi fundamentalno matriko za slučajni sprehod, ki se konča, ko se prvič
za `k` korakov oddalji od izhodišča.
"""
matrika_sprehod(k, p) = Tridiag(-p * ones(2k - 2), ones(2k - 1), -(1 - p) * ones(2k - 2))
# matrika_sprehod

# koraki
"""
    Em = koraki(k, p)

Izračunaj pričakovano število korakov `Em`, ki jih potrebuje slučajni sprehod,
da doseže stanje `0` ali `2k`. Komponente vektorja `Em` vsebujejo pričakovano
število korakov, da sprehod pride v stanje `0` ali `2k`, če začne v stanju med
`1` in `2k - 1`.
"""
koraki(k, p) = matrika_sprehod(k, p) \ ones(2k - 1)
# koraki

using Plots
# koraki slika
Em = koraki(10, 0.5)
scatter(-9:9, Em, label="št. korakov", xticks=-9:9)
# koraki slika

savefig("img/03a_koraki.svg")

"""
    korak(k, p)

Izračunaj pričakovano število korakov, ki jih potrebuje slučajni sprehod, da se za `k`
korakov oddalji od izhodišča. Vrednost `p` je prehodna verjetnost, da se sprehod premakne
v levo.
"""
korak(k, p) = koraki(k - 1, p)[k]

# simulacija
using Random

"""
  x1 = naslednje_stanje(p, x0)

Simuliraj naslednje stanje slučajnega sprehoda z naključnim generatorjem števil.
"""
naslednje_stanje(p, x0) = x0 + (rand() < p ? -1 : 1)

"""
  st_korakov = simuliraj_sprehod(k, p)

Simuliraj slučajni sprehod s prehodnima verjetnostima `p` in `1-p`.
Vrni število korakov, ki jih slučajni sprehod potrebuje, da se prvič
oddalji za `k` korakov od izhodišča.
"""
function simuliraj_sprehod(k, p, x0=0)
  koraki = 0
  while (abs(x0) < k)
    x0 = naslednje_stanje(p, x0)
    koraki += 1
  end
  koraki
end
# simulacija

function sprehodi_dokler(x0, p, pogoj)
  sprehod = [x0]
  while (!pogoj(x0))
    x0 = naslednje_stanje(p, x0)
    push!(sprehod, x0)
  end
  return sprehod
end

let
  Random.seed!(247)
  plot(t -> -5, 0, 55, label=nothing)
  for i = 1:5
    sprehod = sprehodi_dokler(0, 0.5, x -> abs(x) > 4)
    plot!(sprehod, label=nothing)
    scatter!(sprehod, label=nothing)
  end
  plot!(t -> 5, 0, 55, label=nothing)
end

using BookUtils
capture("03_tridiag_1") do
  # poskus
  Random.seed!(691)
  n = 100_000
  k, p = 10, 0.5
  kp = sum([simuliraj_korake(k, p) for _ in 1:n]) / n
  println("Vzorčno povprečje za vzorec velikosti $n je $kp.")
  # poskus
end
