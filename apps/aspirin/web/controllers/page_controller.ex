defmodule Aspirin.PageController do
  use Aspirin.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
