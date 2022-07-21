using LinearAlgebra.BLAS
using LinearAlgebra

"""
    algorithm2(ml0::Array{Float64,2}, ml1::Array{Float64,2}, ml2::Array{Float64,2}, ml3::Array{Float64,2})

Compute
Y = (A B C D).

Requires at least Julia v1.0.

# Arguments
- `ml0::Array{Float64,2}`: Matrix A of size 75 x 75 with property Non-singular.
- `ml1::Array{Float64,2}`: Matrix B of size 75 x 6 with property FullRank.
- `ml2::Array{Float64,2}`: Matrix C of size 6 x 75 with property FullRank.
- `ml3::Array{Float64,2}`: Matrix D of size 75 x 75 with property Non-singular.
"""                    
function algorithm2(ml0::Array{Float64,2}, ml1::Array{Float64,2}, ml2::Array{Float64,2}, ml3::Array{Float64,2})
    # cost: 9.79e+05 FLOPs
    # A: ml0, full, B: ml1, full, C: ml2, full, D: ml3, full
    ml4 = Array{Float64}(undef, 75, 6)
    # tmp1 = (A B)
    stime0= time()
    gemm!('N', 'N', 1.0, ml0, ml1, 0.0, ml4)

    # C: ml2, full, D: ml3, full, tmp1: ml4, full
    ml5 = Array{Float64}(undef, 75, 75)
    # tmp4 = (tmp1 C)
    stime1= time()
    gemm!('N', 'N', 1.0, ml4, ml2, 0.0, ml5)

    # D: ml3, full, tmp4: ml5, full
    ml6 = Array{Float64}(undef, 75, 75)
    # tmp6 = (tmp4 D)
    stime2= time()
    gemm!('N', 'N', 1.0, ml5, ml3, 0.0, ml6)

    # tmp6: ml6, full
    # Y = tmp6
    stime3= time()
    return (ml6) ,(stime0,stime1,stime2,stime3,)
end

function write_algorithm2_to_eventlog(io, id, stamps)
    write( io, string(id, ";", "gemm_6.75e+04;", "6.75e+04;", "tmp1 = (A B);", "gemm!('N', 'N', 1.0, ml0, ml1, 0.0, ml4);", string(stamps[1]), ";", string(stamps[2]), '
'  ))
    write( io, string(id, ";", "gemm_6.75e+04;", "6.75e+04;", "tmp4 = (tmp1 C);", "gemm!('N', 'N', 1.0, ml4, ml2, 0.0, ml5);", string(stamps[2]), ";", string(stamps[3]), '
'  ))
    write( io, string(id, ";", "gemm_8.44e+05;", "8.44e+05;", "tmp6 = (tmp4 D);", "gemm!('N', 'N', 1.0, ml5, ml3, 0.0, ml6);", string(stamps[3]), ";", string(stamps[4]), '
'  ))
end