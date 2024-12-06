using BookUtils, Vaja02

@capture("02_koren_1") do
# koren1
y = 1.5
x = 2
for n = 1:5
  y = (y + x / y) / 2
  println(y)
end
# koren1
end

capture("02_koren_3") do
# koren3
x = koren_heron(3, 1.7, 5)
println("Koren 3 je $(x).")
# koren3
end

capture("02_koren_4") do
# koren4
x = 2
y = koren(x, 0.5 + x / 2)
# koren4
end

# koren5
tangenta(x) = 0.5 + x / 2
# koren5


capture("02_koren5a") do
# koren5a
y = koren(10, tangenta(10))
# koren5a
end

capture("02_koren5b") do
# koren5b
y = koren(200, tangenta(200))
# koren5b
end

# koren6
using Plots
plot(sqrt, 0, 10, label="y=sqrt(x)")
plot!(x -> 0.5 + x / 2, 0, 10, label="y=(1 + x)/2")
# koren6
savefig("img/02_koren_tangenta.svg")

# koren7
plot(sqrt, 0, 20, label="y=sqrt(x)")
plot!(Vaja02.zacetni, 0, 20, label="y = zacetni(x)")
# koren7
savefig("img/02_koren_zacetni.svg")

capture("02_koren_8") do
# koren8
koren(2.0), koren(200.0), koren(2e10)
# koren8
end
