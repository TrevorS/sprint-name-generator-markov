defmodule SprintNameGenerator.Endpoint do
  use Plug.Router

  alias Plug.Adapters.Cowboy

  alias SprintNameGenerator.Plug.IndexHtml
  alias SprintNameGenerator.Response
  alias SprintNameGenerator.Response.NotFound

  @opts [port: System.get_env("PORT") || 4000]

  plug IndexHtml

  plug Plug.Static,
    at: "/", from: :sprint_name_generator, gzip: false,
    only: ~w(favicon.ico robots.txt index.html)

  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug SprintNameGenerator.Router

  match _ do
    %Response{status_code: status_code, message: message} = NotFound.build()

    send_resp(conn, status_code, message)
  end

  def child_spec do
    Cowboy.child_spec(:http, __MODULE__, [], @opts)
  end
end
