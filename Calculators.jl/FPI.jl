1 loading
using Base.Meta
using Printf
using Plots

#FPI algo
function FPI(x0,tol,g)
  current_x = x0
  history = Float64[x0] 
  count = 1
  converged = false 

  while true
    next_x = g(current_x)
    push!(history, next_x)
    count += 1

    # check if the step size is smaller than our tolerance.
    if abs(next_x - current_x)<tol
      converged = true
      break
    end

    if count > 100 
      converged = false
      break
    end

    current_x = next_x
  end

  return history, converged
end


#ask user for function
print("enter your iteration function f(x) (e.g., cos(x) or 1-x^3) or press Enter for default (cos(x)): ")
user_str = strip(readline())
user_str = replace(user_str, "X" => "x")

#turn string into function
g = eval(:(x -> $(Meta.parse(user_str))))

# ask user for start
print("enter your starting guess x0 (e.g., 0.5): ")
x0 = parse(Float64, readline())

#ask for tolerance
print("enter your tolerance limit (e.g., 1e-5):")
tol = parse(Float64, readline())

#execute function
history, success = FPI(x0, tol, g)

#print out solution
if success
  println("success! Fixed point found at x = ", history[end])

else
  println("executed without convergence")
end
