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

If we didn't need to capture a value during the match, we can use the special variable `_` (underscore). This acts like a variable but immediately discards any value given to it - in a pattern match.
```
iex > [1, _, _] = [1, 2, 3]
[1, 2, 3]
iex > [1, _, _] = [1, "cat", "dog"]
[1, "cat", "dog"]
```

Once a variable has been bound to a value in the matching process, it keeps that value for the remainder of the match
```
iex > [a, a] = [1, 1]
[1, 1]
iex > [b, b] = [1, 2]
** (MatchError) no match of right hand side value: [1, 2]
```

A variable can be bound to a new value in a subsequent match, and its current value does not participate in the new match
```
iex > a = 1
iex > [1, a, 3] = [1, 2, 3]
iex > a
2
```

If you want to force Elixir to use the existing value of the variable in the pattern, prefix it with `^` (caret). We call this *pin operator*
```
iex > a = 1
1
iex > a = 2
2
iex > ^a = 1
** (MatchError) no match of right hand side value: 1
```
Also works if the variable is a component of a pattern:
```
iex > a = 1
iex > [^a, 2, 3] = [1, 2, 3]
iex > a = 2
iex > [^a, 2] = [1, 2]
** (MatchError) no match of right hand side value: [1, 2]
```
