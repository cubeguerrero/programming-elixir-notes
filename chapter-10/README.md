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
  - takes 3 functions
    1. `start_function` - A function that returns the value, it also takes no parameters
    2. `next_function` - A function where you do stuff with the data you get from the first function, return value must be a tuple that contains a list of items to be emitted and the *next accumulator*
    3. `after_function` - A function that takes the final accumulator value and does whatever is needed to deallocate the resource.
  ```
  Stream.resource(
    fn -> File.open!("sample") end,
    fn file ->
      case IO.read(file, :line)
        data when is_binary(data) -> {[data], file}
        _ -> {:halt, file}
      end
    end,
    fn file -> File.close(file) end
  )
  ```

### Streams in Practice
Consider using a stream when you want to defer processing until you need the data, and when you need to deal with large numbers of things without necessarily genearting them all at once.


## The Collectable Protocol
`Enumerable` protocol lets you iterate over the elements in a type -- given a collection, you can get the elements.

`Collectable` allows you to build a collection by inserting elements into it.

**Not all collections are collectable. Ranges cannot have new entries added to them.**

Use the `Enum.into` function to access the `Collectable` API
```
iex > Enum.into 1..5, []
[1, 2, 3, 4, 5]
iex > Enum.into 1..5, [-1, 0]
[-1, 0, 1, 2, 3, 4, 5]
```
Output streams are collectable
```
iex > Enum.into IO.stream(:stdio, :line), IO.stream(:stdio, :line)
```

## Comprehensions
The idea of a **comprehension** is given one or more collections, extract all combinations of values from each, optionally filter the values, and then generate a new collection using the values that remain.

The general syntax for comprehensions
```
result = for generator or filter... [, into: value] do: expression
```

```
iex > for x <- [1, 2, 3, 4, 5], do: x * x
iex > for x <- [1, 2, 3, 4, 5], x < 4, do: x * x #=> [1, 4, 9]
```

The **generator** specifies how you want to extract values from a collection. `pattern <- enumerable_thing`, any variables matched in the pattern are available in the rest of the comprehension.

A **filter** is a predicate. It acts as a gatekeeper for the rest of the comprehension -- if the condition is fales, then the comprehension moves on to the next iteration without generating an output value.

Because the first term in a generator is a pattern, we can use it to deconstruct structed data.

```
iex > reports [dallas: :hot, minneapolis: :cold, dc: :muggy, la: :smoggy]
iex > for {city, temperature} <- reports, do: { temperature, city}
```

### Comprehensions Work on Bits, Too
Enclose the generator in `<<` and `>>`, indicating a binary.
```
iex > for << ch <- "hello" >>, do: ch
iex > for << ch <- "hello" >>, do: <<ch>>
```

### Scoping and Comprehensions
All variable assignments inside a comprehension are local to that comprehension.

### The Value Returned by a Comprehension
Use the `into:` parameter to change the default behaviour of a comprehension (returning a list)
```
for x <- ~w{cat dot}, into: %{}, do: {x, String.upcase(x)}
```
