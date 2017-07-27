defmodule SprintNameGenerator.Router do
  use Plug.Router

  alias SprintNameGenerator.Response
  alias SprintNameGenerator.Response.NotFound
  alias SprintNameGenerator.Endpoint.Corpora
  alias SprintNameGenerator.Endpoint.SprintName

  plug Corsica,
    origins: "http://localhost:8000",
    allow_headers: ["Content-Type"],
    allow_credentials: true

  plug :set_response_content_type

  plug :match
  plug :dispatch

  forward "/corpora/:id/sprint-name",
    to: SprintName

  forward "/corpora/:id",
    to: Corpora

  forward "/corpora",
    to: Corpora

  match _ do
    %Response{status_code: status_code, message: message} = NotFound.build()

    send_resp(conn, status_code, message)
  end

  defp set_response_content_type(conn, _opts),
    do: put_resp_content_type(conn, "application/json")
end
