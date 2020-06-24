# MPFR_wrap

[![Build Status](https://travis-ci.com/mzaffalon/MPFR_wrap.jl.svg?branch=master)](https://travis-ci.com/mzaffalon/MPFR_wrap.jl)
[![Coverage](https://codecov.io/gh/mzaffalon/MPFR_wrap.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/mzaffalon/MPFR_wrap.jl)

This module provides [Julia-language](https://julialang.org) wrappers
to the free/open-source [MPFR library](https://www.mpfr.org/) for
"multiple-precision floating-point computations with _correct
rounding_".

`MPFR_wrap.jl` does not introduce new types and instead makes use of
Julia's BigFloat but allows the user to perform in-place operations to
minimize garbage collection. `MPFR_wrap.jl`'s functions that modify
their input have names terminating with a bang (!) following the
standard Julia convention.

# Example

Compute `a = sqrt(3.5 + 0.8)`. Using operations defined in Julia's
`Base` for `BigFloats`
```julia
a = BigFloat("3.5", precision=1000)
b = BigFloat("0.8", precision=1000)
c = sqrt(a + b)
```
creates a temporary variable to hold the intermediate result of the
computation `a + b`.

Using `MPFR_wrap` for in-place computation
```julia
a = BigFloat("3.5", precision=1000)
b = BigFloat("0.8", precision=1000)
# add a and b and store the result in a
add!(a, a, b)
# take the square root of a and store it in a
sqrt!(a, a)
```
The last two operations can be combined into `sqrt!(a, add!(a, a, b))`
relying on `add!` to return the modified input `a`.

The file ``examples/pi_iterative.jl`` contains two methods for the
computation of π using the iterative method Brent-Salamin and the
Borwein cubic iteration taken from "A catalogue of mathematical
formulas involving π, with analysis" by David H. Bailey available
[online](https://www.davidhbailey.com/dhbpapers/pi-formulas.pdf).

The following shows the difference in execution time and memory
allocation for the Brent-Salamin method using standard and in-place
operations.

```julia
julia> @btime brent_salamin();
  336.484 ms (870 allocations: 11.88 MiB)

julia> @btime inplace_brent_salamin();
  129.504 ms (158 allocations: 413.14 KiB)
```

# List of exported functions

The following functions are exported:

1. Assignment functions
  * set!
2. Basic arithmetic functions
  * add!, sub!, mul!, div!
  * sqrt!, rec_sqrt!, cbrt!, root!, pow!
  * neg!, abs!
  * dim!
  * mul_2!
3. Comparison functions
  * cmp_2exp
  * number_p, regular_p
  * cmpabs
  * unordered_p
4. Special functions
  * log!, log2!, log10!, log1p!
  * exp!, exp2!, exp10!, exp1p!
  * cos!, sin!, tan!, sin_cos!
  * sec!, csc!, cot!
  * acos!, asin!, atan!, atan2!
  * cosh!, sinh!, atanh!
  * eint!, li!
  * gamma!, gamma_inc!, lngamma!, lgamma!, digamma!
  * beta!, zeta!, erf!
  * j0!, j1!, jn!, y0!, y1, yn!
  * fma!, fms!, fmma!, fmms!
  * agm!, hypot!, ai!
5. Integer and reminder related functions
  * ceil!, floor!, round!, roundeven!, trunc!
  * rint!, frac!
  * modf!, fmod!
  * integer_p
