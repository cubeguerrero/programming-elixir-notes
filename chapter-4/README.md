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
