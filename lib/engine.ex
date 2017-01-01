defmodule ScenesRegistry do
    use Supervisor
    def start_link(story_module) do
        name = Module.concat(Registry, story_module)
        sup_name = Module.concat(name, Supervision)
        Supervisor.start_link(__MODULE__, 
            {story_module, name}, 
            strategy: :one_for_one, name: {:global, sup_name})
    end

    def init({story_module, registry}) do
        sup = supervisor(Registry, [:unique, registry])

        scenes = story_module.scenes 
            |> Enum.map(fn(mod) ->
                worker(mod, [story_module], [])
            end)

        supervise([sup | scenes], strategy: :one_for_one)            
        
    end
end
