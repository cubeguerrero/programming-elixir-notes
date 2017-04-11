# Problem
Write an `ok!` function that takes an arbitrary parameter. If the parameter is the tuple `{:ok, data}`, return the data. Otherwise, raise an exception containing information from the parameter.

## Solution
We can use pattern matching here

```
defmodule Utilities do
  def ok!({:ok, data} = val), do: data
  def ok!({:error, error} = val), do: raise "Something went wrong: #{error}"
end
```
