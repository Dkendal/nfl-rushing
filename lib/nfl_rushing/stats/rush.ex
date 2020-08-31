defmodule NflRushing.Stats.Rush do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rushes" do
    field :attempts, :integer
    field :attempts_per_game, :float
    field :avg_yards_per_attempt, :float
    field :first_down_percentage, :float
    field :first_downs, :integer
    field :forty_plus, :integer
    field :fumbles, :integer
    field :longest, :integer
    field :longest_is_touchdown, :boolean, default: false
    field :player_name, :string
    field :position, :string
    field :team_abbr, :string
    field :total_yards, :integer
    field :touchdowns, :integer
    field :twenty_plus, :integer
    field :yards_per_game, :float

    timestamps()
  end

  @doc false
  def changeset(rush, attrs) do
    rush
    |> cast(attrs, [
      :player_name,
      :team_abbr,
      :position,
      :attempts_per_game,
      :attempts,
      :total_yards,
      :avg_yards_per_attempt,
      :yards_per_game,
      :touchdowns,
      :longest,
      :longest_is_touchdown,
      :first_downs,
      :first_down_percentage,
      :twenty_plus,
      :forty_plus,
      :fumbles
    ])
    |> validate_required([
      :player_name,
      :team_abbr,
      :position,
      :attempts_per_game,
      :attempts,
      :total_yards,
      :avg_yards_per_attempt,
      :yards_per_game,
      :touchdowns,
      :longest,
      :longest_is_touchdown,
      :first_downs,
      :first_down_percentage,
      :twenty_plus,
      :forty_plus,
      :fumbles
    ])
  end
end
