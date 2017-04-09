# Problem
Write a function that returns `true` if a single-quoted string contains only ASCII characters

## Solution
```
defmodule MyString do
  def printable?([]), do: true
  def printable?([head | _tail]) when head < 32 or head > 126, do: false
  def printable?([_head | tail]), do: printable?(tail)
end
```
