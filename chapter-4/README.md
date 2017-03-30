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
