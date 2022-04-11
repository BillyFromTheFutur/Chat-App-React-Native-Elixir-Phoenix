defmodule WeekendWeb.PageController do
  use WeekendWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
