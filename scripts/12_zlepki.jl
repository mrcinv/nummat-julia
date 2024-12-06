using Vaja12
using BookUtils
capture("12-baza") do
# baza
A = [1 0 0 0; 1 1 1 1; 0 1 0 0; 0 1 2 3]
inv(A)
# baza
end

# zlepek
f(x) = cos(2x) + sin(3x)
df(x) = -2sin(2x) + 3cos(3x)
x = range(0, 6, 10)
y = f.(x)
dy = df.(x)

z = HermitovZlepek(x, y, dy)
# zlepek

# zl int
using Plots
plot(f, 0, 6, label="funkcija \$f(x)\$", legend=:topright)
plot!(x -> z(x), 0, 6, label="zlepek \$Z(x)\$")
scatter!(x, y, label="interpolacijske točke")
# zl int

savefig("img/12-interpolacija.svg")

# zl napaka
plot(x -> f(x) - z(x), 0, 6, label="napaka \$f(x)-Z(x)\$")
# zl napaka
savefig("img/12-napaka.svg")
# 4. odvod
using ForwardDiff
ddf(x) = ForwardDiff.derivative(df, x)
d3f(x) = ForwardDiff.derivative(ddf, x)
d4f(x) = ForwardDiff.derivative(d3f, x)

plot(d4f, 0, 5, label="4. odvod  \$f^{(4)}(x)\$", legend=:topright)
# 4. odvod

savefig("img/12-odvod.svg")
# predpisana napaka
eps = 1e-6
d4fmax = 100
h = (96 * eps / d4fmax)^0.25
n = Integer(ceil((5 - 0) / h))
x = range(0, 5, n + 1)
Z = HermitovZlepek(x, f.(x), df.(x))
plot(x -> f(x) - Z(x), 0, 5, label="\$f(x)-Z(x)\$")
# predpisana napaka

savefig("img/12-napaka-eps.svg")


# runge
f(x) = cos(2x) + sin(3x)
n = 65
x = range(0, 6, n + 1)
p_newton = interpoliraj(NewtonovPolinom, x, f.(x))

plot(f, 0, 6, label="\$f(x)\$")
plot!(x -> p_newton(x), 0, 6, label="\$p_{$n}(x)\$")
scatter!(x, f.(x), label="\$(x_i, f(x_i))\$")
# runge

savefig("img/12-runge.svg")

# run napaka
plot(x -> f(x) - p_newton(x), 0, 6, label="razlika \$f(x)-p_{$n}(x)\$")
# run napaka
savefig("img/12-runge-napaka.svg")

