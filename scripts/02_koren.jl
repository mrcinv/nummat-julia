using NumMat, Suppressor, Logging

local out
err = @capture_err begin
  out = @capture_out begin
    # koren3
    x = koren_heron(3, 1.7, 5)
    println("koren 3 je $(x)!")
    # koren3
  end
end

p("02_koren_3", err * out)