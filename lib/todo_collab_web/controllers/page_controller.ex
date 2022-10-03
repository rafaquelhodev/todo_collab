defmodule TodoCollabWeb.PageController do
  use TodoCollabWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
