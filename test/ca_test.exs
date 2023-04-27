defmodule CaTest do
  use ExUnit.Case
  doctest Ca

  test "greets the world" do
    assert Ca.hello() == :world
  end
end
