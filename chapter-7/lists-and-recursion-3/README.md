# Problem
An Elixir single-quoted string is actually a list of individual character codes. Write a `ceasar(list, n)` function that adds `n` to each list element if the addition results in a character that **z**

# Solution
Notice we used `?z` to compare our value. What the `?` does is get the character code of the letter next to it, so that we can compare both integers.

But this wasn't taught yet in the book, the second solution does this for us.
```
defmodule MyList do
  def ceasar([], _), do: []
  def ceasar([head | tail], n) when head + n > ?z do
    [head + n - 26 | ceasar(tail, n)]
  end
  def ceasar([head | tail], n) do
    [head + n | ceasar(tail, n)]
  end
end

IO.puts MyList.ceasar('ryvkve', 13)
```

It's similar except the `when` clause in the middle function declaration.
```
defmodule MyList do
  def ceasar([], _), do: []
  def ceasar([head | tail], n) when [head + n] > 'z' do
    [head + n - 26 | ceasar(tail, n)]
  end
  def ceasar([head | tail], n) do
    [head + n | ceasar(tail, n)]
  end
end

IO.puts MyList.ceasar('ryvkve', 13)
```
