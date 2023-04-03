using JuMP
using Gurobi

include("Data1.jl")


#Model
S1_TwoPrice = Model(Gurobi.Optimizer)

#Consider only the first 200 scenarios
S = 200
PI = [1/S for i=1:S]

#Variables
@variable(S1_TwoPrice, w_da[h=1:H] >= 0) #day ahead hourly bidded production
@variable(S1_TwoPrice, w_im[h=1:H,s=1:S])
@variable(S1_TwoPrice, w_up[h=1:H,s=1:S] >= 0)
@variable(S1_TwoPrice, w_dw[h=1:H,s=1:S] >= 0)

#Objective function One Price Scheme
@objective(S1_TwoPrice, Max, 
            sum( sum(PI[s]
            * ((f_DA1[h,s] * w_da[h]) 
            + f_SB1[h,s] * ( (0.9 * f_DA1[h,s] * w_up[h,s]) - (f_DA1[h,s] * w_dw[h,s])  ) #active when the system has power excess
            + abs((f_SB1[h,s]-1)) * ( (f_DA1[h,s] * w_up[h,s]) - (1.2 * f_DA1[h,s] * w_dw[h,s]) ) #active when the system has power deficit
            ) 
            for s=1:S) for h=1:H)
            )

#Constraints
@constraint(S1_TwoPrice, [h=1:H], 0 <= w_da[h] <= W_Cap) #capacity constraint for the wind farm
@constraint(S1_TwoPrice, [h=1:H,s=1:S], w_im[h,s] == f_WP1[h,s] - w_da[h] ) #real time imbalance
@constraint(S1_TwoPrice, [h=1:H,s=1:S], w_im[h,s] == w_up[h,s] - w_dw[h,s] ) #excess and deficit imbalance equal the real time imbalance


#Solve
Solution = optimize!(S1_TwoPrice)


println("Profit under the Two Price scheme: $(round.(objective_value(S1_TwoPrice)))\$")

#Outputs
W_DA = value.(w_da[:])
W_IM = value.(w_im[:,:])
W_UP = value.(w_up[:,:])
W_DW = value.(w_dw[:,:])

println("Hourly Wind Power Production Scheduled in the Day-Ahead Market:")
for h=1:H
    println("$(h-1)-$(h): $(round.(W_DA[h], digits = 2))MW")
end
println("")
println("")

println("---------------------------------------------------------------")
println("")

println("Data of each Scenario:")

for s=1:S
    println("")
    println("Senario $s:")
    println("F_WP\tDA_WP\tIMB")
    for h=1:H
    println("$(round(f_WP1[h,s]))\t$(round(W_DA[h]))\t$(round(W_IM[h,s]))")
    end
end
