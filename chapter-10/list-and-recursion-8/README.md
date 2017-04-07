# Problem
The Pragmatic Bookshelf has offices in Texas (TX) and North Caroline (NC), so we have to charge sales tax on orders shipped to these states. The rates can be expressed as a kw list:
```
tax_rates = [NC: 0.075, TX: 0.08]

orders = [
  [id: 123, ship_to: :NC, net_amount: 100.00],
  [id: 124, ship_to: :OK, net_amount: 35.50],
  [id: 125, ship_to: :TX, net_amount: 24.00],
  [id: 126, ship_to: :TX, net_amount: 44.80],
  [id: 127, ship_to: :NC, net_amount: 25.00],
  [id: 128, ship_to: :MA, net_amount: 10.00],
  [id: 129, ship_to: :CA, net_amount: 102.00],
  [id: 130, ship_to: :NC, net_amount: 50.00]
]
```

# Solution
```
defmodule TaxSolver do
  def solve(orders, rates) do
    orders |> Enum.map(&(total_amount(&1, rates)))
  end

  defp total_amount([id: id, ship_to: ship_to, net_amount: net_amount], rates) do
    tax = rates[ship_to]
    total_amount = if tax do
                     net_amount * (1 + tax)
                   else
                     net_amount
                   end
    [id: id, ship_to: ship_to, new_amount: net_amount, total_amount: total_amount]
  end
end
```
