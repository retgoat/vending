defmodule Vending.API1 do
  use Maru.Router
  plug Plug.Logger

  before do
    plug Plug.Parsers,
      pass: ["*/*"],
      json_decoder: Poison,
      parsers: [:urlencoded, :json, :multipart]
  end

  desc "Show static index html page" do
    get do
      conn
      |> html(File.read!(Path.join("./static", "home.html")))
    end
  end

  namespace :products do
    desc "Fetch all products" do
      get do
        respond_with(conn, Product.all, 200)
      end
    end

    desc "Purchase a product" do
      route_param :product_id do
        get :purchase do
          respond_with(conn, Product.purchase(params[:product_id]), 200)
        end
      end
    end
  end

  namespace :cash do
    desc "insert cash" do
      params do
        requires :cash, type: Float, values: Cash.nominals
      end

      put do
        Cash.start_link
        given_cash = Cash.add(params[:cash])
        inserted = %{cash: %{amount: given_cash, currency: Cash.currency}}
        resp = Map.merge(%{products: Product.available(given_cash)}, inserted)
        respond_with(conn, resp, 201)
      end
    end

    desc "Show already inserted cash" do
      get :given do
        Cash.start_link
        resp = %{already_given: %{amount: Cash.get, currency: Cash.currency}}
        respond_with(conn, resp, 200)
      end
    end

    desc "Available cash nominals" do
      get :nominals do
        resp = %{nominals: Cash.nominals, currency: Cash.currency}
        respond_with(conn, resp, 200)
      end
    end
  end

  defp respond_with(conn, body, status) do
    conn
    |> put_status(status)
    |> put_resp_header("Content-Type", "application/json")
    |> json(body)
    |> halt
  end

  rescue_from :all, as: e do
    IO.puts inspect e
    status = case e do
               %Maru.Exceptions.NotFound{} -> 404
               %Maru.Exceptions.Validation{} -> 422
               _ -> 500
             end
    respond_with(conn, %{error: inspect(e)}, status)
  end
end
