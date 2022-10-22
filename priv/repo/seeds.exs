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

alias TodoCollab.Todos

Todos.create_todo(%{text: "Buy groceries", done: false})
Todos.create_todo(%{text: "Do laundry", done: true})
Todos.create_todo(%{text: "Study history", done: false})
