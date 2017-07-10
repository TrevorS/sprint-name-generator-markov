defmodule SprintNameGenerator.Endpoint.SprintName do
  import Plug.Conn

  alias SprintNameGenerator.Response
  alias SprintNameGenerator.Response.SprintName

  def init(opts \\ []), do: opts

  def call(%{method: "GET", path_params: %{"id" => id}} = conn, _opts) do
    %Response{status_code: status_code, message: message} = SprintName.build(id)

    send_resp(conn, status_code, message)
  end
end
