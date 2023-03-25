In lectures 8 and 9, you learn the offering strategy of price-taker renewables. Please consider a
wind farm with the nominal (installed) capacity of 150 MW. We are interested to formulate and
solve an offering strategy problem for this farm. This problem determines her participation
strategy in the day-ahead market (in terms of her hourly production quantities). Note that her
offer price is zero. We consider a time framework of 24 hours. Please also note that we discard
reserve and intra-day markets, and consider day-ahead and balancing markets only.
Sources of uncertainty: Please consider three sources of uncertainty, namely:
1. Hourly wind power production in the next day
2. Hourly day-ahead market prices in the next day
3. The power system need in the balancing stage in every hour, i.e., the system has either a
power supply deficit or excess.


We will generate scenarios to model these three sources of uncertainty. For simplicity, we
assume there is no correlation among these three sources of of uncertainty.
Scenario generation for wind power production forecast: Potential references are as
following:

Reference 1: You can get wind data from the FINGRID website (Finnish TSO) or the ELIA
website (Belgian TSO), and normalize them for a 150-MW wind farm. Although they report
“aggregate” wind data, you can assume they are data for an individual farm. The wind profile
during a day can be seen as a scenario. For example, wind profile on March 1 can be seen as
scenario 1. This profile on March 2 can be seen as the second scenario, and so on.
Reference 2: https://sites.google.com/site/datasmopf/wind-scenarios
Reference 3: https://www.renewables.ninja

Scenario generation for day-ahead price forecast: Using a similar strategy, you can
generate price scenarios for 24 hours from the Nord Pool website. For example, you can
assume the wind farm is located in DK1, and use the corresponding hourly day-ahead market
prices.

Scenario generation for the power system need (excess or deficit): You can generate a
series of 24 random binary (two-state) variables, e.g., using a bernoulli distribution, indicating in every hour of the next day, whether the system in the balancing stage will have a deficit in power supply or an excess.


Final scenarios: To model three sources of uncertainty, please consider at least 600 scenarios.
Discarding the potential correlation between these three sources of uncertainty, the total
number of scenarios is equal to the number of scenarios for uncertain source 1 times the
number of scenarios for uncertain source 2 times the number of scenarios for uncertain source
3. For example, if we consider 10 wind power scenarios, 20 day-ahead price scenarios, and 3
power system need scenarios, this results in 10*20*3 = 600 scenarios.
Out of these scenarios, we will arbitrarily select at least 200 scenarios (the so-called in-sample or
seen scenarios) and will use them in Steps 1.1 to 1.4 for decision-making, i.e., the determination
of the optimal quantity offer in the day-ahead stage. The rest of scenarios (the so-called out-of-
sample or unseen scenarios) will be used later in Steps 1.5 and 1.6 for an ex-post analysis. We
can assume all scenarios are equiprobable. In other words, in case we consider 200 in-sample
scenarios, the probability of each scenario is 0.005.