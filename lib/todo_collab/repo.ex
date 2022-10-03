defmodule TodoCollab.Repo do
  use Ecto.Repo,
    otp_app: :todo_collab,
    adapter: Ecto.Adapters.Postgres
end
