defmodule FeatureTests do
    use ExUnit.Case

    test "action building" do
        defmodule Test do
            use Features

            build_action(:foo, :bar, :goo) do
                reply(:works)
            end

            build_action(:other, :bar, :goo) do
                reply(:also_works)
            end
        end

        {:reply, :works, _} = Test.handle_call({:foo, :bar, :goo}, self, %{}) 
        {:reply, :also_works, _} = Test.handle_call({:other, :bar, :goo}, self, %{}) 
    end
    
    test "actual action" do
        defmodule Test do
            use Features

            @current_feature {:foo, :bar}
            action(:goo) do
                reply(:works)
            end
            action(:doo) do
                reply(:also_works)
            end
        end

        {:reply, :works, _} = Test.handle_call({:foo, :bar, :goo}, self, %{})
        {:reply, :also_works, _} = Test.handle_call({:foo, :bar, :doo}, self, %{})
    end

    test "A feature with one action" do
        defmodule Test do
            use Features

            feature :door, :N, "an exit to the north" do
                action :use do
                    reply({:move, Test})
                end
            end
        end
        {:reply, {:move, Test}, _} = Test.handle_call({:door, :N, :use}, self, %{})
    end

    test "A feature with multiple actions" do
        defmodule Test do
            use Features

            feature :door, :N, "an exit to the north" do
                action :use do
                    reply({:move, Test})
                end
                action :examine do
                    reply({:see, "It's red."})
                end
            end
        end
        {:reply, {:move, Test}, _} = Test.handle_call({:door, :N, :use}, self, %{})
        {:reply, {:see, "It's red."}, _} = Test.handle_call({:door, :N, :examine}, self, %{})
    end

    test "A feature with initialization" do
        defmodule Test do
            use Features

            feature :door, :N, "an exit to the north" do
                Features.setup do
                    IO.puts("Initializing…")
                    set_state(:state, :closed)
                end
            end
        end
        
        res = Test.init_features(%{})
        %{:state => :closed} = Map.get(res, {:features, :door, :N})
    end

    test "Checking a feature's state'" do
        defmodule Test do
            use Features

            feature :door, :N, "an exit to the north" do
                Features.setup do
                    set_state(:state, :closed)
                end
                action :examine do
                    state = get_state(:state)
                    case state do
                        :closed -> reply({:see, "It's closed."})
                        :open -> reply({:see, "It's open."})
                    end
                end
            end
        end
        
        state = Test.init_features(%{})
        %{:state => :closed} = Map.get(state, {:features, :door, :N})
        {:reply, {:see, "It's closed."}, next} = Test.handle_call({:door, :N, :examine}, self(), state)
    end
    
end