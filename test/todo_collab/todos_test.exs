defmodule TodoCollab.TodosTest do
  use ExUnit.Case, async: true
  use TodoCollab.DataCase

  alias TodoCollab.Lists
  alias TodoCollab.Todos

  describe "insert_todos" do
    test "should update already inserted todos" do
      {:ok, %{id: list_id}} =
        Lists.create(%{
          name: "Todo Example 1",
          user_name: "John Doe",
          todos: [
            %{text: "Buy groceries", done: false},
            %{text: "Do laundry", done: true},
            %{text: "Study history", done: false}
          ]
        })

      todos = Todos.list_todos(list_id)

      old_todo = todos |> Enum.find(fn todo -> todo.text == "Buy groceries" end)

      new_todo =
        old_todo
        |> Map.take([:uuid])
        |> Map.put(:text, "New description")
        |> Map.put(:done, true)
        |> Map.put(:inserted_at, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
        |> Map.put(:updated_at, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))

      Todos.insert_todos([new_todo], list_id)

      got_todos = Todos.list_todos(list_id)

      assert length(got_todos) == 3

      got_new_todo = got_todos |> Enum.find(fn todo -> todo.text == "New description" end)

      assert got_new_todo.uuid == new_todo.uuid
    end
  end
end
