defmodule TodoCollab.Lists do
  alias TodoCollab.Repo
  alias TodoCollab.Lists.List

  def get_id(list_uuid) do
    Repo.get_by(List, uuid: list_uuid)
    |> Map.get(:id)
  end

  def create(attrs) do
    %List{}
    |> List.changeset(attrs)
    |> Repo.insert()
  end
end
