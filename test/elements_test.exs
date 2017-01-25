defmodule TestElements do
    use ExUnit.Case

    defmodule Test do
        use Features
        use BasicElements

        choice :page52, "Turn to page 52", Test

        switch :lights, "a lamp"
    end

    test "can make a choice" do
        {:reply, {:move, Test}, _} = Test.handle_call({{:choice, :page52, :choose}, nil}, nil, %{})
    end

    test "can flip a switch" do
        state = Test.init_features(%{})
        {:reply, :toggled, new_state} = Test.handle_call({{:switch, :lights, :toggle}, nil}, nil, state)
        %{{:features, :switch, :lights} => %{state: true}} = new_state
    end
end