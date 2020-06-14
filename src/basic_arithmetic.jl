for oper in (:add, :sub, :mul, :div)
    fJ = Symbol(oper, :!)
    @eval begin
        export $fJ
    end

    for (specC, tJ, tC) in (("",    BigFloat,   Ref{BigFloat}),
                            ("_ui", CulongMax,  Culong),
                            ("_si", ClongMax,   Clong),
                            ("_d",  CdoubleMax, Cdouble),
                            ("_z",  BigInt,     Ref{BigInt}))

        @eval begin
            function ($fJ)(rop::BigFloat, op1::BigFloat, op2::$tJ, rnd=ROUNDING_MODE[])
                ccall(($(string("mpfr_", oper, specC)), "libmpfr"), Int32,
                      (Ref{BigFloat}, Ref{BigFloat}, $tC, MPFR.MPFRRoundingMode),
                      rop, op1, op2, rnd)
                return rop
            end
        end
    end
end


for oper in (:sub, :div)
    fJ = Symbol(oper, :!)
    for (specC, tJ, tC) in (("ui_", CulongMax,  Culong),
                            ("si_", ClongMax,   Clong),
                            ("d_",  CdoubleMax, Cdouble),
                            ("z_",  BigInt,     Ref{BigInt}))

        @eval begin
            function ($fJ)(rop::BigFloat, op1::$tJ, op2::BigFloat, rnd=ROUNDING_MODE[])
                ccall(($(string("mpfr_", specC,  oper)), "libmpfr"), Int32,
                      (Ref{BigFloat}, $tC, Ref{BigFloat}, MPFR.MPFRRoundingMode),
                      rop, op1, op2, rnd)
                return rop
            end
        end
    end
end


@doc """
    add!(rop, op1, op2, rnd)

Set `rop` to `op1+op2` rounded in the direction `rnd`. The IEEE 754
rules are used for signed zeros.

For types having no signed zeros, 0 is considered unsigned, i.e.,
`(+0)+0 = (+0)` and `(−0)+0 = (−0))`.
""" add!


@doc """
    sub!(rop, op1, op2, rnd)

Set `rop` to `op1-op2` rounded in the direction `rnd`. The IEEE 754
rules are used for signed zeros.

For types having no signed zeros, 0 is considered unsigned, i.e.,
`(+0)−0 = (+0)`, `(−0)−0 = (−0)`, `0−(+0) = (−0)` and `0−(−0) =
(+0))`.
""" sub!


@doc """
    mul!(rop, op1, op2, rnd)

Set `rop` to `op1×op2` rounded in the direction `rnd`. When a result
is zero, its sign is the product of the signs of the operands (for
types having no signed zeros, 0 is considered positive).
""" mul!


for f in (:sqr, :cbrt, :neg, :abs)
    fJ = Symbol(f, :!)
    @eval begin
        export $fJ
        function ($fJ)(rop::BigFloat, op::BigFloat, rnd=ROUNDING_MODE[])
            ccall(($(string("mpfr_", f)), "libmpfr"), Int32,
                  (Ref{BigFloat}, Ref{BigFloat}, MPFR.MPFRRoundingMode),
                  rop, op, rnd)
            return rop
        end
    end
end


for f in (:sqrt, :rec_sqrt)
    fJ = Symbol(f, :!)
    @eval begin
        export $fJ
        function ($fJ)(rop::BigFloat, op::BigFloat, rnd=ROUNDING_MODE[])
            op < 0 && throw(DomainError("Operand is negative"))
            ccall(($(string("mpfr_", f)), "libmpfr"), Int32,
                  (Ref{BigFloat}, Ref{BigFloat}, MPFR.MPFRRoundingMode),
                  rop, op, rnd)
            return rop
        end
    end
end


@doc """
    sqr!(rop, op, rnd)

Set `rop` to `op²` rounded in the direction `rnd`.
""" sqr!


@doc """
    sqrt!(rop, op, rnd)

Set `rop` to `√op` rounded in the direction `rnd`. Set `rop` to −0 if
`op` is −0, to be consistent with the IEEE 754 standard. Throw a
DomainError exception if `op` is negative.
""" sqrt!


@doc """
    rec_sqrt!(rop, op, rnd)

Set `rop` to 1/√op rounded in the direction `rnd`. Set `rop` to +Inf
if op is ±0,+0 if `op` is +Inf, and throw a DomainError exception if
`op` is negative. Warning!  Therefore the result on −0 is different
from the one of the `sqrt` function recommended by the IEEE 754-2008
standard (Section 9.2.1), which is −Inf instead of +Inf.
""" rec_sqrt!


@doc """
    cbrt!(rop, op, rnd)

Set `rop` to the cubic root of `op` rounded in the direction
`rnd`. For `op` negative (including −Inf), set `rop` to a negative
number. If `op` is zero, set `rop` to zero with the same sign as `op`.
""" cbrt!


