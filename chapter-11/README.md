# Strings and Binaries

## String Literals
Elixir has two kinds of strings:
1. single-quoted
2. double-quoted

Both strings differ in their internal representation but have the following in common:
- can hold UTF-8 encoding
- may contain escape sequences
- allow interpolation using `#{...}` syntax
- Characters that would otherwise have special meaning can be escaped with a backlash
- The support **heredocs**

### Heredocs
The **heredoc** notation, Triple the string delimiter `'''` or `"""` and indent the trailing delimiter to the same marge as your string contents
```
IO.puts "start"
IO.write """
  my
  string
  """
IO.puts "end"
```

will produce
```
start
my
string
end
```

Heredocs are used to add documentation to functions and modules.

### Sigils
A **sigil**, a symbol with magical powers, are an alternative syntax for some literal expressions in Elixir.

A **sigil** starts with a tilde, followed by an upper or lower case letter, some delimited content, and perhaps some options. The delimiters can be `<...>`, `{...}`, `[...]`, `(...)`, `|...|`, `/.../`, `"..."`, and `'...'`

- `~C` -> Character list with no espcaing or interpolation
- `~c` -> Character list, escaped and interpolated just like string in `'...'`
- `~D` -> A `Date` in the format `yyyy-mm-dd`
- `~N` -> A naive `DateTime` in the format `yyyy-mm-dd hh:mm:ss[.ddd]`
- `~R` -> A regular expression with no escaping or interpolation
- `~r` -> A regular expression, escaped and interpolated
- `~S` -> A string with no escaping or interpolation
- `~s` -> A sting, escaped and interpolated just like `"..."`
- `~T` -> A `Time` in the format `hh:mm:ss[.dddd]`
- `~W` -> A list of whitespace-delimited words with no escaping or interpolation
- `~w` -> A list of whitespace-delimited words, with escaping and interpolation.

## The Name "strings"
In Elixir, the convention is that we call only double quoted strings **strings**. The single-quoted form is a character list.

The is important. The single- and double- quoted forms are very different, and libraries that work on strings work only on the double-quoted form.

## Single-Quoted Strings -- Lists of Character Codes
Single-quoted strings are represented as a list of interger values, each value corresponding to a codepoint in the string. This is why we call them **character lists**.

`iex` prints a list of integers as a string if it believes each number in the list is a printable character.

If a character list contains characters Erlang considers nonprintable, you'll see the list representation
```
iex > '∂x/∂y'
[8706, 120, 47, 8706, 121]
```

You can use the notation `?c` to return the integer code for the character `c`. This is useful when employing patterns to extract information from character lists.

## Binaries
The binary type represents a sequence of bits. A binary literal look like `<< term, ...>>`

The simplest term is just a number from 0 to 255. The numbers are stored as successive bytes in the binary.

## Double-Quoted Strings are Binaries
The contents of a double-quoted string are stored as a consecutive sequence of bytes in UTF-8 encoding.

More efficient in terms of memory and certain forms of access, but have two implications.
1. UTF-8 characters can take more than a single byte to represent, the size of binary is not necessarily the length of the string.
2. You need to learn and work with binary syntax alongside the list syntax in your code

### Strings and Elixir Libraries
When Elixir library documentation uses the word **string**, it means double-quoted string.

The `String` module defines functions that work with double-quoted strings.

`String.at(str, offset)`
Returns the grapheme at the given offset (starting at 0). Negative offsets count from the end of the string.
```
iex > String.at("dog", 0) #=> "d"
iex > String.at("dog", -1) #=> "g"
```

`String.capitalize(str)`
Converts `str` to lowercase, and capitalizes the first character
```
iex > String.capitalize("cube") #=> "Cube"
iex > String.capitalize("CAYG") #=> "Cayg"
```

`String.codepoints(str)`
Returns the codepoints in `str`, returns a list
```
iex > String.codepoints("Cube's dog")
["C", "u", "b", "e", "'", "s", " ", "d", "o", "g"]
```

`String.downcase(str)`
Converts `str` to lowercase

`String.duplicate(str, n)`
Returns a string containing `n` copies of `str`

`String.ends_with?(str, suffix | [suffixes])`
Returns `true` if `str` ends with any of the given suffixes.
```
iex > String.end_with? "string", ["elix", "stri", "ring"]) # => true
```

`String.first(str)`
Returns the first grapheme from `str`

`String.graphemes(str)`
Returns the graphemes in the string. Different from `String.codepoints`, which list combining characters separtely.
```
iex > String.codepoints("noël")
["n", "o", "e", "¨", "l"]
iex > String.graphemes("noël")
["n", "o", "ë", "l"]
```

