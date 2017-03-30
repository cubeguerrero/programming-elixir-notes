# Notes

In Elixir, the equals sign `=` is not an assignment. Instead it's like an assertion.It succeeds if Elixir can find a way of making the left-hand side equal the right-hand side. Elixir calls `=` a *match operator*

Elixir looks for a way to make the value of the left side the same as on the right, it calls this *pattern matching*. A pattern (the left side) is matched if the values (the right side) have the same structure and if each term in the pattern can be matched to the corresponding. A literal value in the pattern matches that exact value, and a variable in the pattern matches by taking on the corresponding value.
```
iex > list = [1, 2, [3, 4, 5]]
iex > [a, b, c] = list # [a, b] = list will cause an error
iex > a
1
iex > b # 2
2
iex > c # 3
[3, 4, 5]
```
