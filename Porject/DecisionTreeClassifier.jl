using DataFrames

function Threshold_Calc(V ::Vector)
    #keeping one of each element
    V = sort(unique(V))

    if eltype(V) <: AbstractString
        return V
    else
        #preparing the threshold
        T = Float64[]
        #calculating the midpoint and adding it to our threshold
        for i in 1:(length(V)-1)
            ti = (V[i]+V[i+1])/2
            push!(T,ti)
        end
        return T
    end
end

function SectionMake(Data::DataFrame,feature::Symbol,Threshold::Vector)
    #we check for cathegories
    if eltype(Threshold)<: AbstractString
        Output = DataFrame[]
        for ele in Threshold
            SubSection = subset(Data,feature=>ByRow(x->x==ele))
            push!(Output,SubSection)        
        end
    #we check for numerical values
    else
        Output = Tuple{DataFrame, DataFrame}[]
        for ele in Threshold
            SubSection1 = subset(Data,feature =>ByRow(x->x>=ele))    
            SubSection2 = subset(Data,feature=>ByRow(x->x<ele))
            push!(Output,(SubSection1,SubSection2))    
        end
    end
    return Output
end

#We add the previously made entropy and Information Gain functions 
function E_Calc(Sv::DataFrame)
    PL=count(Sv.Pass)
    NPL=nrow(Sv)- PL
    if (PL==0 || NPL == 0 )
        return 0
    else
        return E=  -((PL/(PL+NPL))*log2(PL/(PL+NPL)))-((NPL/(PL+NPL))*log2(NPL/(PL+NPL)))
    end
end

function IG_CalcG(H :: Float64 ,Sv :: DataFrame,S::Int64)
        return (H - ((nrow(Sv)/S)*E_Calc(Sv)))
end

#===============================================================================================#
# We create a function that will allow us to evaluate each split made
function SplitEval(Data::DataFrame, Splits)
    H = E_Calc(Data)
    S = nrow(Data)
    if eltype(Splits) <: Tuple
        Ouputs = Float64[]
        for i in eachindex(Splits)
            IG=H
            for ele in Splits[i]
                IG=IG_CalcG(IG,ele,S)
            end
            push!(Ouputs,IG)
            println(IG,"\n")
        end
         
        return (maximum(Ouputs),Splits[argmax(Ouputs)])
    else
        IG=H
        for ele in Splits
            IG=IG_CalcG(IG,ele,S)
        end
        println(IG)
        return (IG,Splits)
    end
end

function BestFits(Data::DataFrame)
    MySymbols = filter(x -> (x != :G3 ) , Symbol.(names(Data)))
    BestOf = Any[]
    for ele in MySymbols
        T=Threshold_Calc(Data[!, ele])
        Sect = SectionMake(Data,ele,T)
        push!(BestOf, SplitEval(Data,Sect))
    end     

    EV = [result[1] for result in BestOf]
    return BestOf[argmax(EV)]
end


function TreeStructure(Data::DataFrame)


end
