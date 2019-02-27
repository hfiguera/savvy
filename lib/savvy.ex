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
  @callback_url URI.encode_www_form(Application.get_env(:savvy, :callback, ""))

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

  fiat_code: Fiat currency (usd, eur, cad, etc)

  ## Examples

      iex> Savvy.get_rates("xxx")
      {:error, [%{"data" => "xxx", "message" => "unsupported currency"}]}

      iex> Savvy.get_rates("usd", 1)
      {:error,
         [%{"data" => nil, "message" => "Exchanges was not found for this period"}]}

  """
  @spec get_rates(bitstring(), integer()) :: map() | {:error, bitstring} | {:error, list(map())}
  def get_rates(fiat_code, unix_time \\ -1) do
    uri =
      if unix_time == -1 do
        "#{@url}/v3/exchange/#{fiat_code}/rate"
      else
        "#{@url}/v3/exchange/#{fiat_code}/rate?time=#{unix_time}"
      end

    with {:http, {:ok, body}} <- {:http, HTTP.get(uri)},
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
      {:error, [%{"data" => "xxx", "message" => "unsupported currency"}]}

      iex> Savvy.get_rate("usd", "xxx")
      {:error, [%{"data" => "xxx", "message" => "unsupported chain type"}]}

      iex> Savvy.get_rate("usd", "btc", 1)
      {:error,
        [%{"data" => nil, "message" => "Exchanges was not found for this period"}]}

      iex> Savvy.get_rate("usd", "btc", 1546300800)
      %{
          "bitfinex" => 3832.8,
          "bittrex" => 3700.6162327800002,
          "coinmarketcap" => 3742.70033544,
          "hitbtc" => 3719.27,
          "mid" => 3738.0038736560005,
          "poloniex" => 3694.63280006
      }

  """
  @spec get_rate(bitstring(), bitstring(), integer()) ::
          map() | {:error, bitstring} | {:error, list(map())}
  def get_rate(fiat_code, crypto, unix_time \\ -1) do
    uri =
      if unix_time == -1 do
        "#{@url}/v3/#{crypto}/exchange/#{fiat_code}/rate"
      else
        "#{@url}/v3/#{crypto}/exchange/#{fiat_code}/rate?time=#{unix_time}"
      end

    with {:http, {:ok, body}} <-
           {:http, HTTP.get(uri)},
         {:json, {:ok, %{"success" => true, "data" => data}}} <- {:json, JSON.decode(body)} do
      data
    else
      error ->
        get_error(error)
    end
  end

  @doc """
  Create payment request and get payment address.

  crypto: Crypto currency to accept (eth, btc, bch, ltc, dash, btg, etc)

  ## Examples

      iex> Savvy.create_payment("xxx")
      {:error,
         [%{"data" => "xxx", "message" => "unsupported blockchain or ERC20 token"}]}

  """
  @spec create_payment(bitstring(), integer()) ::
          map() | {:error, bitstring} | {:error, list(map())}
  def create_payment(crypto, lock_address_timeout \\ 3_600) do
    uri =
      "#{@url}/v3/#{crypto}/payment/#{@callback_url}?token=#{@token}&lock_address_timeout=#{
        lock_address_timeout
      }"

    with {:http, {:ok, body}} <- {:http, HTTP.get(uri)},
         {:json, {:ok, %{"success" => true, "data" => data}}} <- {:json, JSON.decode(body)} do
      data
    else
      error ->
        get_error(error)
    end
  end

  # Private funtions

  @spec get_error(tuple()) :: {:error, bitstring()} | {:error, list(map())}
  defp get_error(error) do
    case error do
      {:http, {:error, error}} ->
        {:error, error}

      {:json, {:error, error}} ->
        {:error, error}

      {:json, {:ok, %{"success" => false, "errors" => errors}}} ->
        {:error, errors}

      {:json, {:ok, _}} ->
        {:error, "not success"}
    end
  end
end
