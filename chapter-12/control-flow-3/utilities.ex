defmodule Utilities do
  def ok!({:ok, data}), do: data
  def ok!({:error, error}), do: raise "Something went wrong: #{error}"
end

