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

  @mapping [
    {:"1st", :first_downs},
    {:"1st%", :first_down_percentage},
    {:"20+", :twenty_plus},
    {:"40+", :forty_plus},
    {:Att, :attempts},
    {:"Att/G", :attempts_per_game},
    {:Avg, :avg_yards_per_attempt},
    {:FUM, :fumbles},
    {:Lng, :longest},
    {:Player, :player_name},
    {:Pos, :position},
    {:TD, :touchdowns},
    {:Team, :team_abbr},
    {:Yds, :total_yards},
    {:"Yds/G", :yards_per_game}
  ]

  def abbrs() do
    unquote(for {k, _} <- @mapping, do: k)
  end

  def fields() do
    unquote(for {_, v} <- @mapping, do: v)
  end

  for {abbr, field} <- @mapping do
    def abbr_to_field(unquote(abbr)), do: unquote(field)
    def field_to_abbr(unquote(field)), do: unquote(abbr)
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
