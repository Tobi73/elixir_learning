defmodule TestProject.Client do
    use GenServer

    def start_link(opts) do
        server = Keyword.fetch!(opts, :name)
        GenServer.start_link(TestProject.Server, server, opts)
    end

    def lookup(server, name) do
        case :ets.lookup(server, name) do
            [{^name, pid}] -> {:ok, pid}
            [] -> :error    
        end
    end

    def create(server, name) do
        GenServer.call(server, {:create, name})
    end

    def stop(server) do
        GenServer.stop(server)
    end
end