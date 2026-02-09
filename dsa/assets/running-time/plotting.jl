ENV["GKSwstype"] = "100"   # no interactive window
using Plots
gr()

# Function
f(x) = x^3

# Parameters
n = 10
k = 1:n

# Smooth curve
x_fine = range(0, n, length=800)
plot(
    x_fine, f.(x_fine),
    label = "f(x) = x³",
    linewidth = 2,
    xlabel = "x",
    ylabel = "Value",
    title = "Integral Approximation: Right Riemann Rectangles",
    xticks = 0:1:n          # <-- integer x-axis labels
)

# Right Riemann rectangles on [k-1, k]
bar!(
    k .- 0.5, f.(k),
    bar_width = 1.0,
    alpha = 0.35,
    label = "Right rectangles (∑ f(k))"
)

savefig("right_riemann_rectangles.png")
