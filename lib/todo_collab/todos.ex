defmodule TodoCollab.Todos do
  import Ecto.Query, only: [from: 2]

  alias TodoCollab.Repo
  alias TodoCollab.Todos.Todo

  def list_todos(list_id) do
    Repo.all(from t in Todo, where: t.list_id == ^list_id)
  end

  def create_todo(attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
  end
end
