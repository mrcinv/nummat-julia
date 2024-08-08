using FastGaussQuadrature

n = 10

function intexp(x, n)
  integrand(u) = exp(-(u - x)^2 / 2 + u)
  vozlisca, utezi = FastGaussQuadrature.gausslaguerre(n)
  I0 = vozlisca' * integrand.(utezi)
  vozlisca, utezi = FastGaussQuadrature.gausslaguerre(n + 1)
  I1 = vozlisca' * integrand.(utezi)
  return (I0, I1)
end


intexp(-10, 40)

using Vaja13

integrand(u) = u == 0 ? 0 : exp(-1/u^2)/u^2


n = 60
x = -10
I0 = integral(integrand, gl, (1/x, 0, n))
I1 = integral(integrand, gl, (1/x, 0, n+1))
(I1 - I0)/I1
exp(-7^2)

using Plots
plot(integrand, -0.5, 0)


function phi_adaptivna(x)
  k = x*exp(x^2)
  integrand(u) = exp(-1/u^2)/u^2 
  i, koraki = Vaja13.adaptive(u -> k*integrand(u), 
    Vaja13.legendre3, 1/x, 0, 1e-10)
  return i/k, koraki
end

x = -10
k = x*exp(x^2)
k*integrand(1/x)
Vaja13.adaptive(u->k*integrand(u), Vaja13.legendre3, -1/10, 0, 1e-8)

plot(x->phi_adaptivna(x)[2], -15, -1)

x = -14
exp(-x^2)