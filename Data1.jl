using Random, Distributions
using XLSX

#Get the directory of the current file
dir = @__DIR__


#Hours
h = ["h$i" for i =1:24]
H = length(h)
#Day-Ahead prices and Wind production data
DAfilepath = joinpath(dir, "Data", "DAprices.xlsx")
DA = XLSX.readdata(DAfilepath,"DK2","A2:T25")                    #€/MWh
DA_s = 20
DA_array = [DA[1:H, c] for c = 1:DA_s]
Wfilepath = joinpath(dir, "Data", "WindProduction.xlsx")
W_RT = XLSX.readdata(Wfilepath,"Normalized","B2:K25")             #MW
W_RT_s = 10
W_RT_array = [W_RT[1:H, c] for c = 1:W_RT_s]
W_Cap = 150 #MW

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

SB_s = 3
SB_array = [SB[1:H, c] for c = 1:SB_s]

#GENERATE THE SCENARIOS 
SC_d = Dict()
counter = 0

struct SCENARIO
    WP::Vector{Float64}
    PR::Vector{Float64}
    IM::Vector{Int64}
end

for w=1:W_RT_s
    for p=1:DA_s
        for i=1:SB_s
            global counter += 1
            SC_d[counter] = SCENARIO(W_RT_array[w], DA_array[p], SB_array[i])
        end
    end
end

S = W_RT_s*DA_s*SB_s

f_WP = zeros(H,S)
f_DA = zeros(H,S)
f_IM = zeros(H,S)

for s=1:S
    f_WP[1:H,s] = SC_d[s].WP
    f_DA[1:H,s] = SC_d[s].PR
    f_IM[1:H,s] = SC_d[s].IM
end


