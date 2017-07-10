defmodule SprintNameGenerator.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(SprintNameGenerator.Repo, []),
      SprintNameGenerator.Endpoint.child_spec()
    ]

    opts = [strategy: :one_for_one, name: SprintNameGenerator.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
