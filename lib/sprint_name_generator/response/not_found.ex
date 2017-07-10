defmodule SprintNameGenerator.Response.NotFound do
  alias SprintNameGenerator.Response

  @message %{error: "Not Found"}

  def build do
    %Response{status_code: :not_found, message: Poison.encode!(@message)}
  end
end
