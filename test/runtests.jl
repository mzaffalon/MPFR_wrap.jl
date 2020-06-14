using MPFR_wrap
using Test
using Base.MPFR


@testset "assignment" begin
    prec, atol = 512, 1e-100
    c = BigFloat(precision=prec)

    @test set!(c, BigFloat("3", precision=prec)) == BigFloat("3", precision=prec)
    @test set!(c, UInt32(3)) == BigFloat("3", precision=prec)
    @test set!(c, Int32(-3)) == BigFloat("-3", precision=prec)
    @test set!(c, -3.0) == BigFloat("-3", precision=prec)
end


@testset "basic arithmetic functions" begin
    prec, atol = 512, 1e-100
    c = BigFloat("1.0", precision=prec)

    add!(c, BigFloat("1.2", precision=prec), BigFloat("1.3", precision=prec))
    @test isapprox(c, BigFloat("2.5", precision=prec), atol=atol)
    add!(c, BigFloat("1.2", precision=prec), UInt32(2))
    @test isapprox(c, BigFloat("3.2", precision=prec), atol=atol)
    add!(c, BigFloat("1.2", precision=prec), Int32(-2))
    @test isapprox(c, BigFloat("-0.8", precision=prec), atol=atol)
    add!(c, BigFloat("1.2", precision=prec), -2.0)
    @test isapprox(c, BigFloat("-0.8", precision=prec), atol=atol)
    add!(c, BigFloat("1.2", precision=prec), BigInt(-4))
    @test isapprox(c, BigFloat("-2.8", precision=prec), atol=atol)

    sub!(c, BigFloat("1.2", precision=prec), BigFloat("1.3", precision=prec))
    @test isapprox(c, BigFloat("-0.1", precision=prec), atol=atol)
    sub!(c, BigFloat("1.2", precision=prec), UInt32(2))
    @test isapprox(c, BigFloat("-0.8", precision=prec), atol=atol)
    sub!(c, BigFloat("1.2", precision=prec), Int32(-2))
    @test isapprox(c, BigFloat("3.2", precision=prec), atol=atol)
    sub!(c, BigFloat("1.2", precision=prec), -2.0)
    @test isapprox(c, BigFloat("3.2", precision=prec), atol=atol)
    sub!(c, BigFloat("1.2", precision=prec), BigInt(-4))
    @test isapprox(c, BigFloat("5.2", precision=prec), atol=atol)
    sub!(c, UInt32(2), BigFloat("1.2", precision=prec))
    @test isapprox(c, BigFloat("0.8", precision=prec), atol=atol)
    sub!(c, Int32(-2), BigFloat("1.2", precision=prec))
    @test isapprox(c, BigFloat("-3.2", precision=prec), atol=atol)
    sub!(c, -2.0, BigFloat("1.2", precision=prec))
    @test isapprox(c, BigFloat("-3.2", precision=prec), atol=atol)
    sub!(c, BigInt(-4), BigFloat("1.2", precision=prec))
    @test isapprox(c, BigFloat("-5.2", precision=prec), atol=atol)

    sqr!(c, BigFloat("2", precision=prec))
    @test isapprox(c, BigFloat("4", precision=prec), atol=atol)

    sqrt!(c, BigFloat("4", precision=prec))
    @test isapprox(c, BigFloat("2", precision=prec), atol=atol)
    @test_throws DomainError sqrt!(c, BigFloat("-4", precision=prec))

    rec_sqrt!(c, BigFloat("4", precision=prec))
    @test isapprox(c, BigFloat("0.5", precision=prec), atol=atol)

    cbrt!(c, BigFloat("-27", precision=prec))
    @test isapprox(c, BigFloat("-3", precision=prec), atol=atol)

    rootn!(c, BigFloat("81", precision=prec), UInt32(4))
    @test isapprox(c, BigFloat("3", precision=prec), atol=atol)
    @test_throws DomainError rootn!(c, BigFloat("-4"), UInt32(4))

    pow!(c, BigFloat("3", precision=prec), BigFloat("3", precision=prec))
    @test isapprox(c, BigFloat("27", precision=prec), atol=atol)
    pow!(c, BigFloat("3", precision=prec), UInt32(3))
    @test isapprox(c, BigFloat("27", precision=prec), atol=atol)
    pow!(c, BigFloat("3", precision=prec), Int32(3))
    @test isapprox(c, BigFloat("27", precision=prec), atol=atol)
    pow!(c, BigFloat("3", precision=prec), BigInt(3))
    @test isapprox(c, BigFloat("27", precision=prec), atol=atol)
    pow!(c, UInt32(3), UInt32(3))
    @test isapprox(c, BigFloat("27", precision=prec), atol=atol)
    pow!(c, UInt32(3), BigFloat("3", precision=prec))
    @test isapprox(c, BigFloat("27", precision=prec), atol=atol)

    neg!(c, BigFloat("-27", precision=prec))
    @test isapprox(c, BigFloat("27", precision=prec), atol=atol)

    abs!(c, BigFloat("-27", precision=prec))
    @test isapprox(c, BigFloat("27", precision=prec), atol=atol)

    dim!(c, BigFloat("27", precision=prec), BigFloat("20", precision=prec))
    @test isapprox(c, BigFloat("7", precision=prec), atol=atol)
    @test_throws DomainError dim!(c, BigFloat("27"), BigFloat(NaN))

    mul_2!(c, BigFloat("3", precision=prec), UInt32(2))
    @test isapprox(c, BigFloat("12", precision=prec), atol=atol)
    mul_2!(c, BigFloat("3", precision=prec), Int32(2))
    @test isapprox(c, BigFloat("12", precision=prec), atol=atol)

    div_2!(c, BigFloat("12", precision=prec), UInt32(2))
    @test isapprox(c, BigFloat("3", precision=prec), atol=atol)
    div_2!(c, BigFloat("12", precision=prec), Int32(2))
    @test isapprox(c, BigFloat("3", precision=prec), atol=atol)
