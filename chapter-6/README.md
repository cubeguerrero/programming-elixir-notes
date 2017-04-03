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

## Private Functions
`defp` macro defines a private function -- one that can only be called within the module that declares it.

You can define private functions with multiple heads, but you cann have some heads private and others public.

## The Amazing Pipe Operator: `|>`
The `|>` operator takes the result of the expression to its left and inserts it as the first parameter of the function invocation to its right.

You should always use parentheses around function parameters in pipelines.

The key aspect of the pipe operator is that it lets you write code that pretty musch follow your specifications.

- Get the customer list
- Generate a list of their orders
- Calculate tax on the orders
- Prepare the filing

Would be equivalent to:
```
DB.find_customers
  |> Orders.for_customers
  |> sales_tax(2016)
  |> prepare_filing
```

## Modules
Modules provide namespaces for things you define such as functions, macros, structs, protocols, and other module.

To reference a function defined in a module (from outside that module), prefix the function call with the module's name

```
defmodule SomeModule do
  def greet() do
    "Hello World"
  end
end

SomeModule.greet()
```

You can also created nested modules, to access a function in a nested module from the outside scope, prefix it with all the module names. To access it within the containing module, use either the fully qualified name or just the inner module name as a prefix.

All modules are defined at the top level. Elixir simple prepends the oute, Elixir just r module name to the inner module name and putting a dot between the two.

### Directive for Modules
Elixir has three directives that simplify working with modules.

1. `import`
  Brings a module's functions and/or macros into the current scope. It can cut down the clutter in your source by eliminating the need to repeat the module name time and again.

  The full syntax is
  ```
  import Module [, only: | except: ]
  ```

  The optional second paramters lets you control whcih functions or macros are imported. Write `only:` or `except:`, followed by a list of `name: arity` pairs

  It is a good idea to use `import` in the smallest possible enclosing scope and to use `only:` to import just the functions you need.

  You can also give `only:` the atoms `:functions` or `:macros` which will import only functions or macros, respectively.

2. `alias`
  The `alias` directive creates and alias for a module. Example
  ```
  defmodule Example do
    alias Some.Other.ModuleName, as: ModuleName
  end
  ```

  The `as:` parameter defaults to the last part of the module name. So we could have written it as
  ```
  defmodule Example do
    alias Some.Other.ModuleName
  end
  ```

  You can alias multiple modules (assuming the are part of the same namespace) by doing:
  ```
  alias Some.Other.{ AModule, BModule }
  ```

3. `require`
  Use `require` if you want any macros defined in module. It ensures that the macro definitions are available when your code is compiled.

All directives are **lexically scoped** -- it starts at the point of the directive is encountered, and stops at the end of the enclosing scope.

## Module Attributes
Elxir modules can have associated metadata called **attributes**. You can access these attributes by prefixing the name with an `@` sign. You give an attribute value using the syntax:
```
@name value
```

You can's set an attribute inside a function definition, but you can access attributes inside functions.

You can set the same attribute multiple times in a module. The value you will see will be the value in effect when the function is defined.
```
defmodule Example
  @attr "cube"
  def func, do: @attr
  @attr "cuthbert"
  def func2, do: @attr
end
```

Attributes are not variables! Use them for configuration and metadata only.

## Module Names: Elixir, Erlang, and Atoms
Internally, module names are just atoms. When you write anem starting with an uppercase, such as `IO`, Elixir converts it internally into an atom called `Elixir.IO`
```
iex > is_atom IO
true
iex > to_string IO
"Elixir.IO"
iex > :"Elixir.IO" === IO
```

## Calling a Function in an Erlang Library
You can all Erlang modules, i.e. `timer` module in Erlang, in Elixir by writing it as `:timer`. if you want to refer a function within that Erlang module, you could write it as `:timer.function_name`.

## Finding Libraries
1. Built-in ones that are documented in the Elixir website.
2. Libraries listed in (http://hex.pm)[http://hex.pm]
3. Github **search for elixir**

If that fails
4. search for a built-in Erlang library
5. or, if you find something written in Erlang, you'll be able to use it in your project.

NOTE:
Erlang libaries follow Erlang conventions, Variables start with uppercase latters, and identifiers starting with a lowercase letter are atoms.

