defmodule KingidleWeb.PageController do
  use KingidleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
