# Problem
Write a function `prefix` that takes a string. It should return a new function that takes a second string. When the second function is called, it will return a string containing the first string, a space, and the second string

# Solution
Pretty straightforward

```
prefix = fn (prefix) -> (fn (str) -> "#{prefix} #{str}" end) end
```
