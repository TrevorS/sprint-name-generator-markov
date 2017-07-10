defmodule SprintNameGenerator.Endpoint do
  use Plug.Router

  @opts [port: System.get_env("PORT") || 4000]

  plug Plug.Static,
    at: "/", from: :sprint_name_generator, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug SprintNameGenerator.Router

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  def child_spec do
    Plug.Adapters.Cowboy.child_spec(:http, __MODULE__, [], @opts)
  end
end
