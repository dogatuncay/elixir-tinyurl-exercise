defmodule TinyUrl.Links.ShortLink do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:url, :short_name]

  @derive Jason.Encoder
  schema "short_links" do
    field :url, :string
    field :short_name, :string

    timestamps(type: :utc_datetime)
  end

  def short_name_length do
    8
  end

  def expiration_in_seconds do
    # 3 days
    60 * 60 * 24 * 3
  end

  def expired?(%__MODULE__{inserted_at: inserted_at}) do
    {:ok, now} = DateTime.now("Etc/UTC")
    DateTime.add(inserted_at, expiration_in_seconds(), :seconds) >= now
  end

  def create_changeset(url) do
    url_hash = :crypto.hash(:sha256, url)
    short_name = String.slice(Base58.encode(url_hash), 0..(short_name_length()-1))

    %__MODULE__{}
    |> cast(%{url: url}, [:url]) # may not need this
    |> put_change(:short_name, short_name)
    |> validate_required(@required_fields)
    |> validate_length(:short_name, is: short_name_length())
    |> unique_constraint(@required_fields)
  end
end
