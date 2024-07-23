module Vaja06

# matrika
using SparseArrays
using Graphs

"""
    A = matrika(G::AbstractGraph, notr)

Poišči matriko sistema za linearni sistem za fizikalno metodo za vložitev grafa `G`.
Argument `notr` je vektor vozlišč grafa, ki nimajo določenih koordinat. Indeksi v matriki `A`
ustrezajo vozliščem v istem vrstnem redu, kot nastopajo v argumentu `notr`. 
"""
function matrika(G::AbstractGraph, notr)
  # preslikava med vozlišči in indeksi v matriki
  v_to_i = Dict([v[i] => i for i in eachindex(v)])
  m = length(notr)
  A = spzeros(m, m)
  for i = 1:m
    vertex = notr[i]
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
    b = desne_strani(G::AbstractGraph, notr, koordinate)

Poišči desne strani za linearni sistem za fizikalno metodo za vložitev grafa `G` za eno koordinato.
Argument `notr` je vektor vozlišč grafa, ki nimajo določenih koordinat. Argument `koordinate` 
vsebuje eno koordinato za vsa vozlišča grafa. Metoda uporabi le koordinato vozlišč, ki so fiksirana.
Indeksi v vektorju `b` ustrezajo vozliščem v istem vrstnem redu, kot nastopajo v argumentu `notr`. 
"""
function desne_strani(G::AbstractGraph, notr, koordinate)
  set = Set(notr)
  m = lenght(notr)
  b = zeros(m)
  for i = 1:m
    v = notr[i]
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
    vlozitev!(G::AbstractGraph, fix, tocke)

Poišči vložitev grafa `G` v prostor s fizikalno metodo. Argument `fix` vsebuje vektor vozlišč
grafa, ki imajo določene koordinate. Argument `tocke` je začetna vložitev grafa. Koordinate
vozlišč, ki niso fiksirane, bodo nadomeščene z novimi koordinatami. 
Metoda ne vrne ničesar, ampak zapiše izračunane koordinate v matriko `tocke`. 
"""
function vlozitev!(G::AbstractGraph, fix, tocke)
  notr = setdiff(vertices(G), fix)
  dim = length(first(tocke))
  A = matrika(G, notr)
  for k = 1:dim
    b = desne_strani(G, notr, tocke[k, :])
    x = cg(-A, -b) # matrika A je negativno defnitna
    tocke[k, notr] = x
  end
end
# vlozitev


# cg
using Logging
"""
    x = cg(A, b, x0; atol=1e-10)

metoda konjugiranih gradientov za reševanje sistema enačb `Ax = b`
s pozitivno definitno matriko `A`. Argument `A` ni nujno matrika, lahko je 
tudi drugega tipa, če ima implementirano množenje z vektorjem `b`. 

Metoda ne preverja ali je argument `A` pozitivno definiten.
"""
function cg(A, b, x=nothing; atol=1e-8)
  if x === nothing
    x = copy(b)
  end
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

export cg, vlozitev!
end # module Vaja06
