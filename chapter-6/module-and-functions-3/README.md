# Problem
Add a `quadruple` function

# Solution
```
defmodule Times do
  def double(n), do: n * 2
  def quadruple(n), do: double(double(n))
end
```
