# Notes - Anonymous Functions

An anonymous function is created using the `fn` keyword:
```
fn
  parameter-list -> body
end
```

For example:
```
iex > sum = fn(a, b) -> a + b end
iex > sum.(1, 2)
3
```

The first line of code, we create a function with parameters `a` and `b`. The body simply adds `a` and `b` and we store it to the variable sum.

The second line of code invokes the function. Notice that there is a dot, this indicates the function call, and the arguments are passed between parenthesis.

If your function takes no arguments, you still need the parenthesis to call it.
```
iex > greet = fn -> IO.puts "Hello" end
iex > greet.()
Hello
:ok
```

You can omit the parenthesis in a function definition
```
iex > f1 = fn a, b -> a * b end
iex > f1.(5, 6)
30
```

## Functions and Pattern Matching
We can perform more complex pattern matching when we call a function.
```
iex > swap = fn {a, b} -> {b, a} end
iex > swap.({6, 8})
{8, 6}
```

## One Function, Multiple Bodies
A single function definition lets you define different implementations, depending on the type and contents of the arguments passed.

We can use pattern matching to select which clause to run. Example:
```
iex > handle_open = fn
... >   {:ok, file} -> "Read data: #{IO.read(file, :line)}"
... >   {_, error}  -> "Error: #{:file.format_error(error)}"
... > end
iex > handle_open.(File.open("code/intro/hello.exs"))
"Read data: IO.puts \"Hello, world!\"\n"
iex > handle_open.(File.open("nonexistent")
"Error: no such file or directory"
```

## Funtions Can Return Functions
```
iex > fun1 = fn -> fn -> "Hello" end end
iex > fun1.()
iex > fun1.().()
"Hello"
```

### Functions Remember Their Original Environment
```
iex > greetr = fn name -> (fn -> "Hello #{name}" end) end
iex > dave_greeter = greeter.("Dave")
iex > dave_greeter.()
"Hello Dave"
```

Functions in Elixir automatically carry with them the bindings of variables in the scope in which they are defined. The is called **closure** -- the scope encloses the bindings of its variables, packaging them into something that can be saved and used later

### Parameterized Functions
```
iex > add_n = fn n -> (fn other -> n + other end) end
iex > add_two = add_n.(2)
iex > add_five = add_n.(5)
iex > add_two.(3)
5
iex > add_five(7)
12
```

The inner functions adds the value of its parameter `other` to the value of the outer function's parameter `n`.

## Passing Functions as Arguments
Functions are just values, so we can pass them to other functions
```
iex > times_2 = fn n -> n * 2 end
iex > apply = fn (func, value) -> func.(value) end
iex apply.(times_2, 6)
12
```

The `apply` is a function that takes a second function and a value. It returns the result of invoking that second function with the value as an argument.

We use the ability to pass functions around pretty much everywhere in Elixir code.
```
iex > list = [1, 3, 5, 7, 9]
iex > Enum.map list, fn elem -> elem * 2 end
[2, 6, 10, 14, 18]
iex > Enum.map list, fn elem -> elemn * elem end
[1, 9, 25, 49, 81]
```

### Pinned Values and Function Parameters
We can also use the pin operator (`^`) with function parameters too.
```
defmodule Greeter do
  def for(name, greeting) do
    fn
      (^name) -> "#{greeting} #{name}"
      (_)     -> "I don't know you"
    end
  end
end

cube = Greeter.for("Cube", "Oi!")
IO.puts cube.("Cube") # => Oi! Cube
IO.puts cube.("Dave") # => I don't know you
```

### The `&` Notation
The strategy of creating short helper functions is so common that Elixir provides a shortcut.

```
iex > add_on = &(&1 + 1) # same as add_one = fn (n) -> n + 1 end
```

The `&` operator converts the expression that follows into a function. Inside that expression, the placeholders `&1`, `&2` and so on correspond to the parameters being passed to the function.

`[]` and `{}` are operators in Elixir, literal lists and tuples can also be turn into functions
```
iex > divrem = &{div(&1, &2), rem(&1, &2)}
iex > divrem.(3, 2)
{1, 1}
```

There's a second form of the `&` function capture operator. You can give it the name and arity (number of parameters) of an existing function, and it will return an anonymous function that calls it.

```
iex > len = &Enum.count/1
iex > len.([1, 2, 3, 4])
4
```

This works with name functions we write as well. The `&` shorcute gives us a wonderful way to pass functions to other functions.

```
iex > Enum.map [1, 2, 3, 4], &(&1 + 1)
[2, 3, 4, 5]
```

## Functions Are the Core
Functions are at the very heart of Elixir
