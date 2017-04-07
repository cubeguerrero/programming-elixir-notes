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

## Streams -- Lazy Enumerables
The `Enum` module is **greedy**, which means that when you pass it a collection, it potentially consumes all the contents of that collection. It also means the result will typicall be another collection.

## A `Stream` is a Composable Enumerator
Stream process the elements of a collection as you need them, it passed the current element from function to function.

Simple example of `Stream`
```
iex > s = Stream.map([1, 3, 5, 7], &(&1 + 1))
#Stream<[enum: [1, 3, 5, 7], funs: [#Function<37.759945740/1 in Stream.map/2>]]>
```

To get the `Stream` to return results, pass it into one of the `Enum` modules functions
```
iex > Enum.to_list s #=> [2, 4, 6, 8]
```

Streams are `composable`, you can pass a stream into another stream
```
[1, 2, 3, 4]
|> Stream.map(&(&1 * &1))
|> Stream.map(&(&1 + 1))
|> Stream.filter(fn x -> rem(x, 2) == 1 end)
|> Enum.to_list
```

### Infinite Streams
Because streams are lazy there's no need for the whole collection to be available.
```
iex > Enum.map(1..10_000_000, &(&1 + 1)) |> Enum.take(5) #=> will lag/make you wait before you get the result
iex > Stream.map(1..10_000_000, &(&1 + 1)) |> Enum.take(5)
```

We can create a stream that can go on forever, by creating streams based on functions

### Creating your own Streams
We can use the following functions to create our own streams

1. `Stream.cycle`
  - takes an enumberable and returns an infinite stream containing that enumerable's elements. When it gets to the end, it repeats from the beginning, indefinitely.
  ```
  iex > Stream.cycle(~w{ red white }) |> Enum.zip(1..5)
  [{"red", 1}, {"white", 2}, {"red", 3}, {"white", 4}, {"red", 5}]
  ```

2. `Stream.repeatedly`
  - takes a function and invokes it each time a new value is wanted
  ```
  iex > Stream.repeatedly(fn -> true end) |> Enum.take(3)
  [true, true, true]
  ```

3. `Stream.iterate`
  - takes a starting value and a function. It generates an infinite stream by starting with the given starting value and generating the next one with the function
  ```
  iex > Stream.iterate(0, &(&1 + 1)) |> Enum.take(5)
  [0, 1, 2, 3, 4]
  ```

4. `Stream.unfold`
  - takes an initial value and a function, the functions uses the argument to create two values, returned as tuple. The first element of the tuple is the value to be returned by this iteration of the stream, and the second value is the value to be passed to the function on the next iteration of the stream.
  - The generating function's form is `fn state -> { stream_value, new_state } end`
  ```
  iex > Stream.unfold({0, 1}, fn {f1, f2} -> {f1, {f2, f1 + f2}} end) |> Enum.take(5)
  [0, 1, 1, 2, 3]
  ```

5. `Stream.resource`
