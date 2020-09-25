defmodule ArgosWorkersTest do
  use ExUnit.Case
  doctest ArgosWorkers

  test "greets the world" do
    assert ArgosWorkers.hello() == :world
  end
end
