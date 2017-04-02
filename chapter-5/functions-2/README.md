# Problem
Write a function that takes three arguments, if the first two are zero, return "FizzBuzz". If the first is zero, return "Fizz". If the second is zero, return "Buzz", Otherwise return the third argument.

# Solution
We can leverage pattern matching here.
```
fizzbuzz = fn
  (0, 0, _) -> "FizzBuzz"
  (0, _, _) -> "Fizz"
  (_, 0, _) -> "Buzz"
  (_, _, c) -> c
end
```

We can use the special variable `_` to ignore other arguments and just pattern match the zeros as describe by the problem
