# app.jl
cd(@__DIR__)

try
    using MyGenie
catch _
    using Pkg
    Pkg.develop(url = "https://github.com/lnan22/Webapp", name = "MyGenie")
    using MyGenie
end



