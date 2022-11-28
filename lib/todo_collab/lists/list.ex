defmodule TodoCollab.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :name, :string
    field :user_name, :string
    field :uuid, Ecto.UUID, read_after_writes: true

    has_many :todos, TodoCollab.Todos.Todo

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:name, :user_name, :uuid])
    |> cast_assoc(:todos)
    |> validate_required([:name, :user_name])
  end
end
