defmodule TestProjectServerTest do
  use ExUnit.Case
  doctest TestProjectServer

  test "greets the world" do
    assert TestProjectServer.hello() == :world
  end
end
