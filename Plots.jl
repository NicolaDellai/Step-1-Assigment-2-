using Plots
using Cairo

z = zeros(200)
plot(0:23, 0.005*sum(W_IM1[:,s] for s=1:200), label="One Price",dpi=800)
plot!(0:23, 0.005(sum(W_IM2[:,s] for s=1:200)), label="Two Price",dpi=800)
plot!(0:23,z, line=:dot, color=:black,dpi=800,primary=false)
xlabel!("Time [h]")
xaxis!([0,3,6,9,12,15,18,21,23])
ylabel!("Real Time Wind Imbalance [MW]")
savefig("Results/Balancing.png")


plot(1:24, W_DA1, label="One Price",dpi=800)
plot!(1:24, W_DA2, label="Two Price",dpi=800)
plot!(1:24, sum(f_WP1[:,s] for s=1:200)*0.005, label="Real Time",legend=(0.52,0.8),dpi=800)
xlabel!("Time [h]")
xaxis!([0,3,6,9,12,15,18,21,23])
ylabel!("Wind Power [MW]")
plot!(legendfont=Plots.font(8))
savefig("Results/DayAhead.png")

B = [0.1, 0.5, 0.8, 1, 1.3, 1.5, 2, 5, 10]

EP1 = [ 353913.0, 353876.0, 353450.0, 353252.0, 353173.0, 352750.0, 351915.0, 351777.0, 351575.0]
CV1 = [ 79308.0, 79402.0, 80060.0, 80274.0, 80340.0, 80664.0, 81150.0, 81215.0, 81243.0]
VAR1 = [ 98260.0, 98336.0, 97525.0, 99614.0, 99232.0, 97258.0, 101352.0, 102260.0, 103438.0]
plot(CV1,EP1,color=:red,xlabel="CVaR [€]", ylabel="Expected Profit [€]",markershape=:circle, linewidth=1, line=:dot, label="One Price Scheme",dpi=800)
#plot!(twinx(),CV1, VAR1, color=:orange, ylabel="Value at Risk [€]", y_foreground_color_text=:orange,y_guidefontcolor=:orange, markershape=:x, line=:dot, linewidth=1)
savefig("Results/CVaR1.png")


EP2 = [329479.0, 329394.0, 329152.0, 328893.0, 328809.0, 328798.0, 328733.0, 327584.0, 327295.0]
CV2 = [73016.0, 73295.0, 73644.0, 73929.0, 74005.0, 74014.0, 74055.0, 74462.0,  74509.0]
VAR2 = [90057.0, 91406.0, 92509.0, 93524.0, 94336.0, 94423.0, 94927.0, 96973.0, 96978.0]
plot(CV2,EP2,color=:blue,xlabel="CVaR [€]", ylabel="Expected Profit [€]",markershape=:circle, linewidth=1, label="Two Price Scheme", line=:dot,dpi=800)
#plot!(twinx(),CV2, VAR2, color=:red, ylabel="Value at Risk [€]", y_foreground_color_text=:red,y_guidefontcolor=:red, markershape=:x, line=:dot, linewidth=1)
savefig("Results/CVaR2.png")

