using JuMP
using Gurobi

include("Data1.jl")


@variable(S1_OnePrice, p_DA[h=1:24] >= 0)
@variable(S1_OnePrice, I[h=1:24,w=1:200])


@objective(S1_OnePrice, sum(sum(p[w] * (DA[h,d]*p_DA[h] + 0.9))))

