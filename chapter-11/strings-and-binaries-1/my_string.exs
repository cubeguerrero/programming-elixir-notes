defmodule MyString do
  def printable?([]), do: true
  def printable?([head | _tail]) when head < 32 or head > 126, do: false
  def printable?([_head | tail]), do: printable?(tail)
end
