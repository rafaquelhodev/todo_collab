defmodule TodoCollab.Todos do
  alias TodoCollab.Repo
  alias TodoCollab.Todos.Todo

  def list_todos() do
    Todo
    |> Repo.all()
  end

  def create_todo(attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
  end
end
