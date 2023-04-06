using Plots


plot(0:23, 0.005*sum(W_IM1[:,s] for s=1:200), label="One Price")
plot!(0:23, 0.005(sum(W_IM2[:,s] for s=1:200)), label="Two Price")
xlabel!("Time [h]")
xaxis!([0,3,6,9,12,15,18,21,23])
ylabel!("Real Time Wind Imbalance [MW]")
savefig("Results/Balancing.png")


plot(1:24, W_DA1, label="One Price")
plot!(1:24, W_DA2, label="Two Price")
plot!(1:24, sum(f_WP1[:,s] for s=1:200)*0.005, label="Real Time",legend=(0.62,0.95))
xlabel!("Time [h]")
xaxis!([0,3,6,9,12,15,18,21,23])
ylabel!("Wind Power [MW]")
plot!(legendfont=Plots.font(6))
savefig("Results/DayAhead.png")


B = [0, 0.2, 0.5, 0.8, 1, 1.3, 1.5, 1.8, 2.2]

#R1 = [353992.0, 353913.0, 353876.0, 353450.0, 353252.0, 353173.0, 352750.0, 351915.0, 351777.0]./10
#CV1 = [56588.0, 79308.0, 79402.0, 80060.0, 80274.0, 80340.0, 80664.0, 81150.0, 81215.0]
EP1 = [ 353913.0, 353876.0, 353450.0, 353252.0, 353173.0, 352750.0, 351915.0, 351777.0]
CV1 = [ 79308.0, 79402.0, 80060.0, 80274.0, 80340.0, 80664.0, 81150.0, 81215.0]
VAR1 = [56588.0, 98260.0, 98336.0, 99614.0, 99232.0, 97258.0, 101352.0,102260.0]
scatter(CV1,EP1)
scatter!(legend=false)
xlabel!("CVaR [€]")
ylabel!("Expected Profit [€]")
savefig("Results/CVaR1.png")


EP2 = [329468.0, 329439.0, 329346.0, 328893.0, 328809.0, 328798.0, 328733.0, 328616.0]
CV2 = [73108.0, 73195.0, 73383.0, 73929.0, 74005.0, 74014.0, 74055.0, 74111.0]
VAR2 = [90382.0, 92837.0, 91442.0, 93524.0, 94336.0, 94423.0, 94927.0, 95270.0]
scatter(CV2,EP2,color=:red)
scatter!(legend=false)
xlabel!("CVaR [€]")
ylabel!("Expected Profit [€]")
savefig("Results/CVaR2.png")


plot(1:24, W_DA14, label="One Price")
plot!(1:24, W_DA24, label="Two Price")