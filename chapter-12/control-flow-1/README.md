# Problem
Rewrite the FizzBuzz example using `case`

```
defmodule FizzBuzz do
  def downto(n), do: _downto(n, [])

  defp _downto(0, result), do: result
  defp _downto(n, result) do
    case _get_remainder(n) do
      {0, 0, _} ->
        "FizzBuzz"
      {0, _, _} ->
        "Fizz"
      {_, 0, _} ->
        "Buzz"
      _ ->
        n
    end


  end
end
