# co2 data
using FTPClient
url = "ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_weekly_mlo.txt"
io = download(url)
data = readlines(io)
# co2 data

# plot
filter!(l -> l[1] != '#', data)
data = strip.(data)
data = [split(line, r"\s+") for line in data]
data = [[parse(Float64, x) for x in line] for line in data]
filter!(l -> l[5] > 0, data)
t = [l[4] for l in data]
co2 = [l[5] for l in data]
using Plots
scatter(t, co2, xlabel="leto",
  ylabel="parts per milion (ppm)", label="co2", markersize=1)
# plot
savefig("img/11_co2.svg")

# normalni
using LinearAlgebra
A = hcat(ones(size(t)), t, t .^ 2, cos.(2pi * t), sin.(2pi * t))
N = A' * A
b = A' * co2
p = N \ b
# normalni

using BookUtils

capture("11_cond") do
  # cond
  cond(A), cond(N)
  # cond
end

# baza
plot(A[:, 1] / norm(A[:, 1]), ylims=[0, 0.025], label="\$A_1\$")
plot!(A[:, 2] / norm(A[:, 2]), label="\$A_2\$")
plot!(A[:, 3] / norm(A[:, 3]), label="\$A_3\$")
# baza
savefig("img/11_baza.svg")

# premik
τ = sum(t) / length(t)
A = hcat(ones(size(t)), t .- τ, (t .- τ) .^ 2, cos.(2pi * t), sin.(2pi * t))
o = cond(A)
# premik

BookUtils.p("11_cond_premik", o)

# qr
F = qr(A) # vrednost posebnega tipa, ki predstavlja QR razcep
p_qr = F \ co2 # ekvivalentno R\(Q'*b)
p_norm = (A' * A) \ (A' * co2) # rešitev z normalnim sistemom
razlika = norm(p_norm - p_qr)
# qr

BookUtils.p("11_razlika", razlika)

capture("11_p_qr") do
  p_qr
end

# trend
model_trend(t) = p_qr[1:3]' * [1, t - τ, (t - τ)^2]
plot(model_trend, t[1], t[end], label="Trend naraščanja CO2")
# trend

savefig("img/11_trend.svg")

capture("11_napoved") do
  # napoved
  model(t) = p_qr' * [1, t - τ, (t - τ)^2, cos(2pi * t), sin(2pi * t)]
  napoved = model.([2030, 2040, 2050])
  # napoved
end
