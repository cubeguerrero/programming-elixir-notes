# Chapter 12: Control Flow

## `if` and `unless`

The `if` and `unless` takes two parameters: a condition and a keyword list, which can contain the keys `do:` and `else:`
```
iex > if 1 == 1, do: "true part", else: "false part" #=> "true part"
iex > if 1 == 2, do: "true part", else: "false part" #=> "false part"
```

`unless` is similart
```
iex > unless 1 == 1, do: "error", else: "OK"
```

The value of `if` and `unless` is the value of the expression that was evaluated.

## `cond`
The `cond` macro lets you list out a series of conditions, each with associated code. It executes the code corresponding to the first truthy conditions.

Syntax is:
```
cond do
  condition 1 ->
    # do something
  condition 2 ->
    # do something
  true -> # catch all
    # do something
end
```

## `case`
`case` lets you test a value against a set of patterns, executes the code associated with the first one that matches, and returns the value of that code. The patterns may include guard clauses.

Example, `File.open` returns a two-element tuple, If successful, it returns `{:ok, file}`, else it returns `{:error, reason}`
```
case File.open("case.ex") do
{:ok, file} ->
  IO.puts "First line: #{IO.read(file, :line)}"
{:error, reason} ->
  IO.puts "Failed to open file: #{reason}"
end
```

## Raising Exceptions
Exceptions in Elixir are *not* control-flow structures. Instead, exceptions are intended for things that should never happen in normal operation.

Raise an exception with the `raise` function. At its simplest, you pass it a strign and it generates an exception of type `RuntimeError`

## Designing with Exceptions
When writing code that know that the operation might not succeed and wants to handle the fact, you might write it:
```
case File.open(file_name) do
{:ok, file} ->
  process(file)
{:error, message) ->
  IO.puts :stderr, "Couldn't open #{file_name}: #{message}"
end
```

When you expect the operation to be done successfully every time, you could raise an exception on failure.
```
case File.open("config_file") do
{:ok, file} ->
  process(file)
{:error, message} ->
  raise "Failed to open config_file: #{message}"
end
```

Or you could let Elixir raise an exception for you
```
{:ok, file} = File.open("config_file")
process(file)
```

Or use a bang method
```
file = File.open!("config_file")
```
The `bang` method or methods with trailing exclamation point in the method name is an Elixir convention -- if you see it, you know the function will raise an exception on error.
