# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TodoCollab.Repo.insert!(%TodoCollab.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TodoCollab.Lists

Lists.create(%{
  name: "Todo Example 1",
  user_name: "John Doe",
  todos: [
    %{text: "Buy groceries", done: false},
    %{text: "Do laundry", done: true},
    %{text: "Study history", done: false}
  ]
})
