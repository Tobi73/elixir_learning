defmodule TestProject.Storage do
    use Agent, restart: :temporary

    def start_link(_opts) do
        Agent.start_link(fn -> %{} end)
    end

    def get(storage, key) do
        Agent.get(storage, &Map.get(&1, key))
    end

    def put(storage, key, value) do
        Agent.update(storage, &Map.put(&1, key, value))
    end

    def delete(storage, key) do
        Agent.get_and_update(storage, &Map.pop(&1, key))
    end
end