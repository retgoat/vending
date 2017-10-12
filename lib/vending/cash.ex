defmodule Vending.Cash do

  def start_link do
    Agent.start_link(fn -> MapSet.new end, name: __MODULE__)
  end

  def currency do
    {:ok, cur} = Application.fetch_env(:vending, :currency)
    cur
  end

  def nominals do
    [0.1, 0.25, 0.5, 1.0, 2.0, 5.0, 10.0]
  end


  @doc """
  Gets a value from the bucket by `key`.
  """
  def get do
    cash = Agent.get(__MODULE__, &Map.get(&1, :money))
    case cash do
      nil -> 0
      _ -> cash
    end
  end

  @doc """
  Puts the `value` for bucket
  """
  def store(value) do
    Agent.update(__MODULE__, &Map.put(&1, :money, value))
  end

  @doc """
  Adds given `value` to the current bucket value
  """
  def add(value) do
    store(get() + value)
    get()
  end

  @doc """
  Deducts given `value` from the current bucket value
  """
  def deduct(value) do
    store(get() - value)
    get()
  end

  @doc """
  DEstroys the bucket
  """
  def destroy do
    Agent.get_and_update(__MODULE__, &Map.pop(&1, :money))
  end
end