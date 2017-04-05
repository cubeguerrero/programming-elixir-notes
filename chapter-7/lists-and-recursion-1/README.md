# Problem
Write a `mapsum` function that takes a list and a function. It applies the function to each element of the list and then sums the result.

# Solution
Building upon ListAndRecusion-0
```
defmodule MyList do
  def mapsum([], _func), do: 0
  def mapsum([head | tail], func), do: func.(head) + mapsum(tail, func)
end

IO.puts MyList.mapsum([1, 2, 3, 4], &(&1 + 1)) # => 14
IO.puts MyList.mapsum([1, 2, 3, 4], &(&1 * &1)) # => 30
```
