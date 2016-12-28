defmodule BasicElements do
    import Features

    defmacro __using__(_opts) do
        quote do
            import unquote(__MODULE__)
        end
    end

    defmacro door(symbol, title, destination) do
        quote do
            feature_type(:door)
            feature_activation(:door, unquote(symbol), unquote(destination)) do
                #move actor to destination
                #update current state
                {unquote(destination), var!(state)}
            end
            add_feature(:door, {
                :"#{unquote(symbol)}",
                unquote(title),
                "Move to #{unquote(destination)}",
                :"act_door_#{unquote(symbol)}"
            })
        end
    end
end