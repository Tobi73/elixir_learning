defmodule TestProject.Server do
    use GenServer

    def init(table) do
        names = :ets.new(table, [:named_table, read_concurrency: true])
        refs = %{}
        {:ok, {names, refs}}
    end

    def handle_call({:lookup, name}, _from, { names, _ } = state) do
        {:reply, Map.fetch(names, name), state}
    end

    def handle_call({:create, name}, _from, { names, refs }) do
        case TestProject.Client.lookup(names, name) do
            {:ok, _pid} ->
                {:noreply, {names, refs}}
            :error ->
                {:ok, storage} = DynamicSupervisor.start_child(Storage, TestProject.Storage)
                ref = Process.monitor(storage)
                refs = Map.put(refs, ref, name)
                :ets.insert(names, {name, storage})
                {:reply, storage, {names, refs}}
        end
    end

    def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
        {name, refs} = Map.pop(refs, ref)
        names = :ets.delete(names, name)
        {:noreply, {names, refs}}
    end

    def handle_info(_msg, state) do
        {:noreply, state}
    end
end