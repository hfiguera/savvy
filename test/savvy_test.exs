defmodule SavvyTest do
  use ExUnit.Case
  doctest Savvy

  test "get a list of enabled currencies" do
    currencies = Savvy.get_currencies()

    result =
      case currencies do
        %{"btc" => %{}} ->
          true

        _ ->
          false
      end

    assert result
  end
end
