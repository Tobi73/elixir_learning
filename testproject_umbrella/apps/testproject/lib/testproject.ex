defmodule TestProject do
  use Application
  @moduledoc """
  Documentation for TestProject.
  """

  @doc """
  Hello world.

  ## Examples

      iex> TestProject.hello
      :world

  """
  def start(_type, _args) do
    TestProject.Supervisor.start_link(name: TestProject.Supervisor)
  end
end
