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
show(io::IO, a::DualNumber) = print(io, a.x, " + ", a.dx, "ε")

ε = DualNumber(0, 1)
convert(::Type{DualNumber}, x::Real) = DualNumber(x, zero(x))
promote_rule(::Type{DualNumber}, ::Type{<:Number}) = DualNumber
# dual number

# operacije
import Base: +, -, *, /, ^
*(a::DualNumber, b::DualNumber) = DualNumber(a.x * b.x, a.x * b.dx + a.dx * b.x)
+(a::DualNumber, b::DualNumber) = DualNumber(a.x + b.x, a.dx + b.dx)
-(a::DualNumber) = DualNumber(-a.x, -a.dx)
-(a::DualNumber, b::DualNumber) = DualNumber(a.x - b.x, a.dx - b.dx)
^(a::DualNumber, b::Number) = DualNumber(a.x^b, b * a.x^(b - 1) * a.dx)
^(a::Number, b::DualNumber) = DualNumber(a^b.x, log(a)a^b.x * b.dx)
# operacije
# funkcije
import Base: sin, cos, exp, log
sin(a::DualNumber) = DualNumber(sin(a.x), cos(a.x) * a.dx)
cos(a::DualNumber) = DualNumber(cos(a.x), -sin(a.x) * a.dx)
exp(a::DualNumber) = DualNumber(exp(a.x), exp(a.x) * a.dx)
log(a::DualNumber) = DualNumber(log(a.x), a.dx / a.x)
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

Predstavlja vrednost `f` odvisno od `n` spremenljivk in njen gradient
``\\nabla f = f__1 \\frac{\\partial}{\\partial x_1} + f_2 \\frac{\\partial}{\\partial x_2}
+ ... f_n \\frac{\\partial}{\\partial x_n}``.
"""
struct Dual <: Number
    x::Float64
    dx::Vector{Float64}
end

odvod(y::Dual) = y.dx
vrednost(y::Dual) = y.x

convert(::Type{Dual}, x::Real) = Dual(x, [zero(x)])
promote_rule(::Type{Dual}, ::Type{<:Number}) = Dual
# vektor dual
# operacije dual
*(a::Dual, b::Dual) = Dual(a.x * b.x, a.x * b.dx .+ a.dx * b.x)
+(a::Dual, b::Dual) = Dual(a.x + b.x, a.dx .+ b.dx)
-(a::Dual) = Dual(-a.x, -a.dx)
-(a::Dual, b::Dual) = Dual(a.x - b.x, a.dx .- b.dx)
^(a::Dual, b::Float64) = Dual(a.x .^ b, b * a.x^(b - 1) * a.dx)
^(a::Float64, b::Dual) = Dual(a .^ b.x, log(a) * a^b.x * b.dx)
/(a::Dual, b::Dual) = Dual(a.x / b.x, (b.x * a.dx - a.x * b.dx) / b.x^2)
/(a::Float64, b::Dual) = Dual(a / b.x, (-a * b.dx / b.x^2))
# operacije dual
# funkcije dual
sin(a::Dual) = Dual(sin(a.x), cos(a.x) * a.dx)
cos(a::Dual) = Dual(cos(a.x), -sin(a.x) * a.dx)
exp(a::Dual) = Dual(exp(a.x), exp(a.x) * a.dx)
log(a::Dual) = Dual(log(a.x), a.dx / a.x)
# funkcije dual

# gradient
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

gradient(f, x::Vector) = odvod(f(spremenljivka(x)))
# gradient

end # module Vaja15
