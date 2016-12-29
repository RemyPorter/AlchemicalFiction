defmodule Actor do
    use GenServer

    def start_link(name, spawn_point) do
        GenServer.start_link(__MODULE__, {%{name: name}, spawn_point}, [])
    end

    def init({%{name: name}, spawn_point}) do
        {:ok, {%{name: name, inventory: []}, spawn_point}}
    end

    def handle_call({:move, next_room}, _sender, {state, _}) do
        {:reply, {:moved, next_room}, {state, next_room}}
    end

    def handle_call({:see, message}, _sender, {state, room}) do
        {:reply, :saw, {state, room}}
    end

    def handle_call({:take, object}, _sender, {state, room}) do
        {:reply, :took, {state, room}}
    end
end