# src/MyGenie.jl
module MyGenie

using Stipple, Stipple.ReactiveTools
using StippleUI
using Genie

import Stipple.Pages.Page, Genie.Router.Route

function Genie.route(p::Stipple.Pages.Page)
    p in Stipple.Pages._pages || push!(Stipple.Pages._pages, p)
    route(p.route)
end

macro precompile_route(url, view, App = nothing)
    quote
        route($url) do
            page(@init($App), $view) |> html
            view_fn = $view isa Function ? html! : html
            # without  `layout = nothing` the function is not compilable
            if $App === nothing
                view_fn($view; layout = nothing, context = @__MODULE__, model = @init())
            else
                view_fn($view; layout = nothing, context = @__MODULE__, model = @init($App))
            end
        end
    end |> esc
end

@app MyApp begin
    @in x = 1
    @in y = x + 1

    @onchange x on_x()
    @onchange x, y on_x_y()
end

@handler MyApp function on_x()
    @info "x changed"
end

@handler MyApp function on_x_y()
    @info "x or y changed to $x, $y"
end

ui() = [
    row("Hello World {{ x }}, {{ y }}")

    slider(1:10, :x)
    slider(11:20, :y)
]

ui2() = htmldiv([
    row("Hello World {{ x }}, {{ y }}")

    card([
        cardsection(slider(1:10, :x))
        cardsection(slider(11:20, :y))
    ])
])

p::Page = @page("/", ui, model = MyApp)

r::Route = route("/page2") do
    view = htmldiv(ui())
    html!(ui, context = @__MODULE__, layout = DEFAULT_LAYOUT(), model = @init(MyApp))
end


function __init__()
    route(p)
    route(r)

    up(open_browser = true)
end

@stipple_precompile begin
    @precompile_route("/", ui, MyApp)
    @precompile_route("/page2", ui2, MyApp)

    precompile_get("/")
    precompile_get("/page2")
end

end # module MyGenie