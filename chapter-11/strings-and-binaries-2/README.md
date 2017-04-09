# Problem
Write an `anagram?(word1, word2)` that returns true if its paramters are anagrams.

# Solution
```
defmodule MyString do
  def anagram?(word1, word2) do
    Enum.sort(word1) == Enum.sort(word2)
  end
end
```
Note: this won't check for capitalized letters. Will come back to fix it later.
