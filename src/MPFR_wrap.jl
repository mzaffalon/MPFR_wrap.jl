module MPFR_wrap

using Base.MPFR: MPFR, MPFRRoundingMode
using Base.MPFR: DEFAULT_PRECISION, ROUNDING_MODE
using Base.MPFR: CulongMax, ClongMax, CdoubleMax

include("assignment.jl")
include("basic_arithmetic.jl")
include("comparison.jl")
include("special_functions.jl")
include("integer_reminder.jl")

end # module
