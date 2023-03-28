using Random, Distributions
using XLSX

#Get the directory of the current file
dir = @__DIR__

#Day-Ahead prices and Wind production data
DAfilepath = joinpath(dir, "Data", "DAprices.xlsx")
DA = XLSX.readdata(DAfilepath,"DK2","A2:T25")                    #€/MWh
Wfilepath = joinpath(dir, "Data", "WindProduction.xlsx")
W = XLSX.readdata(Wfilepath,"Normalized","C2:L25")                        #MW

#=
Generate a series of 24 random binary (two-state) variables, e.g., using a bernoulli distribution, indicating
in every hour of the next day, whether the system in the balancing stage will have a deficit in power supply or an excess
0 = DEFICIT
1 = EXCESS

prob_deficit = 0.5
system_balance = zeros(Int, 24, 3)
for i in 1:3
    system_balance[:,i] = rand(Bernoulli(prob_deficit), 24)
end
=#

SB =[0 0 1;
     0 1 1; 
     1 0 1; 
     0 1 1; 
     1 1 0; 
     1 0 1; 
     1 0 0; 
     0 1 0; 
     1 0 1; 
     0 0 0; 
     1 0 1; 
     1 1 0; 
     1 0 1; 
     1 1 0; 
     1 1 0; 
     0 0 0; 
     1 1 0; 
     1 0 1; 
     0 1 0; 
     1 1 1; 
     1 1 0; 
     0 1 1; 
     1 0 1; 
     1 0 1]


