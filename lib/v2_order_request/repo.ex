defmodule V2OrderRequest.Repo do
  use Ecto.Repo,
    otp_app: :v2_order_request,
    adapter: Ecto.Adapters.Postgres
end
