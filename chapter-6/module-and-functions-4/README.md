# Problem
Implement and run a function `sum(n)` that uses recursion to calculate the sum of the integers from 1 to `n`.

# Solution
```
defmodule Sum do
  def from(1), do: 1
  def from(n), do: n + from(n - 1)
end
```
