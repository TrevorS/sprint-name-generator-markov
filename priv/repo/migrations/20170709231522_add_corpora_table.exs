defmodule SprintNameGenerator.Repo.Migrations.AddCorporaTable do
  use Ecto.Migration

  def change do
    create table(:corpora) do
      add :name, :text, null: false
      add :text, :text, null: false
      add :markov, :map, null: false

      timestamps()
    end

    create index(:corpora, [:name], unique: true)
  end
end
