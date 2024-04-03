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

@capture("02_koren_3") do
  # koren3
  x = koren_heron(3, 1.7, 5)
  println("koren 3 je $(x)!")
  # koren3
end
