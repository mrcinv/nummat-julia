# koren_heron
using Logging
"""
  y = koren_heron(x, x0, n)

Izračuna približek za koren števila `x` z `n` koraki Heronovega obrazca z začetnim
približkom `x0`.
"""
function koren_heron(x, x0, n)
  y = x0
  for i = 1:n
    y = (y + x / y) / 2
    @info "Približek na koraku $i je $y"
  end
  return y
end
# koren_heron

# zacetni
"""
  y0 = zacetni(x)

Izračunaj začetni približek za kvadratni koren števila `x` z uporabo
eksponenta za števila s plavajočo vejico. 
"""
function zacetni(x)
  d, ost = divrem(abs(exponent(x)), 2)
  m = significand(x) # mantisa
  koren2ost = (ost == 0) ? 1 : 1.4142135623730951 # koren(2^ost)
  koren2e = (1 << d) * koren2ost # koren(2^e)
  if x > 1
    return (0.5 + m / 2) * koren2e
  else
    return (0.5 + m / 2) / koren2e
  end
end
# zacetni

# koren2
"""
  y = koren(x, y0)

Izračunaj vrednost kvadratnega korena števila `x˙ s Heronovim obrazcem
z začetnim približkom `y0`. 
"""
function koren(x, y0)
  if x == 0.0
    # Vrednost 0 obravnavamo posebej, saj je relativna primerjava z 0
    # problematična
    return 0.0
  end
  delta = 5e-11 # zahtevana relativna natančnost rezultata
  maxit = 10 # 10 korakov je dovolj, če je začetni približek dober
  for i = 1:maxit
    y = (y0 + x / y0) / 2
    if abs(x - y^2) <= 2 * delta * abs(x)
      @info "Število korakov $i"
      return y
    end
    y0 = y
  end
  throw("Iteracija ne konvergira!")
end
# koren2

# koren_x
"""
  y = koren(x)

Izračunaj vrednost kvadratnega korena danega števila `x˙. 
"""
koren(x) = koren(x, zacetni(x))
# koren_x


export koren_heron, koren