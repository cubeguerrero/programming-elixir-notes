# Problem
The operator `rem(a, b)` returns the remainder after dividing `a` by `b`. Write a function that takes a single integer `(n)` and calls the function in the previous exercise passing it `rem(n, 3)`, `rem(n, 5)`, and `n`.

# Solution
This one is fairly simple. We just create a new function called `fizzbuzzer`

```
fizzbuzzer = fn (n) -> fizzbuzz(rem(n, 3), rem(n, 5), n) end
```
