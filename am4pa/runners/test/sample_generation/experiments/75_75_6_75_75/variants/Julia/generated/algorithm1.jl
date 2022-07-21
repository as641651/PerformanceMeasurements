using LinearAlgebra.BLAS
using LinearAlgebra

"""
    algorithm1(ml0::Array{Float64,2}, ml1::Array{Float64,2}, ml2::Array{Float64,2}, ml3::Array{Float64,2})

Compute
Y = (A B C D).

Requires at least Julia v1.0.

# Arguments
- `ml0::Array{Float64,2}`: Matrix A of size 75 x 75 with property Non-singular.
- `ml1::Array{Float64,2}`: Matrix B of size 75 x 6 with property FullRank.
- `ml2::Array{Float64,2}`: Matrix C of size 6 x 75 with property FullRank.
- `ml3::Array{Float64,2}`: Matrix D of size 75 x 75 with property Non-singular.
"""                    
function algorithm1(ml0::Array{Float64,2}, ml1::Array{Float64,2}, ml2::Array{Float64,2}, ml3::Array{Float64,2})
    # cost: 2.02e+05 FLOPs
    # A: ml0, full, B: ml1, full, C: ml2, full, D: ml3, full
    ml4 = Array{Float64}(undef, 75, 6)
    # tmp1 = (A B)
    gemm!('N', 'N', 1.0, ml0, ml1, 0.0, ml4)

    # C: ml2, full, D: ml3, full, tmp1: ml4, full
    ml5 = Array{Float64}(undef, 6, 75)
    # tmp3 = (C D)
    gemm!('N', 'N', 1.0, ml2, ml3, 0.0, ml5)

    # tmp1: ml4, full, tmp3: ml5, full
    ml6 = Array{Float64}(undef, 75, 75)
    # tmp6 = (tmp1 tmp3)
    gemm!('N', 'N', 1.0, ml4, ml5, 0.0, ml6)

    # tmp6: ml6, full
    # Y = tmp6
    return (ml6)
end