defmodule TodoCollab.Lists do
  alias TodoCollab.Repo
  alias TodoCollab.Lists.List

  def create(attrs) do
    %List{}
    |> List.changeset(attrs)
    |> Repo.insert()
  end
end
