defmodule Vending.Product do
  alias Vending.Cash

  @products [
    %{id: 1, name: "Tiny's used spacecraft",
      price: %{amount: 3, currency: Cash.currency}},
    %{id: 2, name: "Sandskimmer",
      price: %{amount: 7, currency: Cash.currency}},
    %{id: 3, name: "The escape Pod",
      price: %{amount: 9, currency: Cash.currency}},
    %{id: 4, name: "Drallion Asteroid Cruiser",
      price: %{amount: 12, currency: Cash.currency}},
    %{id: 5, name: "Arcada, the Federal spacelab",
      price: %{amount: 15, currency: Cash.currency}}
  ]

  def all do
    @products
  end

  @doc """
  Returns product by `id`
  """
  def find(id) do
    Enum.filter(@products, fn x ->
      x[:id] == id
    end) |> hd
  end

  @doc """
  Returns products that can be purchased by given `cash`
  """
  def available(cash) do
    Enum.filter(@products, fn x ->
      x[:price][:amount] <= cash
    end)
  end

  def can_purchase?(product) do
    if Cash.get >= product[:price][:amount] do
      true
    else
      false
    end
  end

  @doc """
  Purchase a product by `id`
  """
  def purchase(id) do
    product = find(String.to_integer(id))
    if can_purchase?(product) do
      cash_left = Cash.deduct(product[:price][:amount])
      Cash.destroy
      charge = %{odd_money: %{amount: cash_left,
                              currency: product[:price][:currency]}}
      Map.merge(product, charge)
    else
      %{error: "Can not purchase: not enough money"}
    end
  end
end