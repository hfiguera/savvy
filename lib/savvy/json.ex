defmodule Savvy.JSON do
  @moduledoc """
  Encode & decode JSON
  """

  @doc """
  Parses a JSON value from an input string.

  ## Examples

      iex> Savvy.JSON.decode("{}")
      {:ok, %{}}

      iex> Savvy.JSON.decode("invalid")
      {:error, "invalid json"}
  """
  @spec decode(bitstring()) :: {:ok, map()} | {:error, bitstring}
  def decode(string) do
    case Jason.decode(string) do
      {:ok, json} ->
        {:ok, json}

      {:error, %Jason.DecodeError{}} ->
        {:error, "invalid json"}
    end
  end
end
