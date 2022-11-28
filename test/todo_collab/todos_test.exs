defmodule TodoCollab.TodosTest do
  use ExUnit.Case, async: true
  use TodoCollab.DataCase

  alias TodoCollab.Lists
  alias TodoCollab.Todos

  describe "insert_todos" do
    test "should update a todo" do
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

      update_todo =
        old_todo
        |> Map.take([:uuid])
        |> Map.put(:text, "New description")
        |> Map.put(:done, true)

      Todos.insert_todos([update_todo], list_id)

      got_todos = Todos.list_todos(list_id)

      assert length(got_todos) == 3

      got_new_todo = got_todos |> Enum.find(fn todo -> todo.text == "New description" end)

      assert got_new_todo.uuid == update_todo.uuid
      assert got_new_todo.done
    end

    test "should update and create a todo" do
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

      update_todo =
        old_todo
        |> Map.take([:uuid])
        |> Map.put(:text, "New description")
        |> Map.put(:done, true)

      new_todo = %{text: "New todo", done: false}

      Todos.insert_todos([update_todo, new_todo], list_id)

      got_todos = Todos.list_todos(list_id)

      assert length(got_todos) == 4

      got_updated_todo = got_todos |> Enum.find(fn todo -> todo.text == "New description" end)

      assert got_updated_todo.uuid == update_todo.uuid
      assert got_updated_todo.done

      got_added_todo = got_todos |> Enum.find(fn todo -> todo.text == "New todo" end)

      assert !is_nil(got_added_todo.uuid)
      assert !got_added_todo.done
    end
  end
end
