defmodule Weekend.Repo do
  use Ecto.Repo,
    otp_app: :weekend,
    adapter: Ecto.Adapters.Postgres
end
