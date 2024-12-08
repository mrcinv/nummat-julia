module Vaja06
# lestev
using Graphs
"""
    G = krozna_lestev(n)

Ustvari graf krožna lestev z `2n` točkami.
"""
function krozna_lestev(n)
  G = SimpleGraph(2 * n)
  # prvi cikel
  for i = 1:n-1
    add_edge!(G, i, i + 1)
  end
  add_edge!(G, 1, n)
  # drugi cikel
  for i = n+1:2n-1
    add_edge!(G, i, i + 1)
  end
  add_edge!(G, n + 1, 2n)
  # povezave med obema cikloma
  for i = 1:n
    add_edge!(G, i, i + n)
  end
  return G
end
# lestev
# matrika
using SparseArrays
"""
    A = matrika(G::AbstractGraph, sprem)

Poišči matriko sistema linearnih enačb za vložitev grafa `G` s fizikalno metodo.
Argument `sprem` je vektor vozlišč grafa, ki nimajo določenih koordinat.
Indeksi v matriki `A` ustrezajo vozliščem v istem vrstnem redu,
kot nastopajo v argumentu `sprem`.
"""
function matrika(G::AbstractGraph, sprem)
  # preslikava med vozlišči in indeksi v matriki
  v_to_i = Dict([sprem[i] => i for i in eachindex(sprem)])
  m = length(sprem)
  A = spzeros(m, m)
  for i = 1:m
    vertex = sprem[i]
    sosedi = neighbors(G, vertex)
    for vertex2 in sosedi
      if haskey(v_to_i, vertex2)
        j = v_to_i[vertex2]
        A[i, j] = 1
      end
    end
    A[i, i] = -length(sosedi)
  end
  return A
end
# matrika

# desne strani
"""
    b = desne_strani(G::AbstractGraph, sprem, koordinate)

Poišči desne strani sistema linearnih enačb za eno koordinato vložitve grafa `G`
s fizikalno metodo. Argument `sprem` je vektor vozlišč grafa, ki nimajo
določenih koordinat. Argument `koordinate` vsebuje eno koordinato za vsa
vozlišča grafa. Metoda uporabi le koordinato vozlišč, ki so pritrjena.
Indeksi v vektorju `b` ustrezajo vozliščem v istem vrstnem redu,
kot nastopajo v argumentu `sprem`.
"""
function desne_strani(G::AbstractGraph, sprem, koordinate)
  set = Set(sprem)
  m = length(sprem)
  b = zeros(m)
  for i = 1:m
    v = sprem[i]
    for v2 in neighbors(G, v)
      if !(v2 in set) # dodamo le točke, ki so fiksirane
        b[i] -= koordinate[v2]
      end
    end
  end
  return b
end
# desne strani

# vlozitev
"""
    vlozi!(G::AbstractGraph, fix, tocke)

Poišči vložitev grafa `G` v prostor s fizikalno metodo. Argument `fix` vsebuje
vektor vozlišč grafa, ki imajo določene koordinate. Argument `tocke` je
začetna vložitev grafa. Koordinate vozlišč, ki niso pritrjena, bodo nadomeščene
z novimi koordinatami.

Metoda ne vrne ničesar, ampak zapiše izračunane koordinate v matriko `tocke`.
"""
function vlozi!(G::AbstractGraph, fix, tocke)
  sprem = setdiff(vertices(G), fix)
  dim, _ = size(tocke)
  A = matrika(G, sprem)
  for k = 1:dim
    b = desne_strani(G, sprem, tocke[k, :])
    x = cg(-A, -b) # matrika A je negativno defnitna
    tocke[k, sprem] = x
  end
end
# vlozitev


# cg
using Logging
"""
    x = cg(A, b; atol=1e-10)

Metoda konjugiranih gradientov za reševanje sistema enačb `Ax = b`
s pozitivno definitno matriko `A`. Argument `A` ni nujno matrika, lahko je
tudi drugega tipa, če ima implementirano množenje z vektorjem `b`.

Metoda ne preverja, ali je argument `A` pozitivno definiten.
"""
function cg(A, b; atol=1e-8)
  # za začetni približek vzamemo kar desne strani
  x = copy(b)
  r = b - A * b
  p = r
  res0 = sum(r .* r)
  for i = 1:length(b)
    Ap = A * p
    alpha = res0 / sum(p .* Ap)
    x = x + alpha * p
    r = r - alpha * Ap
    res1 = sum(r .* r)
    if sqrt(res1) < atol
      @info "Metoda KG konvergira po $i korakih."
      break
    end
    p = r + (res1 / res0) * p
    res0 = res1
  end
  return x
end
# cg

export cg, vlozi!, krozna_lestev
end # module Vaja06