`String.jaro_distance`
Returns a float between 0 and 1 indicating the likely similarity of two strings.
```
iex > String.jaro_distance("jonathan", "jonathon")
0.916666666666
```

`String.last(str)`
Returns the last grapheme from `str`

`String.lengh(str)`
Returns the number of graphemes in `str`

`String.myers_different(str1, str2)`
Returns the list of transformation needed to convert one string to another.
```
iex > String.myers_different("banana", "panama")
[del: "b", ins: "p", eq: "ana", del: "n", ins: "m", eq: "a"]
```

`String.next_codepoint(str)`
Splits `str` into its leading codepoint and the rest, or `nil` if `str` is empty. Maybe used as the basis of an iterator.
```
defmodule MyString do
  def each(str, func), do: _each(String.next_codepoint(str), func)

  defp _each({codepoint, rest}, func) do
    func.(codepoint)
    _each(String.next_codepoint(rest), func)
  end
  defp _each(nil, _), do: []
end
```

`String.next_grapheme(str)`
Splits `str` into its leading grapheme and the rest, `nil` if `str` is emtpy. :no_grapheme on completion

`String.pad_leading(str, new_length, padding \\ 32)`
Returns a new string, at least `new_length` characters long. containing `str` right-justified and padded with `padding`
```
iex > String.pad_leading("cat", 5, ">") #=> ">>cat"
```

`String.pad_trailing(str, new_length, padding \\ " ")`
Returns a new string at least `new_length` characters long, containing `str` left-justified and padded with `padding`.
```
iex > String.pad_trailing("cat", 5) #=> "cat  "
```

`String.printable?(str)`
Returns true if `str` contains only printable characters.

`String.replace(str, pattern, replacement, options \\ [global: true, insert_replaced: nil])`
Returns a string where the `pattern` is replaced with `replacement` in `str` under the control of `options`.

If `:global`, all occurrence of the pattern are replaced, otherwise only the first is replaced.

if `:insert_replaced` is a number, the pattern is inserted into the replacement at that offset. If the option is a list, it is inserted multiple times.
```
iex > String.replace("the cat on the mat", "at", "AT")
"the cAT on the mAT"
```

`String.reverse(str)`
Reverses the graphemes in a string.

`String.slice(str, offset, len)`
Returns a `len` character substring starting at the `offset`. Measured from the end of `str` if `offset` is negative.

`String.split(str, pattern \\ nil, options \\ [global: true])`
Splits `str` into substrings delimted by `pattern`.

If `:global` is false, only one split is performed.

`pattern` can be a string, a regular expression, or `nil`. When `nil` the string is split on whitespace.
```
iex > String.split("   the cat on the mat")
["the", "cat", "on", "the", "mat"]
iex String.split("the cat on the mat", ~r{[ae]})
["th", "c", "t on th", "m", "t"]
```

`String.starts_with?(str, prefix | [prefixes])`
Returns `true` if `str` starts with any of the given prefixes

`String.trim(str)`
Trims leading and trailing whitespace from `str`.
```
iex > String.trim "\t  Hello    \r\n"
"Hello"
```

`String.trim(str, character)`
Trims leading and trailing instances of `character` from `str`

`String.trim_leadning(str)`
Trims leading whitespace from `str`

`String.trim_leading(str, character)`
Trims leading copies of `character` from `str`

`String.trim_trailing(str)`
Trims trailing whitespace from `str`.

`String.trim_trailing(str, character)`
Trims trailing occurrences of `character` from `str`

`String.upcase(str)`
Returns `str` with all uppercase letters.
```
iex > String.upcase("cube")
"CUBE"
```

`String.valid?(str)`
Returns `true` if `str` is a single-character string containing a valid codepoint

## Binaries and Pattern Matching
The first rule of binaries: **If in doubt, specift the type of each field.** Available types are `binary`, `bits`, `bitstring`, `bytes`, `float`, `integer`, `utf8`, `uft16`, and `utf32`

You can also add qualifies:
- `size(n)`: The size in bits of the field.
- `signed` or `unsigned`: For integer fields, should it be interpreted as signed?
- endianness: `big`, `little`, or `native`

Use hyphens to separate multiple attributes for a field:
```
<< length::unsigned-integer-size(12), flags::bitstring-size(4) >> = data
```

The most common use of all these rules is to process UTF-8 strings.

### String Processing with Binaries
When we process strings, we use patterns to split the head from the rest of the string. We have to specify the type of the head (UTF-8), and make sure the tail remains binary

```
defmoudle Utf8 do
  def each(str, func) when is_binary(str), do: _each(str, func)

  defp _each(<<head::utf8, tail::binary>>, func) do
    func.(head)
    _each(tail, func)
  end
  defp _each(<<>>, func), do: []
end
```
