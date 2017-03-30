# Notes

Immutable data is known data. In Elixir, all values are immutable. Once a variable reference a list such as `[1, 2, 3]`, you know it will always reference those same values (until you rebind the variable).

In a functional language, we *always* transform data. We never modify if in place. The syntax reminds us of this every time we use it.
```
iex > name = "elixir"
"elixir"
iex > cap_name = String.capitalize(name)
"Elixir"
iex > name
"elixir"
```
