defmodule Savvy.HTTP do
  @moduledoc """
  Implement the HTTP requests
  """

  @doc """
  Issues a GET request to the given url.

  ## Examples

      iex> Savvy.HTTP.get("httpstat.us/200")
      {:ok, ""}

      iex> Savvy.HTTP.get("httpstat.us/201")
      {:error, "server error"}

      iex> Savvy.HTTP.get("httpstat.us/400")
      {:error, "server error"}

      iex> Savvy.HTTP.get("httpstat.us/404")
      {:error, "bad endpoint"}

      iex> Savvy.HTTP.get("httpstat.us/500")
      {:error, "server error"}
  """
  @spec get(bitstring()) :: {:ok, bitstring()} | {:error, bitstring()}
  def get(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "bad endpoint"}

      {:ok, %HTTPoison.Response{}} ->
        {:error, "server error"}

      {:error, %HTTPoison.Error{}} ->
        {:error, "http error"}
    end
  end
end
