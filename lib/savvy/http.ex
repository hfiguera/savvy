defmodule Savvy.HTTP do
  @moduledoc """
  Implement the HTTP requests
  """

  @headers [{"Accept", "application/json"}]
  @doc """
  Issues a GET request to the given url.

  ## Examples

      iex> Savvy.HTTP.get("httpstat.us/200")
      {:ok, "\\"200 OK\\""}

      iex> Savvy.HTTP.get("httpstat.us/400")
      {:ok, "\\"400 Bad Request\\""}

      iex> Savvy.HTTP.get("httpstat.us/404")
      {:ok, "\\"404 Not Found\\""}

      iex> Savvy.HTTP.get("httpstat.us/500")
      {:error, "server error"}
  """
  @spec get(bitstring()) :: {:ok, bitstring()} | {:error, bitstring()}
  def get(url) do
    case HTTPoison.get(url, @headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: 201, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{}} ->
        {:error, "server error"}

      {:error, %HTTPoison.Error{}} ->
        {:error, "http error"}
    end
  end
end
