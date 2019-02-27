defmodule Savvy do
  @moduledoc """
  SDK for https://www.savvy.io/

  You need to export the following environment variables:

  export SAVVY_URL="https://api.test.savvy.io"

  export SAVVY_SECRET="YOUSAVVYSECRECT"

  export SAVVY_CALLBACK="http://localhost"

  """

  alias Savvy.JSON
  alias Savvy.HTTP

  @url Application.get_env(:savvy, :url, "https://api.test.savvy.io")
  @token Application.get_env(:savvy, :secret, "YOUSAVVYSECRECT")

  @doc """
  Get a list of enabled currencies

  """
  @spec get_currencies() :: map() | {:error, bitstring()}
  def get_currencies() do
    with {:http, {:ok, body}} <- {:http, HTTP.get("#{@url}/v3/currencies?token=#{@token}")},
         {:json, {:ok, %{"success" => true, "data" => data}}} <- {:json, JSON.decode(body)} do
      data
    else
      error ->
        get_error(error)
    end
  end

  @doc """
  Get the current average market rates.
  fiat_code Fiat currency (usd, eur, cad, etc)

  ## Examples

      iex> Savvy.get_rates("xxx")
      {:error, "server error"}

  """
  @spec get_rates(bitstring()) :: map() | {:error, bitstring}
  def get_rates(fiat_code) do
    with {:http, {:ok, body}} <- {:http, HTTP.get("#{@url}/v3/exchange/#{fiat_code}/rate")},
         {:json, {:ok, %{"success" => true, "data" => data}}} <- {:json, JSON.decode(body)} do
      data
    else
      error ->
        get_error(error)
    end
  end

  @doc """
  Get exchange rates for one currency

  ## Examples

      iex> Savvy.get_rate("xxx", "btc")
      {:error, "server error"}

      iex> Savvy.get_rate("usd", "xxx")
      nil

  """
  @spec get_rate(bitstring(), bitstring()) :: map() | nil | {:error, bitstring}
  def get_rate(fiat_code, crypto) do
    case get_rates(fiat_code) do
      {:error, error} ->
        {:error, error}

      rates ->
        rates[crypto]
    end
  end

  # Private funtions

  defp get_error(error) do
    case error do
      {:http, {:error, error}} ->
        {:error, error}

      {:json, {:error, error}} ->
        {:error, error}

      {:json, {:ok, _}} ->
        {:error, "not success"}
    end
  end
end
