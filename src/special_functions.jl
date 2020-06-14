for f in (:log, :log2, :log10, :log1p, :exp, :exp2, :exp10, :expm1,
          :cos, :sin, :tan, :sec, :csc, :cot, :acos, :asin, :atan,
          :cosh, :sinh, :tanh, :sech, :csch, :coth, :acosh, :asinh, :atanh,
          :eint, :li2, :gamma, :lngamma, :digamma, :zeta, :erf, :erfc,
          :j0, :j1, :y0, :y1, :ai)
    fJ = Symbol(f, :!)
    @eval begin
        export $fJ
        function ($fJ)(rop::BigFloat, op::BigFloat, rnd=ROUNDING_MODE[])
            ccall(($(string("mpfr_", f)), :libmpfr), Int32,
                  (Ref{BigFloat}, Ref{BigFloat}, MPFR.MPFRRoundingMode),
                  rop, op, rnd)
            return rop
        end
    end
end


@doc """
    log!(rop, op, rnd)

Set `rop` to the natural logarithm of `op` rounded in the direction
`rnd`. Set `rop` to +0 if `op` is 1 (in all rounding modes), for
consistency with the ISOC99 and IEEE 754-2008 standards. Set `rop` to
−Inf if `op` is ±0 (i.e., the sign of the zero has no influence on the
result).
""" log!


@doc """
    log2!(rop, op, rnd)

Set `rop` to log₂ of `op` rounded in the direction `rnd`. Set `rop` to
+0 if `op` is 1 (in all rounding modes), for consistency with the
ISOC99 and IEEE 754-2008 standards. Set `rop` to −Inf if `op` is ±0
(i.e., the sign of the zero has no influence on the result).
""" log2!


@doc """
    log10!(rop, op, rnd)

Set `rop` to log\\_{10} of `op` rounded in the direction `rnd`. Set
`rop` to +0 if `op` is 1 (in all rounding modes), for consistency with
the ISOC99 and IEEE 754-2008 standards. Set `rop` to −Inf if `op` is
±0 (i.e., the sign of the zero has no influence on the result).
""" log10!


@doc """
    log1p!(rop, op, rnd)

Set `rop` to the logarithm of one plus `op`, rounded in the direction
`rnd`. Set `rop` to −Inf if `op` is −1.
""" log1p!


@doc """
    exp!(rop, op, rnd)

Set `rop` to the exponential of `op`, rounded in the direction `rnd`.
""" exp!


@doc """
    exp2!(rop, op, rnd)

Set `rop` to `2^op`, rounded in the direction `rnd`.
""" exp2!


@doc """
    exp10!(rop, op, rnd)

Set `rop` to `10^op`, rounded in the direction `rnd`.
""" exp10!


@doc """
    expm1!(rop, op, rnd)

Set `rop` to `e^op−1`, rounded in the direction `rnd`.
"""


@doc """
    cos!(rop, op, rnd)

Set `rop` to the cosine of `op`, rounded in the direction `rnd`.
""" cos!


@doc """
    sin!(rop, op, rnd)

Set `rop` to the sine of `op`, rounded in the direction `rnd`.
""" sin!


@doc """
    tan!(rop, op, rnd)

Set `rop` to the tangent of `op`, rounded in the direction `rnd`.
""" tan!


@doc """
    sec!(rop, op, rnd)

Set `rop` to the secant of `op`, rounded in the direction `rnd`.
""" sec!


@doc """
    csc!(rop, op, rnd)

Set `rop` to the cosecant of `op`, rounded in the direction `rnd`.
""" csc!


@doc """
    cot!(rop, op, rnd)

Set `rop` to the cotangent of `op`, rounded in the direction `rnd`.
""" cot!


@doc """
    acos!(rop, op, rnd)

Set `rop` to the arc-cosine of `op`, rounded in the direction
`rnd`. Note that since `acos(-1)` returns the floating-point number
closest to π according to the given rounding mode, this number might
not be in the output range `0≤rop<π` of the arc-cosine function;
still, the result lies in the image of the output range by the
rounding function.
""" acos!


@doc """
    asin!(rop, op, rnd)

Set `rop` to the arc-sine of `op`, rounded in the direction
`rnd`. Note that since `asin(1)` (resp. `asin(-1)`) returns the
floating-point number closest to π/2 (resp -π/2) according to the
given rounding mode, this number might not be in the output range
`-π/2≤rop<π/2` of the arc-sine function; still, the result lies in the
image of the output range by the rounding function.
""" asin!


