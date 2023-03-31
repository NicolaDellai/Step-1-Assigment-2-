using JuMP
using Gurobi

include("Data1.jl")


#Model
S1_OnePrice = Model(Gurobi.Optimizer)

#Consider only the first 200 scenarios
S = 200
PI = [1/S for i=1:S]

#Variables
@variable(S1_OnePrice, w_da[h=1:H] >= 0)
@variable(S1_OnePrice, w_up[h=1:H,s=1:S] >= 0) #upward change in wind production
@variable(S1_OnePrice, w_dw[h=1:H,s=1:S] >= 0) #downward change in wind production
@variable(S1_OnePrice, im[h=1:H,s=1:S]) #change in wind power production in hour h and scenario s


#Objective function One Price Scheme
@objective(S1_OnePrice, Max, 
            sum( sum(PI[s]
            * ((f_DA[h,s] * w_da[h]) 
            + (0.9 * f_DA[h,s] * w_up[h,s])  
            - (1.2 * f_DA[h,s] * w_dw[h,s])) 
            for s=1:S) for h=1:H)
            )

#Constraints
@constraint(S1_OnePrice, [h=1:H], 0 <= w_da[h] <= W_Cap) # Capacity constraint for the wind farm
#@constraint(S1_OnePrice, [h=1:H,s=1:S], im[h,s] == f_WP[h,s] - w_da[h] ) #real time imbalance
@constraint(S1_OnePrice, [h=1:H,s=1:S], im[h,s] == w_up[h,s] - w_dw[h,s]) #excess and deficit imbalance equal the real time imbalance

#Solve
Solution = optimize!(S1_OnePrice)
println(Solution)

