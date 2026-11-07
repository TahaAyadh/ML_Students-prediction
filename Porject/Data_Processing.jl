using CSV, DataFrames

function loader(filepath)
    return CSV.read(filepath, DataFrame; delim=';')
end
#