export inexactConvert,inexactOfType,clip #,($)

########################

#Similar to clamp but guarantees return type remains unchanged.
clip(x,lo,hi,T::Type) = inexactConvert(T,clamp(x,lo,hi))
clip(x,lo,hi) = clip(x,lo,hi,typeof(x))
clip(x,T::Type) = clip(x,typemin(T),typemax(T)) # Clips x to fit within possible values of type T
clip(x,r::q) where q <: Union{AbstractVector,Tuple} = clip(x,minimum(r),maximum(r)) # Grabs highest and lowest value in Tuple or vector

##
# Exported methods
##

inexactConvert(T::Type,x) = convert(T,x) # Fallback
inexactConvert(x,y) = inexactConvert(typeof(x),y)
inexactOfType(x,y) = inexactConvert(x,y) 
#($)(x,y) = inexactConvert(x,y) # Shorthand. x$y x$=y etc.

function inexactConvert(T::Type{q},x::w,r::Base.RoundingMode = Base.RoundNearest) where {q <: Integer,w <: Union{AbstractFloat,Integer,Rational}}
    """Handle conversion from anything that can be rounded."""
    x = round(x,r)
    try
        x = _clip(x,typemin(T),typemax(T)) # Do not switch to `clamp()`!
    catch
        # If desired type doesn't implement typemin/typemax, try with Int
        x = _clip(x,typemin(Int),typemax(Int))
    end
    return convert(T,x)
end

function inexactConvert(T::Union{Type{q},q},x::AbstractIrrational) where q <: Number
    """Irrational numbers are converted to an appropriate Float type before continuing"""
    return inexactConvert(T,convert(AbstractFloat,x))
end

function inexactConvert(T::Type{q},x::Complex) where q <: Real
    """Complex types are reduced to their Real component before conversion"""
    return inexactConvert(T,real(x))
end

##
# Internal untilities
## 

function _clip(x,lo,hi)
    """Special clip function for use within inexactConvert that does not rely on inexactConvert
    This is necessary for reliable float > integer conversion because using clamp() can produce values
        that are not useable by Base.convert()
    """
    x = x >= hi ? hi : x
    x = x <= lo ? lo : x
    return x
end