defmodule TodoCollab.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS pgcrypto"

    create table(:lists) do
      add :name, :string
      add :user_name, :string
      add :uuid, :uuid, null: false, default: fragment("gen_random_uuid()")

      timestamps()
    end

    create unique_index(:lists, [:uuid])

    create table(:todos) do
      add :text, :string
      add :done, :boolean, default: false, null: false
      add :uuid, :uuid, null: false, default: fragment("gen_random_uuid()")

      add :list_id, references(:lists)

      timestamps()
    end

    create unique_index(:todos, [:uuid])
  end
end
