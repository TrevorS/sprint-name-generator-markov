defmodule SprintNameGenerator.Repo.Migrations.AddCorporaTable do
  use Ecto.Migration

  def change do
    create table(:corpora) do
      add :name, :text
      add :text, :text
      add :markov, :map

      timestamps()
    end

    create index(:corpora, [:name])
  end
end
