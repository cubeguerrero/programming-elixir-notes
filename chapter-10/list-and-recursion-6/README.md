# Problem
Write a `flatten(list)` functions that takes a list that may contain any number of sublists, which themselves may contain sublists, to any depth. It returns the elements of these lists as a flat list.

# Solution
```
defmodule MyList do
  def flatten([]), do: []
  def flatten([head | tail]) when is_list(head), do: flatten(head) ++ flatten(tail)
  def flatten([head | tail]), do: [head | flatten(tail)]
end
```
