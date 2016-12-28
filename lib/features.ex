defmodule Features do
    defmacro __using__(_opts) do
        quote do
            import unquote(__MODULE__)
        end
    end

    defmacro feature_type(type) do
        quote do
            if ! Map.has_key?(@features, unquote(type)) do
                @features Map.put(@features, unquote(type), [])
            end
        end
    end

    defmacro add_feature(type, details) do
        quote do
            l = Map.get(@features, unquote(type))
            @features Map.put(@features, unquote(type), [unquote(details) | l])
        end
    end

    #a feature description must consist of:
    # {symbol, title, description, activation_behavior}
    # activations will always have the actor and the state as an input
    # and should return the reply and new state

    defmacro feature_activation(feature, item, options, do: block) do
        quote do
            defp unquote(:"act_#{feature}_#{item}")(actor, state) do
                opts = unquote(options)
                var!(state) = state
                unquote(block)
            end
        end
    end

    defmacro render_feature(type, feature) do
        quote bind_quoted: [type: type,feature: feature] do
            for {msg, _, _, activation} <- feature do
                def handle_call({type, msg}, actor, state) do
                    {reply, new_state} = unquote(activation)(actor, state)
                    {:reply, reply, new_state}
                end
            end
        end
    end
end