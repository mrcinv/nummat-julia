module Vaja15

export odvod, gradient, ε, DualNumber, Dual

# dual number
"""
        DualNumber(x, dx)

Predstavlja skalarno spremenljivko x in njen diferencial dx.
"""
struct DualNumber <: Number
    x::Float64
    dx::Float64
end

import Base: show, promote_rule, convert
"""Lepo izpiši dualno število `DualNumber(a, b)` kot `a + bε`."""
show(io::IO, a::DualNumber) = print(io, a.x, " + ", a.dx, "ε")

"""Dualna enota."""
ε = DualNumber(0, 1)
"Spremeni realno število v vrednost tipa `DualNumber`."
convert(::Type{DualNumber}, x::Real) = DualNumber(x, zero(x))
"Navadna števila avtomatsko promoviraj v dualna števila."
promote_rule(::Type{DualNumber}, ::Type{<:Number}) = DualNumber
# dual number

# operacije
import Base: +, -, *, /, ^
*(a::DualNumber, b::DualNumber) = DualNumber(a.x * b.x, a.x * b.dx + a.dx * b.x)
+(a::DualNumber, b::DualNumber) = DualNumber(a.x + b.x, a.dx + b.dx)
-(a::DualNumber) = DualNumber(-a.x, -a.dx)
-(a::DualNumber, b::DualNumber) = DualNumber(a.x - b.x, a.dx - b.dx)
/(a::DualNumber, b::DualNumber) = DualNumber(a.x / b.x,
    (b.x * a.dx - a.x * b.dx) / b.x^2)
^(a::DualNumber, b::Number) = DualNumber(a.x^b, b * a.x^(b - 1) * a.dx)
^(a::Number, b::DualNumber) = DualNumber(a^b.x, log(a)a^b.x * b.dx)
# operacije
# funkcije
import Base: sin, cos, exp, log, abs, isless, sqrt
sqrt(a::DualNumber) = DualNumber(sqrt(a.x), 0.5 / sqrt(a.x) * a.dx)
sin(a::DualNumber) = DualNumber(sin(a.x), cos(a.x) * a.dx)
cos(a::DualNumber) = DualNumber(cos(a.x), -sin(a.x) * a.dx)
exp(a::DualNumber) = DualNumber(exp(a.x), exp(a.x) * a.dx)
log(a::DualNumber) = DualNumber(log(a.x), a.dx / a.x)
abs(a::DualNumber) = DualNumber(abs(a.x), sign(a.x) * a.dx)
isless(a::DualNumber, b::DualNumber) = isless(a.x, b.x)
isless(a::DualNumber, b::Number) = isless(a.x, b)
# funkcije
# odvod
odvod(a::DualNumber) = a.dx
vrednost(a::DualNumber) = a.x

"""
    y = odvod(f<:Function, x)

Izračuna vrednost odvoda funkcije `f` v točki `x`.
"""
odvod(f, x) = odvod(f(x + ε))
# odvod
# vektor dual
"""
    Dual(x, dx::Vector)

Predstavlja vrednost `f`, odvisno od `n` spremenljivk, in njen gradient
``\\nabla f = f__1 \\frac{\\partial}{\\partial x_1} + f_2 \\frac{\\partial}{\\partial x_2}
+ ... f_n \\frac{\\partial}{\\partial x_n}``.
"""
struct Dual{T} <: Number
    x::T
    dx::Vector{T}
end

odvod(y::Dual) = y.dx
vrednost(y::Dual) = y.x
# vektor dual
# operacije dual
*(a::Dual, b::Dual) = Dual(a.x * b.x, a.x * b.dx + a.dx * b.x)
*(a::Number, b::Dual) = Dual(a * b.x, a * b.dx)
*(a::Dual, b::Number) = Dual(a.x * b, a.dx * b)
+(a::Dual, b::Dual) = Dual(a.x + b.x, a.dx + b.dx)
+(a::Number, b::Dual) = Dual(a + b.x, b.dx)
+(a::Dual, b::Number) = Dual(a.x + b, a.dx)
-(a::Dual) = Dual(-a.x, -a.dx)
-(a::Dual, b::Dual) = Dual(a.x - b.x, a.dx - b.dx)
-(a::Number, b::Dual) = Dual(a - b.x, -b.dx)
-(a::Dual, b::Number) = Dual(a.x - b, a.dx)
^(a::Dual, b::Number) = Dual(a.x .^ b, b * a.x^(b - 1) * a.dx)
^(a::Number, b::Dual) = Dual(a .^ b.x, log(a) * a^b.x * b.dx)
/(a::Dual, b::Dual) = Dual(a.x / b.x, (1 / b.x^2) * (b.x * a.dx - a.x * b.dx))
/(a::Number, b::Dual) = Dual(a / b.x, (-a * b.dx / b.x^2))
/(a::Dual, b::Number) = Dual(a.x / b, (1 / b) * a.dx)
# operacije dual
# funkcije dual
sqrt(a::Dual{T}) where {T} = Dual(sqrt(a.x), (0.5 / sqrt(a.x)) * a.dx)
sin(a::Dual) = Dual(sin(a.x), cos(a.x) * a.dx)
cos(a::Dual) = Dual(cos(a.x), -sin(a.x) * a.dx)
exp(a::Dual) = Dual(exp(a.x), exp(a.x) * a.dx)
log(a::Dual) = Dual(log(a.x), a.dx / a.x)
# funkcije dual

# gradient
"""
    x = spremenljivka(v)

Generiraj vektor `x` vektorskih dualnih števil za vrednost vektorske
spremenljivke `v`. Komponente vektorja `x` so vektorska dualna števila
z vrednostmi, enakimi komponentam vektorja `v`, in parcialnimi odvodi enakimi
1, če se indeksa komponente in parcialnega odvoda ujemata, in 0 sicer.
Rezultat te funkcije lahko uporabimo kot vhodni argument pri računanju
gradienta vektorske funkcije z argumentom `v`.
"""
function spremenljivka(v::Vector{T}) where {T}
    n = length(v)
    x = Vector{Dual}()
    for i = 1:n
        xi = Dual(convert(Float64, v[i]), zeros(Float64, n))
        xi.dx[i] = 1
        push!(x, xi)
    end
    return x
end

"""
    g = gradient(f, x)

Izračunaj gradient vektorske funkcije `f` v danem vektorju `x`.
# Primer
```jl
f(x) = x[1]*x[2] + x[2]*sin(x[1])
gradient(f, [1., 2.])
```
"""
gradient(f, x::Vector) = odvod(f(spremenljivka(x)))
# gradient

end # module Vaja15
