# app.jl
cd(@__DIR__)

try
    using MyGenie
catch _
    using Pkg
    Pkg.develop(url = "http://127.0.0.1:8000", name = "MyGenie")
    using MyGenie
end



