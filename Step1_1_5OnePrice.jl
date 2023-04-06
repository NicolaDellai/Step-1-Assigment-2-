using Distributions
using Plots
using StatsBase


W_IM = zeros(24,400)
ep1 = zeros(24,400)
EP1_out = zeros(400)
for s=1:400
    for h=1:24
        W_IM[h,s] = f_WP2[h,s] - W_DA1[h]
        if W_IM[h,s] >= 0
        ep1[h,s] =  f_DA2[h,s] * W_DA1[h] 
                    + f_SB2[h,s] * (0.9 * f_DA2[h,s] * W_IM[h,s])
                    + abs((f_SB2[h,s]-1)) * (1.2 * f_DA2[h,s] * W_IM[h,s]) 
                    
        else 
        ep1[h,s] = f_DA2[h,s] * W_DA1[h] 
                    - f_SB2[h,s] * (0.9 * f_DA2[h,s] * W_IM[h,s])
                    - abs((f_SB2[h,s]-1)) * (1.2 * f_DA2[h,s] * W_IM[h,s]) 
        end
    end
    EP1_out[s] = sum(ep1[h,s] for h=1:24)
end

EP1_out_avg = sum(EP1_out)/length(EP1_out)





# Input data
profits = ExpPr1
profits_out = EP1_out

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
plot!(profit_range_out, probabilities_by_interval_out, xlabel="Profit", ylabel="Probability", label="Out of Sample")
#savefig("Results/1_1_5_OnePrice.png")


