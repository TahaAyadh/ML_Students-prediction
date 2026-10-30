using DataFrames,CSV
file=joinpath(@__DIR__, "..", "Data", "student-mat.csv")
df = CSV.read(file, DataFrame; delim=';')
first(df, 5)