@doc """
    atan!(rop, op, rnd)

Set `rop` to the arc-tangent of `op`, rounded in the direction
`rnd`. Note that since `atan(Inf)` (resp. `atan(-Inf)`) returns the
floating-point number closest to π/2 (resp -π/2) according to the
given rounding mode, this number might not be in the output range
`-π/2≤rop<π/2` of the arc-sine function; still, the result lies in the
image of the output range by the rounding function. The same holds for
`atan(op)` with large `op` and small precision of `rop`.
""" atan!


@doc """
    cosh!(rop, op, rnd)

Set `rop` to the hyperbolic cosine of `op`, rounded in the direction
`rnd`.
""" cosh!


@doc """
    sinh!(rop, op, rnd)

Set `rop` to the hyperbolic sine of `op`, rounded in the direction
`rnd`.
""" sinh!


@doc """
    tanh!(rop, op, rnd)

Set `rop` to the hyperbolic tangent of `op`, rounded in the direction
`rnd`.
""" tanh!


@doc """
    sech!(rop, op, rnd)

Set `rop` to the hyperbolic secant of `op`, rounded in the direction
`rnd`.
""" sech!


@doc """
    csch!(rop, op, rnd)

Set `rop` to the hyperbolic cosecant of `op`, rounded in the direction
`rnd`.
""" csch!


@doc """
    coth!(rop, op, rnd)

Set `rop` to the hyperbolic cotangent of `op`, rounded in the direction
`rnd`.
""" coth!


@doc """
    acosh!(rop, op, rnd)

Set `rop` to the inverse hyperbolic cosine of `op`, rounded in the
direction `rnd`.
""" acosh!


@doc """
    asinh!(rop, op, rnd)

Set `rop` to the inverse hyperbolic sine of `op`, rounded in the
direction `rnd`.
""" asinh!


@doc """
    atanh!(rop, op, rnd)

Set `rop` to the inverse hyperbolic tangent of `op`, rounded in the
direction `rnd`.
""" atanh!


@doc """
    eint!(rop, op, rnd)

Set `rop` to the exponential integral of `op`, rounded in the
direction `rnd`. This is the sum of Euler’s constant, of the logarithm
of the absolute value of `op`, and of the sum for k from 1 to infinity
of op^k/(k·k!). For positive `op`, it corresponds to the Ei function
at `op` (see formula 5.1.10 from the Handbook of Mathematical
Functions from Abramowitz and Stegun), and for negative `op`, to the
opposite of the E1 function (sometimes called eint1) at `−op` (formula
5.1.1 from the same reference).
""" eint!


@doc """
    li2!(rop, op, rnd)

Set `rop` to real part of the dilogarithm of `op`, rounded in the
direction `rnd`. MPFR defines the dilogarithm function as
−∫_{t=0}^op log(1−t)/t dt.

""" li2!


@doc """
    gamma!(rop, op, rnd)

Set `rop` to the value of the Gamma function on `op`, rounded in the
direction `rnd`. For gamma!, when `op` is a negative integer, `rop` is
set to NaN.
""" gamma!


@doc """
    lngamma!(rop, op, rnd)

Set `rop` to the value of the logarithm of the Gamma function on `op`,
rounded in the direction `rnd`. When `op` is 1 or 2, set `rop` to +0
(in all rounding modes). When `op` is an infinity or a nonpositive
integer, set `rop` to +Inf, following the general rules on special
values. When `−2k−1<op<−2k`, `k` being a nonnegative integer, set
`rop` to NaN.
""" lngamma!


@doc """
    digamma!(rop, op, rnd)

Set `rop` to the value of the Digamma (sometimes also called Psi)
function on `op`, rounded inthe direction `rnd`. When `op` is a
negative integer, set `rop` to NaN.
""" digamma!


@doc """
    zeta!(rop, op, rnd)

Set `rop` to the value of the Riemann Zeta function on `op`, rounded
in the direction `rnd`.
""" zeta!


@doc """
    erf!(rop, op, rnd)

Set `rop` to the value of the error function on `op`, rounded in the
direction `rnd`.
""" erf!


@doc """
    erfc!(rop, op, rnd)

Set `rop` to the value of the complementary error function on `op`,
rounded in the direction `rnd`.
""" erfc!


@doc """
    j0!(rop, op, rnd)

Set `rop` to the value of the first kind Bessel function of order 0 on
`op`, rounded in the direction `rnd`. When `op` is NaN, `rop` is
always set to NaN. When `op` is ±Inf, `rop` is set to +0.
""" j0!


