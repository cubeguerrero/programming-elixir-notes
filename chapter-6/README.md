# Modules and Named Functions
In Elixir, you break your codes into **named functions** and organized these functions into **modules**. **Named functions** *must* be written inside modules.

## Compiling a Module
Two ways to compile and load a module into iex

First:
```
$ iex times.exs
iex > Times.double(4)
```

Second, you should already be in `iex`:
```
iex > c "times.exs"
[Times]
iex > Times.double(4)
8
```

In Elixir, a named function is identified by both its name and its number of parameters (its **arity**).

## The Function's Body is a Block
The `do..end` block is one way of grouping expressions and passing them to other code.

The `do..end` is just a lump of syntatic sugar. The actualy syntax of functions in Elixir looks like this:
```
def double(n), do: (
  n * 2
)
```

Typically people use the `do:` syntax for single-line blocks and `do...end` for multiline ones.

## Function Calls and Pattern Matching
We can also use pattern matching for named functions. The difference between anonymous and named functions is that we write the function multiple times. each time with its own parameter list and body.
```
defmodule Factorial do
  def of(0), do: 1
  def of(n), do: n * of(n - 1)
end
```

This pattern of design and coding is very common in Elixir (and almost all functional language).
1. Look for the simplest case possible, one that has a definite answer. This will be the answer
2. Look for a recursive solution that will end up calling the anchor case.


The order of these clauses can make a difference when you translate them into code. Elixir tries functions from the top down, executing the first match. The following will not work:
```
defmodule Factorial do
  def of(n), do: n * of(n - 1)
  def of(0), do: 1
end
```

## Guard Clauses
Guard clauses are predicates that are attached to a function definition using one or more `when` keywords. When doing pattern matching, Elixir first does the conventional parameter-based match and then evaluates any `when` predicates, executing the function only if at least one predicate is true
```
defmodule Guard do
  def what_is(x) when is_number(x) do
    IO.puts "#{x} is a number"
  end

  def what_is(x) when is_list(x) do
    IO.puts "#{inspect(x)} is a list"
  end
end
```

### Guard-Clause Limitations
You can only write a subset of Elixir expressions in guard clauses:
*Comparison operators*
```
==, !=, ===, !==, >, <, <=, >=
```

*Boolean and negation operators*
```
or, and, not, !
```
Note, relative boolean operators such as `||` and `&&` are now allowed

*Arithmetic operators*
```
+, -, *, /
```

*Join operators*
```
<> and ++
```

*The `in` operator*
```
a in list
```
Membership in a collection or range.

*Type-check functions*
Built-in Erlang functions that returns true if their argumetn is a given type.
```
is_atom, is_binary, is_bitstring, is_boolean, is_exception, is_float, is_function, is_integer, is_list, is_map, is_number, is_pid, is_port, is_record, is_reference, is_tuple
```

*Other functions*
```
abs(number), bit_size(bitstring), byte_size(bitstring), div(number, number), elem(tuple, n), float(term), hd(list), length(list), node(), node(pid | ref | port), rem(number, number), round(number), self(), tl(list), trunc(number), tuple_size(tuple)
```

## Default Parameters
When you define a named function, you can give a default value to any of its parameters by using the syntax `params \\ value`.
```
defmodule Example do
  def func(p1, p2 \\ 2, p3 \\ 3, p4) do
    IO.inspect [p1, p2, p3, p4]
  end
end

Example.func("a", "b")           # => ["a", 2, 3, "b"]
Example.func("a", "b", "c")      # => ["a', "b", 3, "c"]
Example.func("a", "b", "c", "d") # => ["a", "b", "c", "d"]
```

Default arguments can behave surprisingly when Elixir does pattern matching.
```
def func(p1, p2 \\ 2, p3 \\ 3, p4) do
  IO.inspect([p1, p2, p3, p4]
end

def func(p1, p2)
  IO.inspect([p1, p2])
end
```
Will give you a `CompileError`, because fhe first function definition matches any call with two, three, or four arguments

Elixir tries to reduce the confusion that can arise with default parameters. The solution is to add a function head with no body that contains the default parameters, and use regular parameters for the rest. The defaults will apply to all calls to the function
```
defmodule Params do
  def func(p1, p2 \\ 123)

  def func(p2, p2) when is_list(p1) do
    "You said #{p2} with a list"
  end

  def func(p1, p2) do
    "You passed in #{p1} and #{p2}"
  end
end
```
