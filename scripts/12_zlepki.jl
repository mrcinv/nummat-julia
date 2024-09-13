using Vaja12

f(x) = sin(x) + cos(2x)
df(x) = cos(x) - 2sin(2x)
x = range(0, 5, 7)
y = f.(x)
dy = df.(x)

z = HermitovZlepek(x, y, dy)

using Plots
plot(f, 0, 5, label="funkcija \$f(x)\$", legend=:bottomleft)
scatter!(x, y, label="interpolacijske točke")
plot!(x->z(x), 0, 5, label="zlepek \$Z(x)\$")

savefig("img/12-interpolacija.svg")

plot(x-> f(x) - z(x), 0, 3, label="napaka \$f(x)-Z(x)\$")
savefig("img/12-napaka.svg")

plot(x->(x-1)^2*(x-2)^2, 1, 2)

eps = 1e-6
h = (96*eps/20)^0.25
n = Integer(ceil((5 - 0)/h))
x = range(0, 5, n+1)
Z = HermitovZlepek(x, f.(x), df.(x))
plot(x->f(x)-Z(x), 0, 5, label="\$f(x)-Z(x)\$")

savefig("img/12-napaka-eps.svg")

using ForwardDiff
ddf(x) = ForwardDiff.derivative(df, x)
d3f(x) = ForwardDiff.derivative(ddf, x)
d4f(x) = ForwardDiff.derivative(d3f, x)

plot(d4f, 0, 5, label="4. odvod  \$f^{(4)}(x)\$")

savefig("img/12-odvod.svg")

using Polynomials, SpecialPolynomials

p_newton = fit(Newton, collect(x), f.(x))

plot(x->p_newton(x), 0, 5)

function npo(s)
  if s<=15
    return 1
  elseif s<=18
    return 1+0.0667*(s-15)
  else
    return 1.2
  end
end

plot(npo, 12, 22)