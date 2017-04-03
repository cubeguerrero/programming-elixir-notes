# Problem
Find library functions to do the following, and then use each in iex.

1. Convert a float to a string with 2 decimal digits (Erlang) (Many solutions)
  ```
  :io_lib.format("~.2f", [10.25689])
  :erlang.float_to_list(10.256789, [{:decimals, 2}])
  ```

2. Get the value of an operating-system environment variable (Elixir)
  ```
  System.get_env("SOME_VARIABLE")
  ```

3. Return the extension component of a file name (i.e. `.exs` if give `dave/text.exs`). (Elixir)
  ```
  Path.extname(path)
  ```

4. Return the process's current working directory. (Elixir)
  ```
  pwd()
  ```

5. Convert a string containt JSON into Elixir data structures
  use the `json` library https://github.com/cblage/elixir-json
  ```
  JSON.decode(json_string)
  ```

6. Execute a command in your operating system's shell
  ```
  System.cmd("whoami", [])
  ```
