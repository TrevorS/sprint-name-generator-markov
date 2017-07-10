defmodule SprintNameGenerator.Response do
  @enforce_keys [:status_code, :message]

  defstruct [:status_code, :message]
end
