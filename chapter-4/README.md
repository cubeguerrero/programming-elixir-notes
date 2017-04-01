# Notes

Elixir's build-in types are
- Value types:
  - Arbitrary-sized integers
  - Floating-point numbers
  - Atoms
  - Ranges
  - Regular expressions
- System types:
  - PIDs and ports
  - References
- Collection types:
  - Tuples
  - Lists
  - Maps
  - Binaries

Functions are a type too.

## Value types
### Integers
Integer literals can be written as decimal (`1234`), hexadecimal (`0xcafe`), octal (`0o765`), and binary (`0b1010`)

Decimal numbers may contain underscores - used to separate groups of three digits when writing large numbers.
```
iex > 1_000_000
1000000
```

There is no fixed limit on the size of integers - their internal representation grows to fit their magnitude.

### Floating-Point Numbers
Floating-point numbers are written using a decimal point. **There must be at least one digit before and after the decimal point**.

Floatins are IEEE 754 double precision, giving them about 16 digits of accuracy and a maximum exponent of around 10^308

```
1.0 0.2456 0314159e1 314159.0e-5
```

### Atoms
Atoms are constants that represent something's name. We write them using a leading colon (`:`), which can be followe by an atom word or an Elixir operator

An atom word is a sequence of letters, digits, underscores, and at signs (`@`). It may end with an exclamation point or a question mark. You can also create atoms contain arbitrary characters by enclosing the characters following the colon in double quotes.

```
:fred :is_binary? :var@2 :<> :=== :"func/3" :"long john silver"
```

An atom's name is its value. Two atoms with the same name will always compare as being equal.o

### Ranges
Ranges are represented as *start..end*, where *start* and *end* are integers
```
1..10
```

### Regular Expressions
Elixir has regular-expression literals, written as `~r{regexp}` or `~r{regexp}opts`.

You can specify one or more single-character options following a regexp literal.

