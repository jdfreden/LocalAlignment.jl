module LocalAlignment

using DelimitedFiles

include("scoring.jl")
include("traceback.jl")
include("helper.jl")
include("alignment.jl")

export parse_file, alignment
end # module
