using JuMP
using Gurobi

include("Data1.jl")


#Model
S14_TwoPrice = Model(Gurobi.Optimizer)

#Consider only 200 scenarios
S = 200
PI = [1/S for i=1:S]

B = 1 #risk adversity (beta)
A = 0.9 #Confidence level (alpha)

#Variables
@variable(S14_TwoPrice, w_da[h=1:H] >= 0) #day ahead hourly bidded production
@variable(S14_TwoPrice, w_im[h=1:H,s=1:S])
@variable(S14_TwoPrice, w_up[h=1:H,s=1:S] >= 0)
@variable(S14_TwoPrice, w_dw[h=1:H,s=1:S] >= 0)

@variable(S14_TwoPrice, n[s=1:S] >= 0) #auxilliary variable
@variable(S14_TwoPrice, VAR) #value at risk

@variable(S14_TwoPrice, EP[s=1:S]) #expected profit


#Objective function One Price Scheme
@objective(S14_TwoPrice, Max, 
            sum( sum(PI[s]
            * ((f_DA1[h,s] * w_da[h]) 
            + f_SB1[h,s] * ( (0.9 * f_DA1[h,s] * w_up[h,s]) - (f_DA1[h,s] * w_dw[h,s])  ) #active when the system has power excess
            + abs((f_SB1[h,s]-1)) * ( (f_DA1[h,s] * w_up[h,s]) - (1.2 * f_DA1[h,s] * w_dw[h,s]) ) #active when the system has power deficit
            ) 
            for s=1:S) for h=1:H)
            + B * (VAR - 1/(1-A) * sum(PI[s] * n[s] for s=1:S)) #CVaR
            )

#Constraints
@constraint(S14_TwoPrice, [h=1:H], 0 <= w_da[h] <= W_Cap) #capacity constraint for the wind farm
@constraint(S14_TwoPrice, [h=1:H,s=1:S], w_im[h,s] == f_WP1[h,s] - w_da[h] ) #real time imbalance
@constraint(S14_TwoPrice, [h=1:H,s=1:S], w_im[h,s] == w_up[h,s] - w_dw[h,s] ) #excess and deficit imbalance equal the real time imbalance

@constraint(S14_TwoPrice, [s=1:S], n[s] >= 0)
@constraint(S14_TwoPrice, [s=1:S], VAR - EP[s] - n[s] <= 0)

#not necessary for the model but used for the outputs
@constraint(S14_TwoPrice, [s=1:S],  sum(((f_DA1[h,s] * w_da[h]) 
                                    + f_SB1[h,s] * ( + (0.9 * f_DA1[h,s] * w_up[h,s]) - ( f_DA1[h,s] * w_dw[h,s]) ) 
                                    + abs((f_SB1[h,s]-1)) * ( ( f_DA1[h,s] * w_up[h,s]) - (1.2 * f_DA1[h,s] * w_dw[h,s]) ) #active when the system has power deficit  
                                    for h=1:H)) == EP[s])

#Solve
Solution = optimize!(S14_TwoPrice)

println("Risk adversity: $B")
println("Expected Profit under the One Price scheme: $(round(sum(value.(EP[s])*PI[s] for s=1:S)))€")
CVaR = value.(VAR - 1/(1-A) * sum(PI[s] * n[s] for s=1:S))
println("CVaR: $(round(CVaR))€")
println("Value at Risk: $(round(value.(VAR)))€")

#=
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
=#