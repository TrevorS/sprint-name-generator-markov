defmodule SprintNameGenerator.Endpoint.Corpora do
  import Plug.Conn

  alias SprintNameGenerator.Response
  alias SprintNameGenerator.Response.Corpora

  def init(options \\ []), do: options

  def call(%{method: "GET", path_params: %{"id" => id}} = conn, _opts) do
    %Response{status_code: status_code, message: message} = Corpora.build(id)

    send_resp(conn, status_code, message)
  end

  def call(%{method: "GET"} = conn, _opts) do
    %Response{status_code: status_code, message: message} = Corpora.build()

    send_resp(conn, status_code, message)
  end

  def call(%{method: "POST", body_params: %{"corpus" => corpus}} = conn, _opts) do
    %Response{status_code: status_code, message: message} = Corpora.build(corpus)

    send_resp(conn, status_code, message)
  end
end
