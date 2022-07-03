inexactConvert.jl
===
There may be cases where precision loss is acceptable or even desired. This package handles type conversion where you don't care about the accuracy of the result and just need it to succeed. 

Implements the following:

inexactConvert()
---
- `inexactConvert(T::Type,x)`
- `inexactConvert(x,y)`
  - Returns `y` converted to `typeof(x)`. Same as `inexactOfType()`.
- `inexactConvert(T::Type{q},x::w,r::Base.RoundingMode = Base.RoundNearest) where {q <: Integer,w <: Union{AbstractFloat,Integer,Rational}}`
  - Automagically handles rounding if required.
  - Will reduce the value to fit within the requested type if it is too large/small. 
  - The default rounding mode for this function is `Base.RoundNearest` but you can set it manually if you have different needs.
- `inexactConvert(T::Union{Type{q},q},x::AbstractIrrational) where q <: Number`
  - Irrational numbers are converted to a Float approximation and then to final type. ($\pi$ becomes 3 when converted to an Integer. Fun!)
- `inexactConvert(T::Type{q},x::Complex) where q <: Real`
  - For complex -> real, discards imaginary part of value

inexactOfType()
---
`inexactOfType(x,y)`
- Same behavior as `inexactConvert()` but with syntax like `oftype()`.

clip()
---
Similar to `clamp()` but allows you to specify the desired return type. These functions use `inexactConvert()` to give a reasonable approximation if a direct conversion is not possible.

- `clip(x,lo,hi,T::Type)`
- `clip(x,lo,hi)`
- `clip(x,T::Type)`
- `clip(x,r::q) where q <: Union{AbstractVector,Tuple}`
