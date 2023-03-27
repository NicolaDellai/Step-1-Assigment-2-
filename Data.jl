using Random, Distributions
using XLSX

#Get the directory of the current file
dir = @__DIR__

#Day-Ahead prices and Wind production data
DAfilepath = joinpath(dir, "Data", "DAprices.xlsx")
DA = XLSX.readdata(DAfilepath,"Sheet1","A2:T25")
Wfilepath = joinpath(dir, "Data", "WindProduction.xlsx")
W = XLSX.readdata(Wfilepath,"Data","C2:L25")

#=
Generate a
series of 24 random binary (two-state) variables, e.g., using a bernoulli distribution, indicating
in every hour of the next day, whether the system in the balancing stage will have a deficit in
power supply or an excess
0 = DEFICIT
1 = EXCESS
=#

prob_deficit = 0.5
system_balance = zeros(Int, 24, 3)
for i in 1:3
    system_balance[:,i] = rand(Bernoulli(prob_deficit), 24)
end

