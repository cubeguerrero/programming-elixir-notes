defmodule MyString do
  def calculate(string) do
    _calculate(string, 0)
  end

  defp _calculate([?+ | tail], num), do: num + _calculate(tail, 0)
  defp _calculate([?- | tail], num), do: num - _calculate(tail, 0)
  defp _calculate([?/ | tail], num), do: num / _calculate(tail, 0)
  defp _calculate([?* | tail], num), do: num * _calculate(tail, 0)
  defp _calculate([head | tail], num) when head in ' ' do
    _calculate(tail, num)
  end
  defp _calculate([head | tail], num) when head in '0123456789' do
    _calculate(tail, num * 10 + head - ?0)
  end
  defp _calculate([], num), do: num
  defp _calculate(_, _), do: raise "Invalid operation"
end

IO.inspect MyString.calculate('1 + 2')
IO.inspect MyString.calculate('2 - 1')
IO.inspect MyString.calculate('4 / 2')
IO.inspect MyString.calculate('2 * 3')
