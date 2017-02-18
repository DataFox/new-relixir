defmodule NewRelixir.Plug do
  @behaviour Elixir.Plug
  import Plug.Conn
  import NewRelixir.Utils

  def init(opts) do
    opts
  end

  def call(conn, _config) do
    if NewRelixir.configured? do
      conn
      |> put_private(:new_relixir_transaction, NewRelixir.Transaction.start)
      |> register_before_send(fn conn ->
        NewRelixir.Transaction.finish(Map.get(conn.private, :new_relixir_transaction), Map.get(conn.private, :new_relic_transaction_name))
        conn
      end)
    else
      conn
    end
  end
end
