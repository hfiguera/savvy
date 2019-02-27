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

  test "get the current average market rates for usd" do
    currencies = Savvy.get_rates("usd")

    result =
      case currencies do
        %{"btc" => %{}} ->
          true

        _ ->
          false
      end

    assert result
  end

  test "get exchange rates for usd & btc" do
    currencies = Savvy.get_rate("usd", "btc")

    result =
      case currencies do
        %{"mid" => _} ->
          true

        _ ->
          false
      end

    assert result
  end

  test "create payment request and get payment btc address" do
    payment = Savvy.create_payment("btc")

    result =
      case payment do
        %{"address" => _, "invoice" => _} ->
          true

        _ ->
          false
      end

    assert result
  end
end
