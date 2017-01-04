defmodule Story do
    defmacro __using__(_opts) do
        quote do
            import unquote(__MODULE__)
            Module.register_attribute(__MODULE__, :scenes, accumulate: true, persist: true)
            Module.register_attribute(__MODULE__, :title, [])
            @before_compile unquote(__MODULE__)
        end
    end

    defmacro __before_compile__(_env) do
        quote do
            def scenes() do
                @scenes |> Enum.map(fn(mod) -> Module.concat(__MODULE__, mod) end)
            end
            def title() do
                @title
            end
        end
    end

    defmacro story_title(title) do
        quote do
            @title unquote(title)
        end
    end

    defmacro actor_spawn(scene) do
        quote do
            def spawn_point, do: unquote(scene)
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
            @scenes :"#{unquote(title)}"
            defmodule unquote(title) do
                use GenServer
                use Features

                unquote(block)

                def start_link(root) do
                    name = {:via, Registry, {Module.concat(Registry, root), __MODULE__}}
                    IO.puts("#{inspect(name)}")
                    GenServer.start_link(__MODULE__, [], [name: name])
                end

                def init([]) do
                    {:ok, init_features(%{})}
                end

            end
        end
    end   
end