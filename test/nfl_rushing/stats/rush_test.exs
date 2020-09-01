defmodule NflRushing.Stats.RushTest do
  use ExUnit.Case
  alias NflRushing.Stats.Rush
  doctest NflRushing.Stats.Rush

  test "export csv" do
    rush = %Rush{
      attempts: 2,
      attempts_per_game: 2.0,
      avg_yards_per_attempt: 3.5,
      first_down_percentage: 0.0,
      first_downs: 0,
      forty_plus: 0,
      fumbles: 0,
      id: 1,
      inserted_at: ~N[2020-09-01 19:18:35],
      longest: 7,
      longest_is_touchdown: false,
      player_name: "Joe Banyard",
      position: "RB",
      team_abbr: "JAX",
      total_yards: 7,
      touchdowns: 0,
      twenty_plus: 0,
      updated_at: ~N[2020-09-01 19:18:35],
      yards_per_game: 7.0
    }

    assert Rush.to_csv([rush]) == [
             [
               "1st",
               "1st%",
               "20+",
               "40+",
               "Att",
               "Att/G",
               "Avg",
               "FUM",
               "Lng",
               "Player",
               "Pos",
               "TD",
               "Team",
               "Yds",
               "Yds/G"
             ],
             [0, 0.0, 0, 0, 2, 2.0, 3.5, 0, "7", "Joe Banyard", "RB", 0, "JAX", 7, 7.0]
           ]
  end
end
