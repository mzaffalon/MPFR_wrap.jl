for f in (:ceil, :floor, :round, :roundeven, :trunc)
    fJ = Symbol(f, :!)
    @eval begin
        export $fJ
        function ($fJ)(rop::BigFloat, op::BigFloat)
            ccall(($(string("mpfr_", f)), :libmpfr), Int32,
                  (Ref{BigFloat}, Ref{BigFloat}), rop, op)
            return rop
        end
    end
end


@doc """
    ceil!(rop, op, rnd)

Set `rop` to `op` rounded to the next higher or equal representable
integer (like rint! with RNDU).

When `op` is a zero or an infinity, set `rop` to the same value with
the same sign.
""" ceil!


@doc """
    floor!(rop, op, rnd)

Set `rop` to `op` rounded to the next lower or equal representable
integer (like rint! with RNDD).

When `op` is a zero or an infinity, set `rop` to the same value with
the same sign.
""" floor!


@doc """
    round!(rop, op, rnd)

Set `rop` to `op` rounded to the nearest representable integer,
rounding halfway cases away from zero (as in the roundTiesToAway mode
of IEEE 754-2008).

When `op` is a zero or an infinity, set `rop` to the same value with
the same sign.
""" round!


@doc """
    roundeven!(rop, op, rnd)

Set `rop` to `op` rounded to the nearest representable integer,
rounding halfway cases with the even-rounding rule (like rint! with
RNDN).

When `op` is a zero or an infinity, set `rop` to the same value with
the same sign.
""" roundeven!


@doc """
    trunc!(rop, op, rnd)

Set `rop` to `op` rounded to the next representable integer toward
zero (like rint! with RNDZ).

When `op` is a zero or an infinity, set `rop` to the same value with
the same sign.
""" trunc!


for f in (:rint, :frac)
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


@doc """
    rint!(rop, op, rnd)

Set `rop` to `op` rounded to an integer to the nearest representable
integer in the given direction `rnd`.
"""


@doc """
    frac!(rop, op, rnd)

Set `rop` to the fractional part of `op`, having the same sign as
`op`, rounded in the direction `rnd` (unlike in rint!, `rnd` affects
only how the exact fractional part is rounded, not how the fractional
part is generated). When `op` is an integer or an infinity, set `rop`
to zero with the same sign as `op`.
""" frac!


export modf!
"""
    modf!(iop, fop, op, rnd)

Set simultaneously `iop` to the integral part of `op` and `fop` to the
fractional part of `op`, rounded in the direction `rnd` with the
corresponding precision of `iop` and `fop` (equivalent to `trunc!(iop,
op, rnd)` and `frac(fop, op, rnd)`). The variables `iop` and `fop`
must be different.
"""
function modf!(iop::BigFloat, fop::BigFloat, op::BigFloat, rnd=ROUNDING_MODE[])
    ccall((:mpfr_modf, "libmpfr"), Int32,
          (Ref{BigFloat}, Ref{BigFloat}, Ref{BigFloat}, MPFR.MPFRRoundingMode),
          iop, fop, op, rnd)
    return iop, fop
end


export fmod!
"""
    fmod!(r, x, y, rnd)

Set `r` to the value of `x − ny`, rounded according to the direction
`rnd`, where `n` is the integer quotient of `x` divided by `y`.
"""
function fmod!(r::BigFloat, x::BigFloat, y::BigFloat, rnd=ROUNDING_MODE[])
    ccall((:mpfr_fmod, "libmpfr"), Int32,
          (Ref{BigFloat}, Ref{BigFloat}, Ref{BigFloat}, MPFR.MPFRRoundingMode),
          r, x, y, rnd)
    return r
end


export integer_p
"""
    integer_p(op)

Return non-zero iff `op` is an integer.
"""
function integer_p(op::BigFloat)
    ccall((:mpfr_integer_p, "libmpfr"), Int32, (Ref{BigFloat},), op) != 0
end
