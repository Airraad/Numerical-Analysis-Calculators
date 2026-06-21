using Pkg; Pkg.add("ForwardDiff")
using Plots
using ForwardDiff 
using Base.Meta 

println("Input function (e.g. x^3 - x - 1):" )
user_str = strip(readline())
user_str = replace(user_str, "X" => "x")

# Define a global constant to hold the function 'f'
global const F_STORE = Ref{Function}()

F_STORE[] = eval(:(x -> $(Meta.parse(user_str))))

println("Enter Testing point (x_i),(e.g. 1.5)")
current_x_str = strip(readline())
current_x = eval(Meta.parse(current_x_str))
tol = 0.001

# Define f_prime to always use the current function stored in F_STORE
f_prime(x_val) = ForwardDiff.derivative(F_STORE[], x_val)

x_range = range(-2.5, 2.5, 300)

# Initialize plot before the loop
plot_obj = plot(x_range, F_STORE[].(x_range),
      label="f(x) = $(user_str)",
      color=:blue,
      linewidth=3,
      framestyle = :origin,
      grid=true,
      legend = :outertopright,
      xlims = (-3, 3),
      ylims = (-5, 5))

steps = 0
next_x = current_x + 2 * tol

#Use abs value of integers to find borders of plot
maxx_val = abs(current_x)
maxy_val = abs(F_STORE[](current_x))

while abs(next_x - current_x) > tol && steps < 30

  # Calculate the new estimate using Newton's method formula
  new_next_x = current_x - F_STORE[](current_x) / f_prime(current_x) # Use F_STORE[] here

  # Only plot detailed steps for the first 5 iterations
  if steps < 5
    # Plot the point (current_x, F_STORE[](current_x))
    scatter!(plot_obj, [current_x], [F_STORE[](current_x)], label="Iter $(steps): x_i=$(round(current_x, digits=4))", color=:green, markersize=6) # Use F_STORE[] here

    # Plot the point (new_next_x, 0) which is where the tangent crosses the x-axis
    scatter!(plot_obj, [new_next_x], [0], label="Iter $(steps): x_{i+1}=$(round(new_next_x, digits=4))", color=:red, markersize=6)

    # Plot the tangent line at current_x
    tangent_line(x_val) = F_STORE[](current_x) + f_prime(current_x) * (x_val - current_x) # Use F_STORE[] here
    plot!(plot_obj, x_range, tangent_line.(x_range), label="Tangent at $(round(current_x, digits=4))", color=:purple, linestyle=:dot, lw=2, alpha=0.5)
  end

  # Update maxx_val and maxy_val based on current and next values
  maxx_val = max(maxx_val, abs(current_x), abs(new_next_x))
  maxy_val = max(maxy_val, abs(F_STORE[](current_x)), abs(F_STORE[](new_next_x))) # Use F_STORE[] here

  current_x = new_next_x

  steps += 1
end

plot!(plot_obj, xlims=(-maxx_val-0.5, maxx_val+0.5), ylims=(-maxy_val-5.5, maxy_val+5.5), legend=:outertopright)
println("Newton's method finished in $(steps) steps. Approximate root found at x = $(current_x)")
plot_obj
