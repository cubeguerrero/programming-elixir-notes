defmodule MyList do
  def ceasar([], _), do: []
  def ceasar([head | tail], n) when head + n > ?z do
    [head + n - 26 | ceasar(tail, n)]
  end
  def ceasar([head | tail], n) do
    [head + n | ceasar(tail, n)]
  end
end

IO.puts MyList.ceasar('ryvkve', 13)
