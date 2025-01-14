module DMUStudent

using Nettle: hexdigest

include("Obfuscatee.jl")

export HW1,
       HW2,
       HW3,
       HW4,
       HW5,
       HW6

function hash_score(hw, email, score, key)
    return hexdigest("sha256", string(hw)*email*string(score)*key)
end

include("HW1.jl")
include("HW2.jl")
include("HW3.jl")
include("HW4.jl")
include("HW5.jl")
include("HW6.jl")

end # module
