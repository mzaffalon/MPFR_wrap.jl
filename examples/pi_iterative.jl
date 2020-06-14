using MPFR_wrap

const atol = BigFloat("1e-100000")
const prec = 333_000
const π_MPFR = BigFloat(π, prec)


function brent_salamin()
    old_prec = precision(BigFloat)
    setprecision(BigFloat, prec)
    a_prev, b_prev = big(1.0), 1 / sqrt(big(2.0))
    s_prev, π_prev = big(1.0) / 2, big(4.0)
    π_next = BigFloat()
    k, p2 = 1, big(2)
    while true
        a_next = (a_prev + b_prev) / 2
        b_next = sqrt(a_prev * b_prev)
        c_next = (a_next - b_next) * (a_next + b_next)
        s_next = s_prev - p2 * c_next
        π_next = 2a_next^2 / s_next
        #println("$k -> $pn")
        δπ = π_next - π_prev
        abs(δπ) ≤ atol && break
        a_prev, b_prev, s_prev, π_prev = a_next, b_next, s_next, π_next
        k += 1
        p2 *= 2
    end
    setprecision(BigFloat, old_prec)
    @assert isapprox(π_next, π_MPFR, atol=atol)
    (k, π_next)
end


function inplace_brent_salamin()
    a_prev = BigFloat(1, precision=prec)
    b_prev = BigFloat(2, precision=prec)
    rec_sqrt!(b_prev, b_prev)
    s_prev = BigFloat(0.5, precision=prec)
    π_prev = BigFloat(4, precision=prec)
    a_next = BigFloat(precision=prec)
    b_next = BigFloat(precision=prec)
    c_next = BigFloat(precision=prec)
    s_next = BigFloat(precision=prec)
    π_next = BigFloat(precision=prec)
    δπ = BigFloat(precision=prec)
    k = Int32(1)
    while true
        add!(a_next, a_prev, b_prev)
        div_2!(a_next, a_next, Int32(1))

        mul!(b_next, a_prev, b_prev)
        sqrt!(b_next, b_next)

        sub!(c_next, a_prev, a_next)
        sqr!(c_next, c_next)

        mul_2!(c_next, c_next, k)
        sub!(s_next, s_prev, c_next)

        sqr!(π_next, a_next)
        mul_2!(π_next, π_next, Int32(1))
        div!(π_next, π_next, s_next)

        sub!(δπ, π_next, π_prev)
        abs(δπ) ≤ atol && break

        a_prev, a_next = a_next, a_prev
        b_prev, b_next = b_next, b_prev
        s_prev, s_next = s_next, s_prev
        π_prev, π_next = π_next, π_prev

        k += Int32(1)
    end
    @assert isapprox(π_next, π_MPFR, atol=atol)
    (k, π_next)
end


function inplace_borwein_cubic()
    a_prev = BigFloat(1, precision=prec)
    div!(a_prev, a_prev, Int32(3))
    s_prev = BigFloat(3, precision=prec)
    sqrt!(s_prev, s_prev)
    sub!(s_prev, s_prev, Int32(1))
    div_2!(s_prev, s_prev, Int32(1))
    r_next = BigFloat(precision=prec)
    s_next = BigFloat(precision=prec)
    rsq_next = BigFloat(precision=prec)
    a_next = BigFloat(precision=prec)
    tmp = BigFloat(precision=prec)
    π_prev = BigFloat(0, precision=prec)
    π_next = BigFloat(precision=prec)
    δπ = BigFloat(precision=prec)
    k = Int32(0)
    while true
        pow!(r_next, s_prev, Int32(3))
        sub!(r_next, Int32(1), r_next)
        cbrt!(r_next, r_next)
        mul_2!(r_next, r_next, Int32(1))
        add!(r_next, r_next, Int32(1))
        div!(r_next, Int32(3), r_next)

        sub!(s_next, r_next, Int32(1))
        div_2!(s_next, s_next, Int32(1))

        sqr!(rsq_next, r_next)
        sub!(tmp, rsq_next, Int32(1))
        mul!(tmp, tmp, Int32(3)^k)
        mul!(a_next, rsq_next, a_prev)
        sub!(a_next, a_next, tmp)

        div!(π_next, Int32(1), a_next)
        sub!(δπ, π_next, π_prev)
        abs(δπ) ≤ atol && break

        a_prev, a_next = a_next, a_prev
        s_prev, s_next = s_next, s_prev
        π_prev, π_next = π_next, π_prev

        k += Int32(1)
    end
    @assert isapprox(π_next, π_MPFR, atol=atol)
    (k, π_next)
end
