defmodule Cash do

  def currency do
    {:ok, cur} = Application.fetch_env(:vending, :currency)
    cur
  end

  def nominals do
    [0.1, 0.25, 0.5, 1.0, 2.0, 5.0, 10.0]
  end

  def start_link do
    Agent.start_link(fn -> MapSet.new end, name: __MODULE__)
  end

  @doc """
  Gets a value from the `bucket` by `key`.
  """
  def get do
    cash = Agent.get(__MODULE__, &Map.get(&1, :money))
    case cash do
      nil -> 0
      _ -> cash
    end
  end

  @doc """
  Puts the `value` for the given `key` in the `bucket`.
  """
  def store(value) do
    Agent.update(__MODULE__, &Map.put(&1, :money, value))
  end


  def add(value) do
    store(get + value)
    get
  end

  def deduct(value) do
    store(get - value)
    get
  end

  def destroy do
    Agent.get_and_update(__MODULE__, &Map.pop(&1, :money))
  end


  # def init do
  #   case :ets.info(:cash) do
  #     :undefined ->
  #       :ets.new(:cash, [:named_table, :set])
  #       current
  #     _ -> current
  #   end
  # end

  # def store(cash) do
  #   :ets.insert(:cash, {"current", cash})
  #   current
  # end

  # def add(value) do
  #   store(current + value)
  # end

  # def deduct(value) do
  #   IO.inspect current
  #   store(current - value)
  # end

  # def destroy do
  #   :ets.delete(:cash)
  # end

  # def current do
  #   case :ets.lookup(:cash, "current") do
  #     l when length(l) == 0 -> 0
  #     l when length(l) > 0 -> hd(l) |> elem(1)
  #     _ -> 0
  #   end
  # end
end