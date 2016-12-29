defmodule GameSuper do
    use Supervisor

    def start_link(modules) do
        Supervisor.start_link(__MODULE__, modules, [])
    end

    def init(modules) do
        children = [
            worker(SceneSuper, [modules], []),
            worker(GameEngine, [modules], [])
        ]
        supervise(children, strategy: :one_for_one)
    end
end
defmodule SceneSuper do
    use Supervisor

    def start_link([], rooms) do
        Supervisor.start_link(__MODULE__, rooms, [])
    end

    def start_link([module | modules], rooms) do
        start_link(modules, module.scenes ++ rooms)
    end

    def start_link(modules) do
        start_link(modules, [])
    end

    def init(rooms) do
        children = rooms |> Enum.map(fn(r) ->
            worker(r, [], restart: :permanent)
        end)
        #children = [worker(GameEngine, [[:start_link]]) | children]
        supervise(children, strategy: :one_for_one)
    end
end
defmodule GameEngine do
    use GenServer

    def start_link(modules) when is_list(modules) do
        GenServer.start_link(__MODULE__, modules, [])
    end

    def start_link(module) do
        GameEngine.start_link([module])
    end

    def init(modules) do
        spawn = List.foldl(modules, nil, fn(m, acc) ->
            case m.spawn_point do
                nil -> acc
                point -> point
            end
        end)
        {:ok, {spawn, []}}
    end


end