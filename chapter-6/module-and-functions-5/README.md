# Problem
Write a function `gcd(x, y)` that finds the greatest common divisor between two nonnegative integers.

# Solution
```
defmodule Gcd do
  def of(x, 0), do: x
  def of(x, y), do: gcd(y, rem(x, y))
end
```
