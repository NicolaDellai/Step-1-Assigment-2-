using Distributions
using Plots
using StatsBase


W_IM = zeros(24,400)
ep24 = zeros(24,400)
EP24_out = zeros(400)
for s=1:400
    for h=1:24
        W_IM[h,s] = f_WP2[h,s] - W_DA24[h]
        if W_IM[h,s] >= 0
        ep24[h,s] =  f_DA2[h,s] * W_DA24[h] 
                    + f_SB2[h,s] * (0.9 * f_DA2[h,s] * W_IM[h,s])
                    + abs((f_SB2[h,s]-1)) * (1.2 * f_DA2[h,s] * W_IM[h,s]) 
                    
        else 
        ep24[h,s] = f_DA2[h,s] * W_DA24[h] 
                    - f_SB2[h,s] * (0.9 * f_DA2[h,s] * W_IM[h,s])
                    - abs((f_SB2[h,s]-1)) * (1.2 * f_DA2[h,s] * W_IM[h,s]) 
        end
    end
    EP24_out[s] = sum(ep24[h,s] for h=1:24)
end

EP24_out_avg = sum(EP24_out)/length(EP24_out)





# Input data
profits = ExpPr24
profits_out = EP24_out

#Determine number of intervals using the Freedman-Diaconis rule
nbins = Int64(ceil(length(profits)^(1/3) * (maximum(profits) - minimum(profits)) / (2 * iqr(profits))))
# Define range of values for profit axis and divide into intervals
min_profit = minimum(profits)
max_profit = maximum(profits)
interval_width = (max_profit - min_profit) / nbins
profit_range = range(min_profit, max_profit, length=nbins+1)
# Calculate expected value, variance, and standard deviation
expected_value = mean(profits)
variance = var(profits)
standard_deviation = std(profits)
# Calculate probabilities for each interval
probabilities_by_interval = pdf.(Normal(expected_value, standard_deviation), profit_range) * interval_width
plot(profit_range, probabilities_by_interval,label="In Sample")

#Determine number of intervals using the Freedman-Diaconis rule
nbins_out = Int64(ceil(length(profits_out)^(1/3) * (maximum(profits_out) - minimum(profits_out)) / (2 * iqr(profits_out))))
# Define range of values for profit axis and divide into intervals
min_profit_out = minimum(profits_out)
max_profit_out = maximum(profits_out)
interval_width_out = (max_profit_out - min_profit_out) / nbins_out
profit_range_out = range(min_profit_out, max_profit_out, length=nbins_out+1)
# Calculate expected value, variance, and standard deviation
expected_value_out = mean(profits_out)
variance_out = var(profits_out)
standard_deviation_out = std(profits_out)
# Calculate probabilities for each interval
probabilities_by_interval_out = pdf.(Normal(expected_value_out, standard_deviation_out), profit_range_out) * interval_width_out
# Plot histogram of probabilities
plot!(profit_range_out, probabilities_by_interval_out, xlabel="Expected Profit [€]", ylabel="Probability", label="Out of Sample")
savefig("Results/1_4_5_TwoPrice.png")


