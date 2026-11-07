using DataFrames

function Threshold_Calc(V ::Vector)
    #keeping one of each element
    V = sort(unique(V))
    #preparing the threshold
    T = Float64[]
    #calculating the midpoint and adding it to our threshold
    for i in 1:(length(V)-1)
        ti = (V[i]+V[i+1])/2
        push!(T,ti)
    end
    return T
end