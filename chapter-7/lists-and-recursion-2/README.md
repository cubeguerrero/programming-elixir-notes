# Problem
Write a `max(list)` that returns the element with the maximum value in the list.

# Solution
I would create a helper function that accepts the current max value

```
defmodule MyList do
  def max([head | tail]), do: _max(tail, head)

  defp _max([], current_max), do: current_max
  defp _max([head | tail], current_max) when head > current_max, do: _max(tail, head)
  defp _max([_head | tail], current_max), do: _max(tail, current_max)
end
```
