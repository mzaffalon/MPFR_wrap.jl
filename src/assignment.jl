export set!
for (specC, tJ, tC) in (("",    BigFloat,   Ref{BigFloat}),
                        ("_ui", CulongMax,  Culong),
                        ("_si", ClongMax,   Clong),
                        ("_d",  CdoubleMax, Cdouble),
                        ("_z",  BigInt,     Ref{BigInt}))

    @eval begin
        function set!(rop::BigFloat, op::$tJ, rnd=ROUNDING_MODE[])
            ccall(($(string("mpfr_set", specC)), "libmpfr"), Int32,
                  (Ref{BigFloat}, $tC, MPFR.MPFRRoundingMode),
                  rop, op, rnd)
            return rop
        end
    end
end


@doc """
    set!(rop, op, rnd)

Set the value of `rop` from `op`, rounded toward the given direction `rnd`.
""" set!
