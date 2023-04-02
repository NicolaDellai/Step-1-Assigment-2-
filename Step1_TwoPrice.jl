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
@variable(S1_TwoPrice, w_im_ex[h=1:H,s=1:S]) #change in wind power production in hour h and scenario s when the system has power excess
@variable(S1_TwoPrice, w_up_ex[h=1:H,s=1:S] >= 0) #upward change in wind production when the system has power excess
@variable(S1_TwoPrice, w_dw_ex[h=1:H,s=1:S] >= 0) #downward change in wind production when the system has power excess
@variable(S1_TwoPrice, w_im_def[h=1:H,s=1:S]) #change in wind power production in hour h and scenario s when the system has power deficit
@variable(S1_TwoPrice, w_up_def[h=1:H,s=1:S] >= 0) #upward change in wind production when the system has power deficit
@variable(S1_TwoPrice, w_dw_def[h=1:H,s=1:S] >= 0) #downward change in wind production when the system has power deficit

@variable(S1_TwoPrice, w_pos[h=1:H,s=1:S])

#Objective function One Price Scheme
@objective(S1_TwoPrice, Max, 
            sum( sum(PI[s]
            * ((f_DA[h,s] * w_da[h]) 
            + f_SB[h,s] * ( (0.9 * f_DA[h,s] * w_up_ex[h,s]) - (f_DA[h,s] * w_dw_ex[h,s])  ) #active when the system has power excess
            + abs((f_SB[h,s]-1)) * ( (f_DA[h,s] * w_up_def[h,s]) - (1.2 * f_DA[h,s] * w_dw_def[h,s]) ) #active when the system has power deficit
            ) 
            for s=1:S) for h=1:H)
            )

#Constraints
@constraint(S1_TwoPrice, [h=1:H], 0 <= w_da[h] <= W_Cap) #capacity constraint for the wind farm
@constraint(S1_TwoPrice, [h=1:H,s=1:S], w_im_ex[h,s] == f_WP[h,s] - w_da[h] ) #real time imbalance
@constraint(S1_TwoPrice, [h=1:H,s=1:S], w_im_ex[h,s] == w_up_ex[h,s] - w_dw_ex[h,s] ) #excess and deficit imbalance equal the real time imbalance
@constraint(S1_TwoPrice, [h=1:H,s=1:S], w_im_def[h,s] == f_WP[h,s] - w_da[h] ) #real time imbalance
@constraint(S1_TwoPrice, [h=1:H,s=1:S], w_im_def[h,s] == w_up_def[h,s] - w_dw_def[h,s] ) #excess and deficit imbalance equal the real time imbalance

#Solve
Solution = optimize!(S1_TwoPrice)
println(Solution)