1. `f` - Force pattern to start to match on the first line of a multiline string.
2. `g` - Support named groups
3. `i` - Make matches case insensitive
4. `m` - If the string to be matched contains multiple lines, `^` and `$` match the start and end of these lines. `\A` and `\z` continue to match the beginning or end of the string.
5. `s` - Allow `.` to match any newline characters
6. `U` - Normally modifiers like `*` and `+` are greedy, matching as much as possible. This modifier makes them *ungreedy*, matching as little as possible.
7. `u` - Enable unicode-specific patterns like \p
8. `x` - Enable extended mode - ignore whitespace and comments (# to end of line).

You can manipulate regex with the `Regex` module:
```
iex > Regex.run(~r{[aeiou]}, "caterpillar")
["a"]
iex > Regex.scan(~r{[aeiou]}, "caterpillar")
[["a"], ["e"], ["i"], ["a"]]
iex > Regex.split(~r{[aeiou]}, "caterpillar")
["c", "t", "rp", "ll", "r"]
iex > Regex.replace(~r{[aeiou]}, "caterpillar", "*")
"c*t*rp*ll*r"
```

## System Types
These types reflect resources in the underlying Erlang VM.

### PIDs and Ports
A `PID` is a reference to a local or remote process. The PID of the current process is available by calling `self`

A `port` is a reference to a resource (typically external to the application) that you'll be reading or writing.

### References
The function `make_ref` creates a globally unique reference; no other reference will be equal to it.


## Collection Types
Elixir collections can hold values of any type (including other collections)

### Tuples
A **tuple** is an order collection of values. You write a tuple between braces, separating the elements with commas.
```
{1, 2} {:ok, 42, "next"} {:error, :enoent}
```

A typical Elixir tuplice has two to four elements - any more and you'll probably want to look at `maps` or `structs`.

Use tuples in pattern matching:
```
iex > {status, count, action} = {:ok, 42, "next"}
{:ok, 42, "next"}
iex > status
:ok
iex > count
42
iex > action
"next"
```

It is common for functions to return a tuple where the first element is the atom `:ok` if there were no errors.

For example:
```
iex > # Assuming that we have a file called `mix.exs`
iex > {status, file} = File.open("mix.exs")
{:ok, #PID<0.39.0>}
```

### Lists
Elixir `lists` are effectively a *linked data structure*. A list may either be empty or consist of a head and tail. The thead contains a value and tail is itself a list.

Lists are easy to traverse linearly, but they are expensive to access in random order (think O(n), to get the n^th element, you have to scan through `n - 1` previous elements)

It is always cheap to get the head of the list and to extract the tail of a list.

Since lists are also immutable, if we want to remove the head from a list, leaving just the tail, we never have to copy the list. Instead we can return a pointer to the tail.

Some operations on lists:
```
iex> [1, 2, 3] ++ [4, 5, 6] # concatenation
[1, 2, 3, 4, 5, 6]
iex > [1, 2, 3, 4] -- [2, 4] # difference
[1, 3]
iex > 1 in [1, 2, 3, 4] # membership
true
iex > "wombat" in [1, 2, 3, 4]
false
```

#### Keyword Lists
Is a simple list of key/value pairs. Elixir gives us a shortcut:
`[name: "Dave", city: "Dallas", likes: "Programming"]`
Elixir converts it into a list of two-value tuples, (effectively):
`[{:name, "Dave"}, {:city, "Dallas"}, {:likes, "Programming"}]`

Elixir allows us to leave off the square brackets if a keyword list is the last argument in a function call:
```
DB.save record, [{:use_transaction, true}, {:logging, "HIGH"}]
# can be written as
DB.save record, use_transaction: true, logging: "HIGH"
```

We can also leave off the brackets if a keyword list appears as the last item in any context where a list of values is expected:
```
iex > [1, fred: 1, dave: 2]
[1, {:fred, 1}, {:dave, 2}]
iex > {1, fred: 1, dave: 2}
{1, [fred: 1, dave: 2]}
```

### Maps
A `map` is a collection of key/value pairs. `%{key => value, key => value}`

Examples of maps:
```
iex > states = %{ "AL" => "Alabama", "WI" => "Wisconsin"}
iex > responses = %{{:error, :enoent} => :fatal, {:error, :busy} => :retry}
iex > colors = %{red: 0xff0000, green: 0x00ff00, blue: 0x0000ff}
```

Typically all the keys in a map are the same type, but is not required.
```
iex > %{"one" => 1, :two => 2, {1, 1, 1} = 3}
```

You can also use expressions for keys in map literals:
```
iex > name = "Jose Valim"
iex > %{String.downcase(name) => name}
%{"jose valim" => "Jose Valime"}
```

#### Maps vs Keyword Lists
Maps allow only one entry for a particular key, whereas keyword lists allow the key to be repeated.
Maps are efficient (particularly as they grow), and they can be used in Elixir's pattern matching.

In general, use keywords lists for things such as command-line parameters and passing around options, and use maps when you want an associative array.

#### Accessing a Map
You extract values from a map using the key. The square-bracket syntax works with all maps:
```
iex > states = %{"AL" => "Alabama", "WI" => "Wisconsin"}
iex > states["AL"]
"Alabama"
iex > states["TX"]
nil
```

If the keys are atoms, you can also use a dot notation:
```
iex > colors = %{red: 0xff0000, green: 0x00ff00, blue: 0x0000ff}
iex > colors[:red]
iex > colors.green
```

You'll get a `KeyError` if there's no matching key when you use the dot notation.

### Binaries
Elixir alllows you to work with binary data type. Binary literals are enclosed between `<<` and `>>`.

The basic syntax packs successive integers:
```
iex > bin = <<1, 2>>
<<1, 2>>
iex > byte_size bin
2
```

You can add modifiers to control the type and size of each individual field.
```
iex > bin = <<3 :: size(2), 5 :: size(4), 1 :: size(2)>>
<<213>>
iex > :io.format("~-8.2b~n", :binary.bin_to_list(bin))
11010101
:ok
iex > byte_size(bin)
1
```

Binaries are important because Elixir uses them to represent UTF strings

### Dates and Times
Elixir (v 1.3) added a calendar module and four new date and time related types. But they are more like data holders -- look for third-party libraries to add functionality.

The `Calendar` module represents the rules used to manipulate dates.

The `Date` type holds a year, month, day, and a reference to the ruling calendar.
```
iex > d1 = Date.new(2016, 12, 25)
{:ok, ~D[2016-12-25]}
iex > {:ok, d1} = Date.new(2016, 12, 25)
{:ok, ~D[2016-12-15]}
iex > d2 = ~D[2016-12-15]
iex > d1 == d2
true
```

The `Time` type contains an hour, minute, second, and fractions of a second. The fraction is stored as a tuple containing microseconds and the number of significant digits.
```
iex > t1 = Time.new(12, 34, 56)
{:ok, ~T[12:34:56]
iex > t2 = ~T[12:34:56.78]
~T[12:34:56.78]
iex > t1 == t2
false
iex > inspect t2, structs: false
"{:ok, %{__struct__: Time, hour: 12, microsecond: {780_000, 2}, minute: 34, second: 56}}
```

There are two date/time types, `DateTime` and `NaiveDateTime`. The naive version contains just a date and a time; `DateTime` adds the ability to associate a time zone. The `~N[...]` sigil construct `NaiveDateTime` structs.

### Names, Source files, Conventions, Operators and So On
Elixir identifiers consist of upper- and lowercase ASCII characters, digits, and underscores. They may end with a question or an exclamation mark.

Module, record, protocol, and behavior names start with an uppercase letter and are BumpyCase.

All other identifiers start with a lowercase letter or an underscore, and by convention use underscores between worrds. If the first character is an underscore, Elixir doesn't report a warning if the varible is unused in a pattern match or function parameter list.

Source files are written in UFT-8, but identifies may use only ASCII.

By convention, source files use two-character indentation for nesting, and the use spaces

Comments start with a hash sign (`#`) and run to the end of the line.

#### Truth
Elixir has thre special values related to Boolean operations: `true`, `false` and `nil`. `nil` is treated as false in Boolean contexts

All three values are aliases for atoms of the same name.
```
iex > :true
true
iex > :false
false
iex > :nil
nil
```

#### Operators
*Comparison Operators*
```
a === b # strict equality (1 === 1.0 is false)
a !== b # strict inequality (1 !== 1.0 is true)
a == b  # value equality (1 == 1.0 is true)
a != b  # value inequality (1 != 1.0 is false)
a > b
a >= b
a < b
a <= b
```

if the types are the same or are compatible (for example, `3 > ` and `3.0 < 5`), the comparison uses natural ordering. Otherwise comaparison is based on type according to this rule

`number < atom < reference < function < port < pid < tuple < map < list < binary`

*Boolean operators*
expects `true` or `false` as their first argument

```
a or b  # true if a is true, otherwise b
a and b # false if a is false, otherwise b
not a   # false if a is true, true otherwise
```

*Relaxed Boolean operators*
takes arguments of any type. Any value apart from `nil` and `false` is interpreted as true
```
a || b # a if a is truthy, otherwise b
a && b # b if a is truthy, otherwise a
!a     # false if a is truth, otherwise true
```

*Arithmetic operators*
`+ - * / div rem`

Integer division yield floating point result. Use `div(a, b)` to get an intger
```
iex > 10 / 2
5.0
iex > div(10, 2)
5
```

`rem` is the *remainder operator*. It is called as a function `rem(11, 3)`. It differs from normal modulo operations in that the result will have the same sign as the function's first argument

*Join operators*
```
binary1 <> binary2 # concatenates two binaries (strings are also binaries)
list1 ++ list2     # concatenates two lists
list1 -- list2     # removes elements of list2 from a copy of list1
```

*The `in` operator*
```
a in enum  # tests if a is included in enum (i.e. list, range, or a map)
           # For maps, a should be a {key, value} tuple
```

#### Variable Scope
Elixir is lexically scoped. The basic unit of scoping is the function body. Variables defined in a function (including its parameters) are local to that function.

Modules define a scope for local variables, but these are only accessible at the top level of that module, and not in functions defined in the module.

#### The `with` Expression
The `with` expression serves two purpose:
1. it allows you to define a local scope for variables.
2. it gives you some control over pattern matching failures.

```
content = "Now is the time"

lp = with {:ok, file} = File.open("/etc/passwd"),
          content     = IO.read(file, :all),
          :ok         = File.close(file),
          [_, uid, gid] = Regex.run(~r{_lp:.*?:(\d+):(\d+)}, content)
     do
          "Group: #{gid}, User: #{uid}"
     end

IO.puts lp      #=> Group: 26, User: 26
IO.puts content #=> Now is the time
```

The `with` experssion let us work with what are effectively temporary variables. The value of the `with` expression is the value of its `do` parameter.

#### `with` and Pattern Matching
Using the `<-` operator instead of `=` in a `with` expression, it performs a match, but if if fails it returns the value that couldn't be matched.

```
iex > with [a | _] <- [1, 2, 3], do: a
1
iex > with [a | _] <- nil, do: a
nil
```

##### A Minor Gotcha
Underneath the covers, `with` is treated by Elixir as if it were a call to a funtion or macro.

You cannot do this:
```
mean = with
          count = Enum.count(values),
          sum   = Enum.sum(values)
       do
          sum/count
       end
```

Instead, align the first parameter to the `with` keyword
```
mean = with count = Enum.count(values),
            sum   = Enum.sum(values)
       do
         sum/count
       end
```

Or use parentheses
```
mean = with(
        count = Enum.count(values),
        sum   = Enum.sum(values)
       do
         sum/count
       end)
```

You can also use the shortcut
```
mean = with count = Enum.count(values)
            sum   = Enum.sum(values)
       do: sum/count
```
