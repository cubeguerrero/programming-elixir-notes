# Problem
Write a function to capitalize the sentences in a string. Each sentence is terminated by a period and a space.

# Solution
```
defmodule MyString do
  def capitalize_sentences(str) do
    str
    |> String.split(". ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(". ")
  end
end
```
