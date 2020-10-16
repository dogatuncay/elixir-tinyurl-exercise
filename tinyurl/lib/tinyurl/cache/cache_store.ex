defmodule TinyUrl.Cache.CacheStore do
  @moduledoc """
  Reference:
  https://elixirschool.com/en/lessons/specifics/ets/
  """
  alias TinyUrl.Service

  defmodule LruBuffer do
    def max_size() do
      128
    end

    def new() do
      []
    end

    # poke returns the new lru, as well as any evicted members
    def poke(lru, value) do
      if value in lru do
        {[value|Enum.filter(lru, fn el -> el != value end)], []}
      else
        Enum.split([value|lru], max_size())
      end
    end
  end

  def init() do
    :ets.new(:urls, [:set, :public, :named_table])
    :ets.insert_new(:urls, {:lru_buffer, LruBuffer.new()})
  end

  def poke_lru(short_name) do
    [{_, lru}] = :ets.lookup(:urls, :lru_buffer)
    {lru, evicted_keys} = LruBuffer.poke(lru, short_name)
    Enum.each(evicted_keys, fn key -> :ets.delete(:urls, key) end)
    :ets.insert(:urls, {:lru_buffer, lru})
  end

  def set(short_name, url) do
    poke_lru(short_name)
    # due to the rules around ShortLink, we assume the existing cache record is always already correct
    if :ets.lookup(:urls, short_name) == [] do
      :ets.insert_new(:urls, {short_name, url})
    end
  end

  def get(short_name) do
    case :ets.lookup(:urls, short_name) do
      [] -> nil
      [{_, url}] ->
        poke_lru(short_name)
        url
    end
  end
end
