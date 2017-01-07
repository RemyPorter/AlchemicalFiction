defmodule ProcessTest do
    use ExUnit.Case

    setup_all do
        {:ok, pid} = ScenesRegistry.start_link(GameMacros)
        {:ok, [pid: pid]}
    end

    #a basic sanity test for my process tree
    test "can send a message to a scene" do
        name = {:via, Registry, {Registry.GameMacros, GameMacros.ASimpleScene}}
        GenServer.call(name,
            {:door, :simple, :use})
    end
end