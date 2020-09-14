defmodule TinyUrlWeb.PageController do
  use TinyUrlWeb, :controller

  # TODO: implement ability to generate a short link
  def generate(conn, params) do
    render(conn, "short_link.json")
  end

  # TODO: implement when user clicks link and redirect to original link
  def redirect(conn, params) do

  end
end
