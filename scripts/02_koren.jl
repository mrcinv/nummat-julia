using NumMat

@capture("02_koren_3") do
  # koren3
  x = koren_heron(3, 1.7, 5)
  println("koren 3 je $(x)!")
  # koren3
end