export rootn!
"""
    rootn!(rop, op, k, rnd)

Set `rop` to the kth root of `op` rounded in the direction `rnd`. For
k=0, set `rop` to NaN. For k odd (resp. even) and `op` negative
(including −Inf), set `rop` to a negative number (resp. throw a
DomainError). If `op` is zero, set `rop` to zero with the sign
obtained by the usual limit rules, i.e., the same sign as `op` if `k`
is odd, and positive if `k` is even.

This function agrees with the `rootn` function of the IEEE 754-2008
standard (Section 9.2).
"""
function rootn!(rop::BigFloat, op::BigFloat, k::CulongMax, rnd=ROUNDING_MODE[])
    op < 0 && iseven(k) && throw(DomainError("Even root of negative number"))
    ccall((:mpfr_rootn_ui, "libmpfr"), Int32,
          (Ref{BigFloat}, Ref{BigFloat}, Culong, MPFR.MPFRRoundingMode), rop, op, k, rnd)
    return rop
end



export pow!
for (specC, tJ, tC) in (("",    BigFloat,   Ref{BigFloat}),
                        ("_ui", CulongMax,  Culong),
                        ("_si", ClongMax,   Clong),
                        ("_z",  BigInt,     Ref{BigInt}))

    @eval begin
        function pow!(rop::BigFloat, op1::BigFloat, op2::$tJ, rnd=ROUNDING_MODE[])
            ccall(($(string("mpfr_pow", specC)), "libmpfr"), Int32,
                  (Ref{BigFloat}, Ref{BigFloat}, $tC, MPFR.MPFRRoundingMode),
                  rop, op1, op2, rnd)
            return rop
        end
    end
end

function pow!(rop::BigFloat, op1::CulongMax, op2::CulongMax, rnd=ROUNDING_MODE[])
    ccall((:mpfr_ui_pow_ui, "libmpfr"), Int32,
          (Ref{BigFloat}, Culong, Culong, MPFR.MPFRRoundingMode),
          rop, op1, op2, rnd)
    return rop
end

function pow!(rop::BigFloat, op1::CulongMax, op2::BigFloat, rnd=ROUNDING_MODE[])
    ccall((:mpfr_ui_pow, "libmpfr"), Int32,
          (Ref{BigFloat}, Culong, Ref{BigFloat}, MPFR.MPFRRoundingMode),
          rop, op1, op2, rnd)
    return rop
end


@doc """
    pow!(rop, op1, op2, rnd)

Set `rop` to op1^op2, rounded in the direction `rnd`.

Special values are handled as described inthe ISO C99 and IEEE
754-2008 standards for the `pow!` function.
""" pow!



@doc """
    neg!(rop, op, rnd)

Set `rop` to `−op`, rounded in the direction `rnd`. Just changes or
adjusts the sign if `rop` and `op` are the same variable, otherwise a
rounding might occur if the precision of `rop` is less than that of
`op`.
""" neg!


@doc """
    abs!(rop, op, rnd)

Set `rop` to the absolute value of `op`, rounded in the direction
`rnd`. Just changes or adjusts the sign if `rop` and `op` are the same
variable, otherwise a rounding might occur if the precision of `rop`
is less than that of `op`.
""" abs!


export dim!
"""
    dim!(rop, op1, op2, rnd)

Set `rop` to the positive difference of `op1` and `op2`,
i.e.,`op1−op2` rounded in the direction `rnd` if `op1>op2`, +0 if
`op1≤op2`, and throws a DomainError if `op1` or `op2` is NaN.
"""
function dim!(rop::BigFloat, op1::BigFloat, op2::BigFloat, rnd=ROUNDING_MODE[])
    isnan(op1) || isnan(op2) && throw(DomainError("Operands are NaNs"))
    ccall((:mpfr_dim, "libmpfr"), Int32,
          (Ref{BigFloat}, Ref{BigFloat}, Ref{BigFloat}, MPFR.MPFRRoundingMode),
          rop, op1, op2, rnd)
    return rop
end


for oper in (:mul_2, :div_2)
    fJ = Symbol(oper, :!)
    @eval begin
        export $fJ
    end
    for (specC, tJ, tC) in ((:ui, CulongMax,  Culong),
                            (:si, ClongMax,   Clong))

        @eval begin
            function ($fJ)(rop::BigFloat, op1::BigFloat, op2::$tJ, rnd=ROUNDING_MODE[])
                #ccall(($(string(:mpfr_, oper, specC)), "libmpfr"), Int32,
                ccall(($(string(:mpfr_, oper, specC)), "libmpfr"), Int32,
                      (Ref{BigFloat}, Ref{BigFloat}, $tC, MPFR.MPFRRoundingMode),
                      rop, op1, op2, rnd)
                return rop
            end
        end
    end
end


@doc """
    mul_2!(rop, op1, op2, rnd)

Set `rop` to `op1×2^op2` rounded in the direction `rnd`. Just
increases the exponent by `op2` when `rop` and `op1` are identical.
""" mul_2!


@doc """
    div_2!(rop, op1, op2, rnd)

Set `rop` to `op1/2^op2` rounded in the direction `rnd`. Just
decreases the exponent by `op2` when `rop` and `op1` are identical.
""" div_2!
