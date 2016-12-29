defmodule ProcessTest do
    use ExUnit.Case

    test "can construct the process tree" do
        root = GameSuper.start_link([GameMacros])
    end
end