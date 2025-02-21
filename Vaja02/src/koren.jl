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

# začetni
"""
  y0 = začetni(x)

Izračunaj začetni približek za kvadratni koren števila `x` z uporabo
eksponenta za števila s plavajočo vejico. 
"""
function začetni(x)
  d, ost = divrem(exponent(x), 2)
  m = significand(x) # mantisa
  koren2ost =  1.0 
  if (ost == 1) 
    koren2ost = 1.4142135623730951 # koren(2)
  elseif (ost == -1)
    koren2ost = 0.7071067811865475 # 1/koren(2)
  end
  koren2e = ldexp(koren2ost, d) # koren(2^e) = koren(2^ost) * 2^d
  return (0.5 + m / 2) * koren2e
end
# začetni

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
koren(x) = koren(x, začetni(x))
# koren_x


export koren_heron, koren