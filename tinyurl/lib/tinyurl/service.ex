defmodule TinyUrl.Service do
  import Ecto.Query, only: [from: 2]
  alias TinyUrl.Repo
  alias TinyUrl.Links.ShortLink
  alias TinyUrl.Cache.CacheStore

  def fetch_from_cache(short_name) do
    CacheStore.get(short_name)
  end

  def fetch_from_db(short_name) do
    short_link = Repo.one(from l in ShortLink, where: l.short_name == ^short_name)
    if short_link != nil do
      if ShortLink.expired?(short_link) do
        Repo.delete!(short_link)
        nil
      else
        CacheStore.set(short_name, short_link.url)
        short_link.url
      end
    else
      nil
    end
  end

  def fetch_original_link(long_link) do
    cached_short_url = fetch_from_cache(long_link)
    if cached_short_url do
      IO.puts "LOADED FROM CACHE!"
      cached_short_url
    else
      IO.puts "LOADED FROM DB!"
      fetch_from_db(long_link)
    end
  end
end