@doc """
    j1!(rop, op, rnd)

Set `rop` to the value of the first kind Bessel function of order 1 on
`op`, rounded in the direction `rnd`. When `op` is NaN, `rop` is
always set to NaN. When `op` is ±Inf, `rop` is set to +0. When `op` is
zero, `rop` is set to +0 or −0 depending on the sign of `op`.
""" j1!


@doc """
    y0!(rop, op, rnd)

Set `rop` to the value of the second kind Bessel function of order 0
on `op`, rounded in the direction `rnd`. When `op` is NaN or negative,
`rop` is always set to NaN. When `op` is +Inf, `rop` is set to
+0. When `op` is zero, `rop` is set to -Inf.

""" y0!


@doc """
    y1!(rop, op, rnd)

Set `rop` to the value of the second kind Bessel function of order 0
on `op`, rounded in the direction `rnd`. When `op` is NaN or negative,
`rop` is always set to NaN. When `op` is +Inf, `rop` is set to
+0. When `op` is zero, `rop` is set to -Inf.
""" y1!


@doc """
    ai!(rop, x, rnd)

Set `rop` to the value of the Airy function Ai on `x`, rounded in the
direction `rnd`.  When `x` is NaN, `rop` is always set to NaN. When
`x` is +Inf or −Inf, `rop` is +0. The current implementation is not
intended to be used with large arguments. It works with `|x|`
typically smaller than 500.
""" ai!


for f in (:sin_cos, :sinh_cosh)
    fJ = Symbol(f, :!)
    @eval begin
        export $fJ
        function ($fJ)(sop::BigFloat, cop::BigFloat, op::BigFloat, rnd=ROUNDING_MODE[])
            ccall($(string("mpfr_", f), :libmpfr), Int32,
                  (Ref{BigFloat}, Ref{BigFloat}, Ref{BigFloat}, MPFR.MPFRRoundingMode),
                  sop, cop, op, rnd)
            return (sop, cop)
        end
    end
end


@doc """
    sin_cos!(sop, cop, op, rnd)

Set simultaneously `sop` to the sine of `op` and `cop` to the cosine
of `op`, rounded in the direction `rnd` with the corresponding
precisions of `sop` and `cop`, which must be different variables.
""" sin_cos!


@doc """
    sinh_cosh!(sop, cop, op, rnd)

Set simultaneously `sop` to the hyperbolic sine of `op` and `cop` to
the hyperbolic cosine of `op`, rounded in the direction `rnd` with the
corresponding precisions of `sop` and `cop`, which must be different
variables.
""" sinh_cosh!


for f in (:atan2, :gamma_inc, :beta, :agm, :hypot)
    fJ = Symbol(f, :!)
    @eval begin
        export $fJ
        function ($fJ)(rop::BigFloat, op1::BigFloat, op2::BigFloat, rnd=ROUNDING_MODE[])
            ccall(($(string("mpfr_", f)), :libmpfr), Int32,
                  (Ref{BigFloat}, Ref{BigFloat}, Ref{BigFloat}, MPFR.MPFRRoundingMode),
                  rop, op1, op2, rnd)
            return rop
        end
    end
end


@doc """
    atan2!(rop, y, x, rnd)

Set `rop` to the arc-tangent2 of `y` and `x`, rounded in the direction
`rnd`: if x > 0, `atan2(y, x) = atan(y/x)`; if x < 0, `atan2(y, x) =
sign(y)*(π - atan(|y/x|))`, thus a number from `−π` to `π`. As for
`atan`, in case the exact mathematical result is `+π` or `−π`, its
rounded result might be outside the function output range.
""" atan2!


@doc """
    gamma_inc!(rop, op, op2, rnd)

Set `rop` to the incomplete Gamma function on `op1` and `op2`, rounded
in the direction `rnd`. (In the literature, `gamma_inc` is called
upper incomplete Gamma function, or sometimes complementary incomplete
Gamma function.) For `gamma_inc`, when `op2` is zero and `op` is a
negative integer, `rop` is set to NaN.

Note: the current implementation of `gamma_inc` is slow for large
values of `rop` or `op`, in which case some internal overflow might
also occur.
""" gamma_inc!


@doc """
    beta!(rop, op1, op2, rnd)

Set `rop` to the value of the Beta function at arguments `op1` and
`op2`. Note: the current code does not try to avoid internal overflow
or underflow, and might use a huge internal precisionin some cases.
""" beta!


