# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TinyUrl.Repo.insert!(%TinyUrl.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TinyUrl.Service
alias TinyUrl.Links.ShortLink

urls = ["http://www.facebook.com/", "http://www.google.com/", "http://www.amazon.com/"]

Enum.each(urls, fn url ->
  ShortLink.create_changeset(url)
  |> TinyUrl.Repo.insert()
end)
