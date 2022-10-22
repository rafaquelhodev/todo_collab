defmodule TodoCollab.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS pgcrypto"

    create table(:todos) do
      add :text, :string
      add :done, :boolean, default: false, null: false
      add :uuid, :uuid, null: false, default: fragment("gen_random_uuid()")

      timestamps()
    end
  end
end
