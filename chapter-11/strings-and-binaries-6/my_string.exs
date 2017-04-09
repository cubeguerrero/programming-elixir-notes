defmodule MyString do
  def capitalize_sentences(str) do
    str
    |> String.split(". ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(". ")
  end
end

IO.inspect MyString.capitalize_sentences("oh. a DOG. woof. ")
