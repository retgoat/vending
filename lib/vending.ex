defmodule Vending do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Vending.Cash, [])
    ]

    opts = [strategy: :one_for_one, name: Vending.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
