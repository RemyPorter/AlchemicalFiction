defmodule BasicElements do

    defmacro __using__(_opts) do
        quote do
            import unquote(__MODULE__)
        end
    end

    defmacro choice(tag, caption, destination) do
        quote do
            feature :choice, unquote(tag), unquote(caption) do
                action :choose do
                    reply({:move, unquote(destination)})
                end
            end
        end
    end
end