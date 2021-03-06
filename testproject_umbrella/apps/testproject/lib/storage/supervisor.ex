defmodule TestProject.Supervisor do
    use Supervisor

    def start_link(opts) do
        Supervisor.start_link(__MODULE__, :ok, opts)
    end

    def init(:ok) do
        children = [
            {DynamicSupervisor, name: Storage, strategy: :one_for_one},
            {TestProject.Client, name: Client}
        ]

        Supervisor.init(children, strategy: :one_for_all)
    end
end