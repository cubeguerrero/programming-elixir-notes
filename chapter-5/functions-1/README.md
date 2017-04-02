Create and run functions that do the following:

1. list_concat.([:a, :b], [:c, :d]) #=> [:a, :b, :c, :d]
Solution:
```
iex > list_concat = fn (a, b) -> a ++ b end
```

2. sum.(1, 2, 3) #=> 6
Solution:
```
iex > sum = fn (a, b, c) -> a + b + c end
```

3. pair_tuple_to_list.({1234, 5678}) #=> [1234, 5678]
Solution:
```
iex > pair_tuple_to_list = fn a -> Tuple.to_list(a) end
```
