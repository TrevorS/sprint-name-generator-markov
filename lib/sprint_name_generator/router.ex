defmodule SprintNameGenerator.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/sprint-name/:corpus_name" do
    corpus_name = conn.params["corpus_name"]

    send_resp(conn, 200, "Hello World: Sprint Name Generator - Corpus Name: #{corpus_name}")
  end

  post "/sprint-name" do
    send_resp(conn, 200, ":)")
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
