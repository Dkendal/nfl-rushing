defmodule NflRushing.Repo.Migrations.CreateRushes do
  use Ecto.Migration

  def change do
    create table(:rushes) do
      add :player_name, :string
      add :team_abbr, :string
      add :position, :string
      add :attempts_per_game, :float
      add :attempts, :integer
      add :total_yards, :integer
      add :avg_yards_per_attempt, :float
      add :yards_per_game, :float
      add :touchdowns, :integer
      add :longest, :integer
      add :longest_is_touchdown, :boolean, default: false, null: false
      add :first_downs, :integer
      add :first_down_percentage, :float
      add :twenty_plus, :integer
      add :forty_plus, :integer
      add :fumbles, :integer

      timestamps()
    end

  end
end
