defmodule TinyUrlWeb.PageController do
  use TinyUrlWeb, :controller
  alias TinyUrl.Repo
  alias TinyUrl.Service
  alias TinyUrl.Links.ShortLink
  import Ecto.Query

  @base_url "http://tinyurl.com/"

  def show(conn, %{"id" => short_name}) do
    url = Service.fetch_original_link(short_name)
    if url != nil do
      render(conn, "ok.json", %{result: url})
    else
      render(conn, "error.json", %{message: "Url expired or doesn't exist."})
    end
  end

  def create(conn, %{"url" => url}) do
    changeset = ShortLink.create_changeset(url)
    case Repo.insert(changeset) do
      {:ok, short_link} ->
        render(conn, "ok.json", %{result:   @base_url <> short_link.short_name})
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "changeset_error.json", %{message: "Url expired or doesn't exist."})
    end
  end
end