end


@testset "comparison" begin
    @test cmp_2exp(BigFloat("8"), UInt32(2), 4) < 0
    @test cmp_2exp(BigFloat("8"), Int32(2), 2) == 0

    @test number_p(BigFloat(3))

    @test !regular_p(BigFloat(NaN))

    @test unordered_p(BigFloat(3.0), BigFloat(NaN))
end


@testset "special functions" begin
    prec, atol = 512, 1e-100
    c, d = BigFloat(precision=prec), BigFloat(precision=prec)

    log!(c, BigFloat(ℯ, precision=prec))
    @test isapprox(c, BigFloat("1.0", precision=prec), atol=atol)

    y0!(c, BigFloat("1.0", precision=64))
    @test isapprox(c, BigFloat("0.088256964215676957"), atol=1e-15)

    y1!(c, BigFloat("1.0", precision=64))
    @test isapprox(c, BigFloat("-0.781212821300288716"), atol=1e-15)

    @test isapprox(j0!(c, BigFloat("1.0", precision=prec)),
                   jn!(d, Int32(0), BigFloat("1.0", precision=prec)), atol=atol)

    @test isapprox(y0!(c, BigFloat("1.0", precision=prec)),
                   yn!(d, Int32(0), BigFloat("1.0", precision=prec)), atol=atol)

    fma!(c, BigFloat("3", precision=prec), BigFloat("2", precision=prec),
         BigFloat("1", precision=prec))
    @test isapprox(c, BigFloat("7", precision=prec), atol=atol)

    hypot!(c, BigFloat("3", precision=prec), BigFloat("4", precision=prec))
    @test isapprox(c, BigFloat("5", precision=prec), atol=atol)
end


@testset "integer and reminder functions" begin
    prec, atol = 512, 1e-100
    c, d = BigFloat(precision=prec), BigFloat(precision=prec)

    ceil!(c, BigFloat("3.4", precision=prec))
    @test isapprox(c, BigFloat("4.0", precision=prec), atol=atol)

    floor!(c, BigFloat("3.4", precision=prec))
    @test isapprox(c, BigFloat("3.0", precision=prec), atol=atol)

    round!(c, BigFloat("3.4", precision=prec))
    @test isapprox(c, BigFloat(3.0, precision=prec), atol=atol)

    roundeven!(c, BigFloat(3.4, precision=prec))
    @test isapprox(c, BigFloat(3.0, precision=prec), atol=atol)

    rint!(c, BigFloat("3.4", precision=prec), Base.MPFR.MPFRRoundUp)
    @test isapprox(c, BigFloat("4.0", precision=prec), atol=atol)

    frac!(c, BigFloat("3.4", precision=prec), Base.MPFR.MPFRRoundUp)
    @test isapprox(c, BigFloat("0.4", precision=prec), atol=atol)

    modf!(c, d, BigFloat("3.4", precision=prec), Base.MPFR.MPFRRoundUp)
    @test isapprox(c, BigFloat("3.0", precision=prec), atol=atol)
    @test isapprox(d, BigFloat("0.4", precision=prec), atol=atol)

    @test integer_p(BigFloat("4.0"))
end
