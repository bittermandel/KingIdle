defmodule Kingidle.Repo do
  use Ecto.Repo,
    otp_app: :kingidle,
    adapter: Ecto.Adapters.Postgres
end