export factorial!
"""
    factorial!(rop, op, rnd)

Set `rop` to the factorial of `op`, rounded in the direction `rnd`.
"""
function factorial!(rop::BigFloat, op::CulongMax, rnd=ROUNDING_MODE[])
    ccall(("mpfr_fac_ui", :libmpfr), Int32, (Ref{BigFloat}, Culong, MPFR.MPFRRoundingMode),
          rop, op, rnd)
    return rop
end


for f in (:jn, :yn)
    fJ = Symbol(f, :!)
    @eval begin
        export $fJ
        function ($fJ)(rop::BigFloat, n::ClongMax, op::BigFloat, rnd=ROUNDING_MODE[])
            ccall(($(string("mpfr_", f)), :libmpfr), Int32,
                  (Ref{BigFloat}, Clong, Ref{BigFloat}, MPFR.MPFRRoundingMode),
                  rop, n, op, rnd)
            return rop
        end
    end
end


@doc """
    jn!(rop, n, op, rnd)

Set `rop` to the value of the first kind Bessel function of order `n`
on `op`, rounded in the direction `rnd`. When `op` is NaN, `rop` is
always set to NaN. When `op` is ±Inf, `rop` is set to +0. When `op` is
zero, and `n` is not zero, `rop` is set to +0 or −0 depending on the
parity and sign of `n`, and the sign of `op`.
""" jn!


@doc """
    yn!(rop, n, op, rnd)

Set `rop` to the value of the second kind Bessel function of order `n`
on `op`, rounded in the direction `rnd`. When `op` is NaN or negative,
`rop` is always set to NaN. When `op` is +Inf, `rop` is set to
+0. When `op` is zero, `rop` is set to +Inf or −Inf depending on the
parity and sign of `n`.
""" yn!


@doc """
    agm!(rop, op1, op2, rnd)

Set `rop` to the arithmetic-geometric mean of `op1` and `op2`, rounded
in the direction `rnd`. The arithmetic-geometric mean is the common
limit of the sequences `u_n` and `v_n`, where `u0=op1`, `v0=op2`,
u_{n+1} is the arithmetic mean of `u_n` and `v_n`, and `v_{n+1}` is
the geometric mean of `u_n` and `v_n`. If any operand is negative and
the other one is not zero, set `rop` to NaN. If any operand is zero
and the other one is finite (resp. infinite), set `rop` to+0
(resp. NaN).
"""


@doc """
    hypot!(rop, op1, op2, rnd)


"""


for f in (:fma, :fms,)
    fJ = Symbol(f, :!)
    @eval begin
        export $fJ
        function ($fJ)(rop::BigFloat, op1::BigFloat, op2::BigFloat, op3::BigFloat,
                       rnd=ROUNDING_MODE[])
            ccall(($(string("mpfr_", f)), :libmpfr), Int32,
                  (Ref{BigFloat}, Ref{BigFloat}, Ref{BigFloat}, Ref{BigFloat},
                   MPFR.MPFRRoundingMode),
                  rop, op1, op2, op3, rnd)
            return rop
        end
    end
end


@doc """
    fma(rop, op1, op2, op3, rnd)

Set `rop` to `(op1×op2)+op3` rounded in the direction
`rnd`. Concerning special values (signed zeros, infinities, NaN),
these functions behave like a multiplication followed by a separate
addition or subtraction. That is, the fused operation matters only for
rounding.
""" fma!


@doc """
    fms(rop, op1, op2, op3, rnd)

Set `rop` to `(op1×op2)-op3` rounded in the direction
`rnd`. Concerning special values (signed zeros, infinities, NaN),
these functions behave like a multiplication followed by a separate
addition or subtraction. That is, the fused operation matters only for
rounding.
""" fms!


for f in (:fmma, :fmms,)
    fJ = Symbol(f, :!)
    @eval begin
        export $fJ
        function ($fJ)(rop::BigFloat, op1::BigFloat, op2::BigFloat, op3::BigFloat,
                       op4::BigFloat, rnd=ROUNDING_MODE[])
            ccall(($(string("mpfr_", f)), :libmpfr), Int32,
                  (Ref{BigFloat}, Ref{BigFloat}, Ref{BigFloat}, Ref{BigFloat},
                   Ref{BigFloat}, MPFR.MPFRRoundingMode),
                  rop, op1, op2, op3, op4, rnd)
            return rop
        end
    end
end

