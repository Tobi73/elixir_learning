defmodule TestProject.RegistryTest do
    use ExUnit.Case, async: true

    setup context do
        _ = start_supervised!({TestProject.Client, name: context.test})
        %{registry: context.test}
    end

    test "spawns buckets", %{registry: registry} do
        assert TestProject.Client.lookup(registry, "shopping") == :error
        
        TestProject.Client.create(registry, "shopping")
        assert {:ok, storage} = TestProject.Client.lookup(registry, "shopping")

        TestProject.Storage.put(storage, "milk", 1)
        assert TestProject.Storage.get(storage, "milk") == 1
    end

    test "removes buckets on exit", %{registry: registry} do
        TestProject.Client.create(registry, "shopping")
        {:ok, storage} = TestProject.Client.lookup(registry, "shopping")
        Agent.stop(storage)
        assert TestProject.Client.lookup(registry, "shopping") == :error
    end

    test "removes bucket on crash", %{registry: registry} do
        TestProject.Client.create(registry, "shopping")

        {:ok, storage} = TestProject.Client.lookup(registry, "shopping")
        Agent.stop(storage, :shutdown)
        assert TestProject.Client.lookup(registry, "shopping") == :error
    end
end