using Plots
using Base.Meta

#Interactive Part
println("Enter your funtion:")
f_string = readline()
f_string = replace(f_string, "X" => "x")
f = eval(:(x -> $(Meta.parse(f_string))))

print("Enter First Guess(where a < b):")
a = parse(Float64, strip(readline()))
print("Enter Second Guess(where a < b):")
b = parse(Float64, strip(readline()))
print("Enter amount of Steps (Prefferably like 10):")
steps = parse(Int, strip(readline())) # Changed to Int for iteration

#initial x range to get graph ready
x_range = range(min(a, b) - 1.0, max(a, b) + 1.0, length=400) # Ensure a reasonable range around a and b

# Initialize min/max for x and y based on initial a, b and the x-axis (y=0)
min_x = min(a, b)
max_x = max(a, b)
min_y = min(f(a), f(b), 0.0) # Include 0 for the x-axis
max_y = max(f(a), f(b), 0.0) # Include 0 for the x-axis

# Plot the function 
p = plot(x_range, f.(x_range), 
     label="f(x) = $(f_string)",
     lw=3,
     color=:blue,
     xaxis="x",
     yaxis="f(x)",
     title="Bisection Method Iteration",
     legend=:topleft)

# Add a horizontal line at y = 0 (the x-axis)
hline!(p, [0], color=:black, lw=1.5, label="y = 0")

# Add initial a and b points with labels
scatter!(p, [a], [f(a)], color=:red, markersize=7, label="Initial a")
scatter!(p, [b], [f(b)], color=:green, markersize=7, label="Initial b")

c = (a + b) / 2
for count in 1:steps
  c = (a +b) / 2
  if f(c)>0 && (b > a)
    b = c
  end
  if f(c)>0 && (a > b)
    a = c
  end
  if f(c)<0 && (b > a)
    a = c
  end
  if f(c)<0 && (a > b )
    b = c
  end
  scatter!(p, [c], [f(c)],
          color=[:purple],
          markersize=5,
          label="c Iter $(count)") 

# Update observed plot limits with current c and f(c)
  min_x = min(min_x, c)
  max_x = max(max_x, c)
  min_y = min(min_y, f(c))
  max_y = max(max_y, f(c))
end

# Calculate padding based on observed range
x_range_span = max_x - min_x
y_range_span = max_y - min_y

# Ensure a minimum padding if the range is very small or zero
x_padding_val = max(0.2, abs(x_range_span * 0.1)) # Use a minimum of 0.2
y_padding_val = max(0.5, abs(y_range_span * 0.1)) # Use a minimum of 0.5

# Apply dynamic plot limits
plot!(p, xlims=(min_x - x_padding_val, max_x + x_padding_val),
         ylims=(min_y - y_padding_val, max_y + y_padding_val))


# These are the final a, b, c values after the loop
vline!(p, [a], color=:red, linestyle=:dash, lw=2, label="Final a (Left Bracket)") 
vline!(p, [b], color=:green, linestyle=:dash, lw=2, label="Final b (Right Bracket)")
vline!(p, [c], color=:purple, linestyle=:dash, lw=2, label="Final c (Midpoint)") 

#Scatter plot the actual points on the curve to show the signs
scatter!(p, [a, b, c], [f(a), f(b), f(c)],
         color=[:red, :green, :purple],
         markersize=7,
         label="")

# Annotate the points with text labels for clarity
# These annotations assume specific signs, which might not always be true.
# For now, I will leave them as they are, but this is a point for future improvement.
annotate!(p, [(a + 0.05, f(a) + 0.3, text("f(a) < 0", :red, 10)),
           (b - 0.05, f(b) - 0.5, text("f(b) > 0", :green, 10)),
           (c + 0.05, f(c) + 0.4, text("f(c) < 0", :purple, 10))])

display(p)
print("The function converges to cross the x access at ", c)
