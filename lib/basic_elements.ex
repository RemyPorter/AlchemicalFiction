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

    defmacro switch(tag, caption) do
        quote do
            switch(unquote(tag), unquote(caption), {"turn it on", "turn it off"})
        end
    end

    defmacro switch(tag, caption, {turn_on, turn_off}) do
        quote do
            switch(unquote(tag), unquote(caption), {true, false}, 
                {unquote(turn_on), unquote(turn_off)})
        end
    end

    defmacro switch(tag, caption, {on,off}, {turn_on, turn_off}) do
        quote do
            feature :switch, unquote(tag), unquote(caption) do
                Features.setup do
                    set_state(:state, unquote(off))
                end
                action :toggle do
                    next = case get_state(:state) do
                        unquote(on) -> unquote(off)
                        unquote(off) -> unquote(on)
                    end
                    set_state(:state, next)
                    reply(:toggled)
                end
                action :examine do
                    res = case get_state(:state) do
                        unquote(on) -> unquote(turn_off)
                        unquote(off) -> unquote(turn_on)
                    end
                end
            end
        end
    end
end