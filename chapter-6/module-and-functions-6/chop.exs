defmodule Chop do
  def guess(actual, low.._high) when actual <= low, do: IO.puts "guess out of range"
  def guess(actual, _low..high) when actual >= high, do: IO.puts "guess out of range"
  def guess(actual, low..high) do
    initial_guess = div(low + high, 2)
    IO.puts "Is it #{initial_guess}"
    guesser(actual, initial_guess, low..high)
  end

  def guesser(actual, sys_guess, _) when actual == sys_guess, do: IO.puts sys_guess
  def guesser(actual, sys_guess, _low..high) when actual > sys_guess do
    next_guess = div(sys_guess + high, 2)
    IO.puts "Is it #{next_guess}"
    guesser(actual, next_guess, sys_guess..high)
  end
  def guesser(actual, sys_guess, low.._high) when actual < sys_guess do
    next_guess = div(low + sys_guess, 2)
    IO.puts "Is it #{next_guess}"
    guesser(actual, next_guess, low..sys_guess)
  end
end

Chop.guess(1, 1..1000)
Chop.guess(1000, 1..1000)
Chop.guess(2, 1..1000)
Chop.guess(273, 1..1000)
