defmodule Features do
    defmacro __using__(_opts) do
        quote do
            import unquote(__MODULE__)
            Module.register_attribute(__MODULE__, :features, accumulate: false)
            @features %{}
            @before_compile {unquote(__MODULE__), :__before_feature__}
        end
    end

    defmacro __before_feature__(_env) do
        quote do
            def features(), do: @features
        end
    end

    defmacro feature(type, id, caption, do: block) do
        quote do
            Module.register_attribute(__MODULE__, :current_feature, [])
            @current_feature {unquote(type), unquote(id)}
            @features Map.put(@features, @current_feature, [])
            def feature({unquote(type), unquote(id)}) do
                unquote(caption)
            end
            unquote(block)
        end
    end

    defmacro action(verb, do: block) do
        quote do
            actions = Map.get(@features, @current_feature)
            {type, id} = @current_feature
            @features Map.put(@features, @current_feature, [
                {type, id, unquote(verb)} | actions])
            IO.puts("#{inspect(@current_feature)}, #{unquote(verb)}")
            make_action(type, id, unquote(verb), do: unquote(block))
        end
    end

    defmacro make_action(type, id, verb, do: block) do
        quote do
            def handle_call({unquote(type), unquote(id), unquote(verb)}, actor, state) do
                var!(feature_state) = Map.get(state, 
                    {:features, unquote(type), unquote(id)})
                var!(actor_state) = nil #TODO: Actor.get_state(actor)
                var!(actor) = actor
                {feature_new, reply_state} = unquote(block)
                new_state = Map.put(state, {:features, unquote(type), unquote(id)}, feature_new)
                {:reply, reply_state, new_state}
            end
        end
    end
end