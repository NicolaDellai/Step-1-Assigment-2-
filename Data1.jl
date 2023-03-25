using CSV
using DataFrames
using DelimitedFiles
using Random

dir = @__DIR__  # get the directory of the script that is being executed

#CHOOSE THE HOUR AT WHICH YOU WANT THE CODE TO BE EXECUTED
H = 9


#TECHNO-ECONOMIC DATA OF GENERATING UNITS
GenTechData = readdlm(joinpath(dir, "Data", "TechnicalDataOfGenUnits.txt"))
Gen_N = convert(Array{Int64}, GenTechData[2:13,2])         #Node of the generation unit
Gen_Z = convert(Array{Int64}, GenTechData[2:13,3])
Gen_Cap = convert(Array{Float64}, GenTechData[2:13,4])        #Maximum power output of generating unit i [MW]
Gen_Cost = convert(Array{Float64}, GenTechData[2:13,5])          #Day-ahead offer price of generating unit [$/MWh]



#TECHNICAL DATA OF WIND FARMS
WindTechData = readdlm(joinpath(dir, "Data", "WindFarmTechnicalData.txt"))
Wind_N = convert(Array{Int64}, WindTechData[2,2:7])             #Node of the Wind Farms
Wind_Z = convert(Array{Int64}, WindTechData[3,2:7])
Wind_Cap = convert(Array{Int64}, WindTechData[4,2:7])           #Installed capcity of the Wind Farms [MW]
#=
Genrate the random Power Factors of the 6 Wind Farms
n = length(Wind_N)
minWP = 0.4
maxWP = 0.7
PF= minWP .+ (maxWP - minWP) .* rand(n)
#PF = round.(WP, digits = 3)
=#
PF = [ 0.683 0.458 0.453 0.478 0.621 0.408 ]




#LOAD PROFILE
Demand = readdlm(joinpath(dir, "Data", "Demand.txt"))
D = convert(Array{Int64}, Demand[2:25,2])                                 #Hourly Demand

#NODE LOACTION AND DISTRIBUTION OF THE TOTAL SYSTEM DEMAND
Distribution = readdlm(joinpath(dir, "Data","NodeLocation_Distribution.txt"))
Dem_N = convert(Array{Int64}, Distribution[2:18,2])
Dem_Z = convert(Array{Int64}, Distribution[2:18,3])
ShareOfLoad = convert(Array{Float64}, Distribution[2:18,4])               #Share of the system load %


ND = zeros(length(Dem_N))
for n=1:length(Dem_N)
        ND[n] = ShareOfLoad[n]/100 * D[H]
end

#BIDDING PRICES

#Randomly generate the Bidding Prices for the demand side
#=
n = length(Dem_N)
min_BP = 20
max_BP = 2 * 35
B = min_BP .+ (max_BP - min_BP) .* rand(n)
B = round.(B, digits = 3)
=#
BP = [70.749, 56.378, 56.349, 57.394, 57.242, 54.605, 55.453, 57.653, 63.093, 69.818, 68.869, 65.662, 64.381, 66.125, 57.325, 60.387, 24.364]

println("Data are ready")