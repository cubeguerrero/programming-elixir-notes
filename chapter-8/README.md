# Maps, Keyword Lists, Sets, and Structs

A *dictionary* is a data type that associates keys with values.

## How to Chosse Between Maps and Keyword Lists?
Ask these questions
1. Do I want to pattern-match against the contents (i.e. matching a dictionary that has a key of `:name` somewhere in it)?
  If yes, use a **map**

2. Will I want more that one entry with the same key?
  If yes, you'll have to use the `Keyword` module, **keyword lists**

3. Do I need to guarantee that elements are ordered?
  If yes, use **keyword lists**

4. And, if you've reached this point:
  Use a **map**

## Keyword Lists
Keyword lists are typically used in the context of options passed to functions.
```
defmodule Canvas do
  @defaults [fg: "black", bg: "white", font: "Merriweather"]

  def draw_text(text, options \\ []) do
    options = Keyword.merge(@defaults, options)
    IO.puts "Drawing text #{inspect(text)}"
    IO.puts "Foreground: #{options[:fg]}"
    IO.puts "Background: #{Keyword.get(options, :bg)}"
    IO.puts "Font: #{Keyword.get(options, :font)}"
    IO.puts "Pattern: #{Keyword.get(options, :pattern, "solid")}"
    IO.puts "Style: #{inspect Keyword.get_values(options, :style)}"
  end
end
```

To access a value, you can use the access operator `kwlist[key]`. Functions defined in the `Keyword` and `Enum` module can also be used with keyword list.

## Maps
Maps are the go-to key/value data structure in Elixir. Good performance at all sizes.

`Map` API:
```
iex > map = %{name: "Dave", likes: "Programming", where: "Dallas"}
iex > Map.keys(map)
[:name, :likes, :where]
iex > Map.values map
["Dave", "Programming", "Dallas"]
iex > map[:name]
"Dave"
iex > map.name
"Dave"
iex > map1 = Map.drop map, [:where, :likes]
%{name: "Dave"}
iex > map2 = Map.put map :also_likes, "Ruby"
%{also_likes: "Ruby", likes: "Programming", name: "Dave", where: "Dallas"}
iex > Map.has_key? map1, :where
false
iex > {value, updated_map} = Map.pop map2, :also_likes
{"Ruby", %{likes: "Programming", name: "Dave", where: "Dallas"}}
iex > Map.equal? map, updated_map
true
```

## Pattern Matching and Updating Maps
In maps, we often ask "Do you have the following keys (and maybe values)?". I.e.
```
person = %{name: "Dave", height: 1.88}
```

We can use pattern matching (with the question in mind) Do you an entry with key of `:name`
```
iex > %{name: a_name} = person
iex > a_name
"Dave"
```

Do you have keys `:name` and `:height`?
```
iex > %{name: _, height: _} = person # => pattern match will succeed
```

If we pattern match with a key that does not exist, it will fail
```
iex > %{name: _, weight: _} = person
** (Match Error)
```

We can use this further in the next example (using Elixir's `for` statement)
```
people = [
  %{name: "Grumpy", height: 1.24},
  %{name: "Dave", height: 1.88},
  %{name: "Dopey", height: 1.32},
  %{name: "Shaquille", height: 2.16},
  %{name: "Sneezy", height: 1.28}
]

IO.inspect(for person = %{height: height} <- people, height > 1.5, do: person)
```

### Pattern Matching Can't Bind Keys
You can't bind a value to a key during pattern matching. You can do:
```
iex > %{2 => state} = %{1 => :ok, 2 => :error}
iex > state #=> :error
```

But not this:
```
iex > %{item => :ok} = %{1 => :ok, 2 => :error}
** (CompileError)
```

### Pattern Matching Can Match Variable Keys
We can use the **pin operator** (`^`) to use variables in pattern matching for keys
```
iex > data = %{name: "Dave", state: "TX", likes: "Elixir"}
iex > for key <- [:name, :likes] do
... >   %{^key => value} = data
... >   value
... > end
```

## Updating a Map
Maps let us add new key/value entries and update existing entries without traversing the whole structure. The result of the update is a new map (Everything is immutable)

Simplest syntax to update a map:
```
new_map %{old_map | key => value, ...}
```
To insert a new key into a map, use the `Map.put_new/3` function.

---
Map.put vs Map.put_new

Both function does the same thing except when updating a existing key. Map.put will update the value of the existing key, while Map.put_new will not.

```
iex > map = %{a: 1, b: 2}
iex > Map.put map, :c, 3
%{a: 1, b: 2, c: 3}
iex > Map.put_new map, :c, 3
%{a: 1, b: 2, c: 3}
iex > Map.put map, :a, 3
%{a: 3, b: 2}
iex > Map.put_new map, :a, 3
%{a: 1, b: 2}
```

## Structs
Structs are a "typed" map -- a map that has a fixed set of fields and default values for those fields, and those you can pattern-match by type as well as content

It is just a module that wraps a limited form of map. It's limited becuase the keys must be atoms and because these maps don't have `Dict` capabilities.

To define a **struct**, start with a module and use the `defstruct` macro to define the struct's members.
```
# file name: defstruct.exs
# to be used in the following examples
defmodule Subscriber do
  defstruct name: "", paid: false, over_18: true
end
```

The syntax for creating a struct is the same as the syntax for creating a map -- you simply add the module name between the `%` and the `{`

```
$ iex defstruct.exs
iex > s1 = %Subscriber{}
%Subscriber{name: "", over_18: true, paid: false}
iex > s2 = %Subscriber{name: "Dave"}
%Subscriber{name: "Dave", over_18: true, paid: false}
```

You access the field in a struct using the dot notation or pattern matching (same as map)

```
iex > s2.name
"Dave"
iex > %Subscriber{name: a_name} = s2
%Subscriber{name: "Dave", over_18: true, paid: false}
iex > a_name
"Dave"
```

To update a struct
```
iex > s3 = %Subscriber{ s2 | name: "Francis"}
%Subscriber{name: "Francis", over_18: true, paid: false}
```

Structs are wrapped in a module so that you can add struct-specific behavior
```
defmodule Attendee do
  defstruct name: "", paid: false, over_18: true

  def may_attend_after_party(attendee = %Attendee{}) do
    attendee.paid && attendee.over_18
  end

  def print_vip_badge(%Attendee{name: name}) when name != "" do
    IO.puts "badge for #{name}"
  end
end
```

Structs play a large role when implementing polymorphism.

## Nested Dictionary Structures
Various dictionary tupes let us associate keys with values. But those values can themselves be dictionaries.
```
defmodule Customer do
  defstruct name: "", company: ""
end

defmodule BugReport do
  defstruct owner: %Customer{}, details: "", severty: 1
end

report = %BugReport{owner: %Customer{name: "Dave", company: "Pragmatic"}, details: "broken"}
```

If we want to update the nested struct:
```
report = %BugReport{report | owner: %Customer{report.owner | company: "PragProg"}}
```

This way is verbose, hard to read, and error prone.

Elixir has a set of nested dictionary-access functions. We can use `put_in`, to set a value in a nested structure:
```
put_in(report.owner.company, "PragProg")
```

This is simple a macro that generates the first solution.

The `update_in` function lets us apply a function to a value in a structure
```
update_in(report.owner.name, &("Mr. " <> &1)) # => updates "Dave" to "Mr. Dave"
```

The other two nested access functions are `get_in` and `get_and_update_in`.
