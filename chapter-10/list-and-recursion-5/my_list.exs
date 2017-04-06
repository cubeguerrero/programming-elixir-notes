defmodule MyList do
  def all?([], _func), do: true
  def all?([head | tail], func), do: func.(head) && all?(tail, func)

  def each([], _func), do: []
  def each([head | tail], func), do: [func.(head) | each(tail, func)]

  def filter([], _func), do: []
  def filter([head | tail], func) do
    if func.(head) do
      [head | filter(tail, func)]
    else
      filter(tail, func)
    end
  end

  def split(list, count) when count < 0, do: split(list, _count(list) + count)
  def split(list, count), do: _split(list, count, [])
  defp _split(list, 0, result), do: {result, list}
  defp _split([], _, result), do: _split([], 0, result)
  defp _split([head | tail], count, result), do: _split(tail, count - 1, result ++ [head])

  # Wrong when passed negative values.
  def take(list, count) when count < 0, do: take(reverse(list), count * -1)
  def take(list, count), do: _take(list, count, [])
  defp _take(_list, 0, result), do: result
  defp _take([], _, result), do: _take([], 0, result)
  defp _take([head | tail], count, result), do: _take(tail, count - 1, result ++ [head])

  defp _count([]), do: 0
  defp _count([_ | tail]), do: 1 + _count(tail)

  def reverse(list), do: _reverse(list, [])
  defp _reverse([], result), do: result
  defp _reverse([head | tail], result), do: _reverse(tail, [head | result])
end

require Integer
IO.puts MyList.all?([1, 2, 3, 4, 5], &(&1 < 4)) #=> false
IO.puts MyList.all?([1, 2, 3, 4, 5], &(&1 < 6)) #=> true
IO.inspect MyList.each([1, 2, 3, 4, 5], &(&1 * &1)) #=> [1, 4, 9, 16, 25]
IO.inspect MyList.filter([1, 2, 3, 4, 5], &Integer.is_even/1) #=> [2, 4]
IO.inspect MyList.split([1, 2, 3, 4, 5], 3)
IO.inspect MyList.split([1, 2, 3, 4, 5], 6)
IO.inspect MyList.split([1, 2, 3, 4, 5], -3)
IO.inspect MyList.take([1, 2, 3, 4, 5], 3)
IO.inspect MyList.take([1, 2, 3, 4, 5], 6)
IO.inspect MyList.take([1, 2, 3, 4, 5], -3)
