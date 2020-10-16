defmodule TinyUrl.Repo.Migrations.AddShortLinksTable do
  use Ecto.Migration

  def change do
    create table("short_links") do
      add :url, :string, size: 255
      add :short_name, :string, size: 8

      timestamps(type: :utc_datetime)
    end
    create unique_index("short_links", [:url])
    create unique_index("short_links", [:short_name])
  end
end
