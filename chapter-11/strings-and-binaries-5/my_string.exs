defmodule MyString do
  def center(list_of_words) do
    max = get_max(list_of_words)
    _center(list_of_words, max)
  end

  defp _center([], _), do: :ok
  defp _center([head | tail], max) do
    str_length = String.length(head)
    needed = div(max - str_length, 2)
    new_str = head |> String.pad_leading(str_length + needed)
    IO.puts new_str
    _center(tail, max)
  end

  defp get_max(list_of_words) do
    list_of_words
      |> Enum.map(&String.length/1)
      |> Enum.max
  end
end
