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

  def insert_todos(todos, list_id) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    todos =
      Enum.map(todos, fn todo ->
        todo
        |> Map.put(:list_id, list_id)
        |> Map.put(:updated_at, now)
        |> Map.put(:inserted_at, now)
      end)

    Repo.insert_all(Todo, todos,
      conflict_target: [:uuid],
      on_conflict: {:replace, [:text, :done]},
      returning: true
    )
  end
end
