# Problem
Write a function that takes a single-quoted string of the form **number** [+ - * /] **number** and returns the result of the calculation. The individual numbers do not have leading plus or minus signs.
```
calculate('123 + 27') #= 150
```

# Solution
```
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
```
