fizzbuzz = fn
  (0, 0, _) -> "FizzBuzz"
  (0, _, _) -> "Fizz"
  (_, 0, _) -> "Buzz"
  (_, _, c) -> c
end

fizzbuzzer = fn (n) -> fizzbuzz.(rem(n, 3), rem(n, 5), n) end

IO.puts fizzbuzzer.(10) # Buzz
IO.puts fizzbuzzer.(11) # 11
IO.puts fizzbuzzer.(12) # Fizz
IO.puts fizzbuzzer.(13) # 13
IO.puts fizzbuzzer.(14) # 14
IO.puts fizzbuzzer.(15) # FizzBuzz
IO.puts fizzbuzzer.(16) # 16
