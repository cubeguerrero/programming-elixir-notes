# Problem
The example `sum` function used an accumulator to build values. But it can also be written without an accumulator. How?

# Solution
The base is to return `0` when the list is empty

```
defmodule MyList do
  def sum([]), do: 0
  def sum([head | tail]), do: head + sum(tail)
end

MyList.sum([]) # => 0
MyList.sum([1, 2, 3, 4]) # => 10
```
