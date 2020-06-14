#=
@doc """
    cmp(op1, op2)

Compare `op1` and `op2`. Return a positive value if `op1>op2`, zero if
`op1=op2`, and a negative value if `op1<op2`. Both `op1` and `op2` are
considered to their full own precision, which may differ. If one of
the operands is NaN, set the `erange` flag and return zero.

Note: These functions may be useful to distinguish the three possible
cases. If you need to distinguish two cases only, it is recommended to
use the predicate functions (e.g., `equal_p` for the equality); they
behave like the IEEE 754 comparisons, in particular when one or both
arguments are NaN. But only floating-point numbers can be compared
(you may need to do a conversion first).
"""
=#


#=
e has type mpft_exp_t which must be at least 32 bits and it is defined
in mpfr.h according to the value of _MPFR_EXP_FORMAT. I set to it
Cint.
=#
export cmp_2exp
for (specC, tJ, tC) in ((:ui, CulongMax,  Culong),
                        (:si, ClongMax,   Clong))
    @eval begin
        function cmp_2exp(op1::BigFloat, op2::$tJ, e)
            isnan(op1) && throw(DomainError("op1 is NaN"))
            ccall(($(string("mpfr_cmp_", specC, "_2exp")), :libmpfr), Int32,
                  (Ref{BigFloat}, $tC, Cint), op1, op2, Int32(e))
        end
    end
end


@doc """
    cmp_2exp(op1, op2, e)

Compare `op1` and `op2 × 2^e`: returns a positive value if `op1>op2 ×
2^e`, zero if `op1=op2 × 2^e` or a negative number if `op1<op2 ×
2^e`. Throws an exception if `op1` is NaN.
""" cmp_2exp


for fJ = (:number_p, :regular_p)
    @eval begin
        export $fJ
        ($fJ)(op::BigFloat) =
            ccall(($(string(:mpfr_, fJ)), :libmpfr), Int32, (Ref{BigFloat},), op) != 0
    end
end


@doc """
    number_p(op)

Return true if `op` is an ordinary number (i.e., neither NaN nor an
infinity). Return false otherwise.
""" number_p


@doc """
    regular_p(op)

Return true if `op` is a regular number (i.e., neither NaN, nor an
infinity nor zero). Return false otherwise.
""" regular_p


export cmpabs
"""
    cmpabs(op1, op2)

Compare `|op1|` and `|op2|`. Return a positive value if `|op1|>|op2|`,
zero if `|op1|=|op2|`, and a negative value if `|op1|<|op2|`. Raise a
DomainError exception if one of the operands is NaN.
"""
function cmpabs(op1::BigFloat, op2::BigFloat)
    isnan(op1) || isnan(op2) && throw(DomainError("Operands must not be NaNs"))
    ccall((:mpfr_cmpabs, "libmpfr"), Int32, (Ref{BigFloat}, Ref{BigFloat}),
          op1, op2)
end


export unordered_p
"""
    unordered_p(op1, op2)

Return true if `op1` or `op2` is a NaN (i.e., they cannot be
compared), false otherwise.
"""
unordered_p(op1::BigFloat, op2::BigFloat) =
    ccall((:mpfr_unordered_p, "libmpfr"), Int32, (Ref{BigFloat}, Ref{BigFloat}),
          op1, op2) != 0

