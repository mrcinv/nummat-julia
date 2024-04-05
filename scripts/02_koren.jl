using BookUtils, Vaja02Koren

@capture("02_koren_1") do
  # koren1
  let
    x = 1.5
    for n = 1:5
      x = (x + 2 / x) / 2
      println(x)
    end
  end
  # koren1
end

capture("02_koren_3") do
  # koren3
  x = koren_heron(3, 1.7, 5)
  println("koren 3 je $(x)!")
  # koren3
end

capture("02_koren_4") do
  # koren4
  x = 2
  y = koren(x, 0.5 + x / 2)
  # koren4
end

capture("02_koren_5") do
  # koren5
  tangenta(x) = 0.5 + x / 2
  y = koren(10, tangenta(10))
  y = koren(200, tangenta(200))
  # koren5
end

# koren6
using Plots
plot(sqrt, 0, 10, label="y=sqrt(x)")
plot!(x -> 0.5 + x / 2, 0, 10, label="y=(1 + x)/2")
# koren6
savefig("img/02_koren_tangenta.svg")

# koren7
plot(sqrt, 0, 20, label="y=sqrt(x)")
plot!(Vaja02Koren.zacetni, 0, 20, label="y = zacetni(x)")
# koren7
savefig("img/02_koren_zacetni.svg")

capture("02_koren_8") do
  # koren8
  koren(10.0), koren(200.0), koren(2e10)
  # koren8
end