defmodule Story do
    use Features

    defmacro __using__(_opts) do
        quote do
            import unquote(__MODULE__)
            Module.register_attribute(__MODULE__, :scenes, accumulate: true, persist: true)

            @before_compile unquote(__MODULE__)
        end
    end

    defmacro __before_compile__(_env) do
        quote do
            def scenes(), do: @scenes
        end
    end

    defmacro spawn_point(scene) do
        quote do
            def spawn_point, do: unquote(scene)
        end
    end

    defmacro state(key) do
        quote do
            Map.get(var!(state), unquote(key))
        end
    end

    defmacro state(key, value) do
        quote do
            var!(state) = Map.put(var!(state), 
                unquote(key), 
                unquote(value))
        end
    end

    defmacro scene(title, description) do
        quote do
            scene unquote(title), unquote(description) do
                
            end
        end
    end

    defmacro scene(title, description, do: block) do
        quote do
            @scenes unquote(title)
            defmodule unquote(title) do
                use GenServer

                Module.register_attribute(__MODULE__, :features, [])
                @features %{}

                def start_link() do
                    GenServer.start_link({:global, __MODULE__}, nil, [])
                end

                def init(nil) do
                    {:ok, %{}}
                end
                
                unquote(block)

                def handle_call(:details, _from, state) do
                    {:reply, {
                        unquote(title), unquote(description),
                        state
                    }}
                end

                for type <- Map.keys(@features) do
                    render_feature(type, Map.get(@features, type))
                end
            end
        end
    end   
end