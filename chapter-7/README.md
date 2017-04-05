# Lists and Recursions

## Heads and Tails
An Elixir list may either be empty or consist of a head and a tail, which is also a list.

Example: `[3]` can be thought of as:
```
iex > [ 3 | [] ]
[3]
iex > [1 | [2 | [3 | []]]]
[1, 2, 3]
```

The left of the `|` is the *head* and on the right is the *tail*.

In patter matching with lists, we could do:
```
iex > [x, y, z] = [2, 4, 6]
[2, 4, 6]
iex > x # => 2
iex > y # => 4
iex > z # => 6
```

We can also use the `|` in pattern matching:
```
iex > [head | tail] = [1, 2, 3]
iex > head # => 1
iex > tail # => [2, 3]
```

## Using Head and Tail to Process a List
List and recursive functions go together. Let's look at finding the length of a list:
```
defmodule MyList do
  def len([]), do: 0
  def len([_head | tail]), do: 1 + len(tail)
end
```

## Using Head and Tail to Build a List
We can also write a function that takes a list and returns a new list.
```
defmodule MyList do
  def square([]), do: []
  def square([head | tail]), do: [head * head | square(tail)]
end
```

## Creating a Map Function
We'll define a function called map that takes a list and a function and returns a new list containing the result of applying that function to each element in the original.
```
defmodule MyList do
  def map([], _func), do: []
  def map([head | tail], func), do: [func.(head) | map(tail, func)]
end

MyList.map([1, 2, 3, 4], &(&1 * &1))
```

## Keeping Track of Values During Recursion
Pass the sum (state) as a function's parameter
```
defmodule MyList do
  def sum([], total), do: total
  def sum([head | tail]), do: sum(tail, head + total)
end
```

These types of functions maintain an **invariant**, a condition that is true on return from any call (or nested call).

### Generalizing our Sum function
The `reduce` function will be called with three arguments:
```
defmodule MyList do
  def reduce([], value, _), do: value
  def reduce([head | tail], value, func), do: reduce(tail, func.(head), func)
end
```

## More Complex List Pattern
The join operator `|` supports multiple values to its left. You could write:
```
iex > [1, 2, 3 | [4, 5, 6]
[1, 2, 3, 4, 5, 6]
```

Same thing works in patterns, you can match multiple individual elements as the head.
```
defmodule Swapper do
  def swap([]), do: []
  def swap([a, b | tail]), do: [b, a | swap(tail)]
  def swap([_], do: raise "Can't swap a list with an odd number of elements"
end
```

### Lists of Lists
We can go beyond just matching for the value of the `head` of the list (using `[head | tail]`). We can use pattern matching to get the type of value we want for the head of the list.

```
defmodule WeatherHistory do
  def for_location_27([]), do: []
  def for_location_27([[time, 27, temp, rain] | tail]) do
    [[time, 27, temp, rain] | for_location_27(tail)
  end
  def for_location_27([ _ | tail]), do: for_location_27(tail)
end
```

We used a more precise pattern match for our `head` to filter out data whose 2nd value isn't 27. `[time, 27, temp, rain]`

The code is limited to a hard coded value `27` we can improve upon this.
```
defmodule WeatherHistory do
  def for_location_27([], _target), do: []
  def for_location_27([ head = [_, target, _, _] | tail], target) do
    [head | for_location_27(tail, target)
  end
  def for_location_27([ _ | tail], target), do: for_location_27(tail, target)
end
```

## The List Module in Action
The `List` module provides a set of functions that operate on lists.
```
iex > [1, 2, 3] ++ [4, 5, 6]
[1, 2, 3, 4, 5, 6]
iex > List.flatten([[[1], 2], [[[3]]]])
[1, 2, 3]
#
# Folding (like reduce, but can choose direction)
#
iex > List.foldl([1, 2, 3], "", fn value, acc -> "#{value}(#{acc})" end)
iex > List.foldr([1, 2, 3], "", fn value, acc -> "#{value}(#{acc})" end)
#
# Updating in the middle (not a cheap operation)
#
iex > list = [1, 2, 3]
iex > List.replace_at(list, 2, "buckle my shoe")
#
# Accessing tuples within lists
#
iex > kw = [{:name, "Dave"}, {:likes, "Programming"}, {:where, "Dallas", "TX"}]
iex > List.keyfind(kw, "Dallas", 1)
{:where, "Dallas", "TX"}
iex > kw = List.keydelete(kw, "TX", 2)
[name: "Dave", likes: "Programming"]
iex > kw = List.keyreplace(kw, :name, 0, {:first_name, "Dave"})
[first_name: "Dave", likes: "Programming"]
```
