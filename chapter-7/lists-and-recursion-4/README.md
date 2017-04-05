# Problem
Write a function `MyList.span(from, to)` that returns a list of the numbers from `from` up to `to`.

# Solution
```
defmodule MyList do
  def span(from, to) when from == to, do: [to]
  def span(from, to), do: [from | span(from + 1, to)]
end
```
