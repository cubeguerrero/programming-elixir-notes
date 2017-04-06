# Processing Collections -- Enum and Stream
Any data structure that can be iterated implements the `Enumerable` protocol.

Elixir provides two modules that have iteration functions.
1. The `Enum` module is the workhorse for collections.
2. The `Stream` module lets you enumerate a collection lazily, which means that the next value is calculated only when it is needed.

## Enum -- Processing Collections
The `Enum` module can be used for the following:
- Convert any collection into a list
  ```
  iex > list = Enum.to_list 1..5
  ```

- Concatenate collections
  ```
  Enum.concat([1, 2, 3], [4, 5, 6])
  [1, 2, 3, 4, 5, 6]
  ```

- Create collections whose elements are some function of the original
  ```
  iex > Enum.map(list, &(&1 * 10))
  ```

- Select elements by position or criteria
  ```
  iex > Enum.at(10..20, 3)
  iex > Enum.at(10..20, 20, :no_one_here) #=> :no_one_here
  iex > Enum.filter(list, &(&1 > 2))
  iex > Enum.reject(list, &Integer.is_even/1)
  ```

- Sort and compare elements
  ```
  iex > Enum.sort(["there", "was", "a", "crooked", "man"])
  iex > Enum.sort(["there", "was", "a", "crooked", "man"], &(String.length(&1) <= String.length(&2)))
  iex > Enum.max(["there", "was", "a", "crooked", "man"]) #=> "was"
  iex > Enum.max_by(["there", "was", "a", "crooked", "man"], &String.length/1) #=> "crooked"
  ```

- Split a collection
  ```
  # list = [1, 2, 3, 4, 5]
  iex > Enum.take(list, 3)
  [1, 2, 3]
  iex > Enum.take_every(list, 2)
  [1, 3, 5]
  iex > Enum.take_while(list, &(&1 < 4))
  [1, 2, 3]
  iex > Enum.split(list, 3)
  {[1, 2, 3], [4, 5]}
  iex > Enum.split_while(list, &(&1 < 4))
  {[1, 2, 3], [4, 5]}
  ```

- Join a collection:
  ```
  iex > Enum.join(list) #=> "12345"
  iex > Enum.join(list, ", ") #=> "1, 2, 3, 4, 5"
  ```

- Predicate operations:
  ```
  iex > Enum.all?(list, &(&1 < 4)) #=> false
  iex > Enum.any?(list, &(&1 < 4)) #=> true
  iex > Enum.member?(list, 4) #=> true
  iex > Enum.empty?(list) # => false
  ```

- Merge collections:
  ```
  iex > Enum.zip(list, [:a, :b, :c])
  [{1, :a}, {2, :b}, {3, :c}]
  iex > Enum.with_index(["once", "upon", "a", "time"])
  [{"once", 0}, {"upon", 1}, {"a", 2}, {"time", 3}]
  ```

- Fold elements into a single value
  ```
  iex > Enum.reduce(1..100, &(&1 + &2))
  ```

#### A Note on Sorting
It's important to use `<=` not just `<` if you want the sort to be **stable**
