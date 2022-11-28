defmodule TodoCollabWeb.UseCases.SaveList do
  alias TodoCollab.Lists
  alias TodoCollab.Todos

  def call(_list_id = nil, todos, _to_be_removed) do
    with {:ok, list} <-
           Lists.create(%{
             name: "Todo Example 1",
             user_name: "John Doe",
             todos: clear_todo_uids(todos)
           }) do
      {:ok, list.id}
    end
  end

  def call(list_id, todos, _to_be_removed) do
    todos
    |> clear_todo_uids()
    |> clear_changeset()
    |> Todos.insert_todos(list_id)

    {:ok, list_id}
  end

  defp clear_todo_uids(todos) do
    Enum.map(todos, fn todo ->
      case Map.get(todo, :uuid) do
        "added-" <> _ -> Map.delete(todo, :uuid)
        _ -> todo
      end
    end)
  end

  defp clear_changeset(todos) do
    Enum.map(todos, fn todo ->
      Map.take(todo, [:id, :text, :done, :uuid, :update_at, :inserted_at])
    end)
  end
end
