defmodule TodoCollab.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :done, :boolean, default: false
    field :text, :string
    field :uuid, Ecto.UUID, read_after_writes: true

    belongs_to :list, TodoCollab.Lists.List

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:text, :done, :uuid])
    |> validate_required([:text, :done])
  end
end
