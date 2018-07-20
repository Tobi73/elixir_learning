defmodule TestProject.StorageTest do
    use ExUnit.Case, async: true

    setup do
        storage = start_supervised!(TestProject.Storage)
        %{storage: storage}
    end

    test "stores value by key", %{storage: storage} do
        assert TestProject.Storage.get(storage, "milk") == nil

        TestProject.Storage.put(storage, "milk", 3)
        assert TestProject.Storage.get(storage, "milk") == 3
    end

    test "deletes value by key", %{storage: storage} do
        assert TestProject.Storage.get(storage, "milk") == nil

        TestProject.Storage.put(storage, "milk", 3)
        assert TestProject.Storage.get(storage, "milk") == 3
        TestProject.Storage.delete(storage, "milk")
        assert TestProject.Storage.get(storage, "milk") == nil
    end

    test "are temporary workers" do
        assert Supervisor.child_spec(TestProject.Storage, []).restart == :temporary
    end
end