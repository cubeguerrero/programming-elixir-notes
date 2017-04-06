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
Various dictionary types let us associate keys with values. But those values can themselves be dictionaries.
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

### Nested Accessors and Nonstructs
You can supply the keys as atoms when using the nested accessor functions
```
iex > report = %{owner: %{name: "Dave", company: "Pragmatic"}, severity: 1}
iex > put_in(report[:owner][:company], "PragProg")
%{owner: %{name: "Dave", company: "PragProg"}, severity: 1}
iex > update_in(report[:owner][:name], &("Mr. " + &1))
%{owner: %{name: "Mr. Dave", company: "Pragmatic", severity: 1}
```

### Dynamic (Runtime) Nested Accessors
The nested accessors used so far are **macros**, which means they operate at compile time. As a result, they have limitations:
- The number of keys you pass a particular call is static
- You can't pass the set of keys as parameters between functions

To overcome these limitations, the functions `get_in`, `put_in`, `update_in`, and `get_and_update_in` can take a **list of keys as a separate parameter**. Changing them from macros to function calls, making them dynamic.

| Function Name       | Macro         | Function             |
| ------------------- | ------------- | -------------------- |
| `get_in`            | No            | (dict, keys)         |
| `put_in`            | (path, value) | (dict, keys, values) |
| `updated_in`        | (path, fn)    | (dict, keys, fn)     |
| `get_and_update_in` | (path, fn)    | (dict, keys, fn)     |

Example:
```
nested = %{
  buttercup: %{
    actor: %{
      first: "Robin",
      last: "Wright",
    },
    role: "princess"
  },
  westley: %{
    actor: %{
      first: "Cary"
      last: "Ewles" # typo
    },
    role: "farm boy"
  }
}

get_in(nested, [:buttercup]) # => %{actor: ..., role: "princess"}
get_in(nested, [:buttercup, :actor]) #=> %{first: "Robin", ...}
get_in(nested, [:buttercup, :actor, :first]) #=> "Robin"
put_in(nested, [:buttercup, :actor, :last], "Elwes")
```

The dynamic versions of `get_in` and `get_and_update_in` supports keys that are functions. They will invoke the function to return the corresponding values.
```
authors = [
  %{name: "Jose", language: "Elixir"},
  %{name: "Matz", language: "Ruby"},
  %{name: "Larry", language: "Perl"}
]

languages_with_an_r = fn (:get, collection, next_fn) ->
  for row <- collection do
    if String.contains?(row.language, "r") do
      next_fn.(row)
    end
  end
end

get_in(authors, [languages_with_an_r, :name]) #=> ["Jose", nil, "Larry"]
```

### The `Access` Module
The `Access` module provides a number of predefined functions to use as paramters to `get_in` and `get_and_update_in`

1. `Access.all`
  - only works on lists
  - returns all elements in the list
  ```
  cast = [
    %{
      character: "Buttercup",
      actor: %{
        first: "Robin",
        last: "Wright"
      },
      role: "princess"
    },
    %{
      character: "Westley",
      actor: %{
        first: "Cary",
        last: "Elwes"
      },
      role: "farm boy"
    }
  ]

  get_in(cast, [Access.all(), :character]) #=> ["Buttercup", "Westley"]
  ```

2. `Access.at`
  - only works on lists
  - returns the n<sup>th</sup> element (counting from zero)
  ```
  get_in(cast, [Access.at(1), :role]) #=> "farm boy"
  ```

3. `Access.elem`
  - works on tuples
  - returns the element of a tuple
  - accepts an Integer
  ```
  cast = [
    %{
      character: "Buttercup"
      actor: {"Robin", "Wright"},
      role: "princess"
    }
  ]

  get_in(cast, [Access.all(), :actory, Access.elem(1)]) #=> "Wright"
  ```

4. `Access.key` and `Access.key!`
  - work on dictionary types (maps and structs)
  - get the value base on the given key
  ```
  cast = %{
    buttercup: %{
      actor: {"Robin, "Wright"},
      role: "princess"
    },
    westley: %{
      actor: {"Carey", "Elwes"},
      role: "farm boy"
    }
  }

  get_in(cast, [Access.key(:westley), :actor, Access.elem(1)]) #=> "Elwes"
  ```

5. `Access.pop`
  - lets you remove the entry with a given key from a map or keyword list.
  - returns a tuple, where the first element is the value of the popped key and the second element is the updated container.
  - has nothing to do with the `pop` stack operator.
  ```
  Access.pop(%{name: "Elixir", creator: "Valim"}, :name)
  #=> {"Elixir", %{creator: "Valim"}}
  Access.pop([name: "Elixir", creator: "Valim"], :name)
  #=> {"Elixir", [creator: "Valim"]}
  ```

## Sets
Sets are implemented using the module `MapSet`

From https://hexdocs.pm/elixir/MapSet.html
`MapSet` is the "go to" set data structure in Elixir. A **set** can contain any kind of elements and the elements don't have to be of the same type.

By definition, sets can't contain duplicate elements, when inserting an element in a set where it's already present, the insertion is simply a no-op.

```
set1 = 1..5 |> Enum.into(MapSet.new)
set2 = 3..8 |> Enum.into(MapSet.new)

MapSet.member? set1, 3 #=> true
MapSet.union set1, set2 #=> #MapSet<[1, 2, 3, 4, 5, 6, 7, 8]>
MapSet.difference set1, set2 #=> #MapSet<[1, 2]>
MapSet.intersection set1, set2 #=> #MapSet<[3, 4, 5]>
```
