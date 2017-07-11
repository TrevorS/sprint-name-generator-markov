defmodule SprintNameGenerator.Plug.IndexHtml do
  @behaviour Plug

  def init([]),
    do: [request_path: "/", file_name: "index.html"]
  def init(opts),
    do: opts

  def call(conn, request_path: request_path, file_name: file_name) do
    case conn.request_path == request_path do
      true -> add_index_html(conn, file_name)
      false -> conn
    end
  end

  defp add_index_html(conn, file_name) do
    %{conn |
      request_path: "#{conn.request_path}#{file_name}",
      path_info: conn.path_info ++ [file_name]
    }
  end
end
