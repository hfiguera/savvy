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
      {:http, {:error, error}} ->
        {:error, error}

      {:json, {:error, error}} ->
        {:error, error}

      {:json, {:ok, _}} ->
        {:error, "not success"}
    end
  end
end
