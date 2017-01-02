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

    defmacro set_state(key, value) do
        quote do
            var!(feature_state) = Map.put(var!(feature_state), 
                unquote(key), unquote(value))
        end
    end

    defmacro get_state(key) do
        quote do
            Map.get(var!(feature_state), unquote(key))
        end
    end

    defmacro reply(message) do
        quote do
            var!(action_reply) = unquote(message)
        end
    end

    defmacro register_action(verb) do
        quote do
            actions = Map.get(@features, @current_feature)
            {type, id} = @current_feature
            @features Map.put(@features, @current_feature, [
                {type, id, unquote(verb)} | actions])
            {type, id}
        end
    end

    defmacro action(verb, do: block) do
        quote do
            v = unquote(verb)
            {type, id} = register_action(v)
            build_action(type, id, v) do
                unquote(block)
            end
        end
    end

    defmacro build_action(type, id, verb, do: block) do
        quote do
            def handle_call(
                {t, i, v} = {unquote(type), unquote(id), unquote(verb)},
                actor, state) do
                    var!(feature_state) = Map.get(state, {:features,t,i})
                    var!(action_reply) = nil
                    unquote(block)
                    new_state = Map.put(state,{:features,t,i},var!(feature_state))
                    {:reply, var!(action_reply), new_state}
                end
        end
    end
end