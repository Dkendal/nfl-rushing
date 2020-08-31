defmodule NflRushing.JsonImportTest do
  use NflRushing.DataCase
  alias NflRushing.JsonImport
  doctest NflRushing.JsonImport, import: true

  test "inserts all records from a json file into the database" do
    assert {326, nil} == JsonImport.import_file!("rushing.json")
    assert 326 == Repo.aggregate(Rush, :count)
  end

  @json_record %{
    :"1st" => 23,
    :"1st%" => 31.1,
    :"20+" => 0,
    :"40+" => 0,
    :Att => 74,
    :"Att/G" => 4.6,
    :Avg => 4.6,
    :FUM => 0,
    :Lng => "20T",
    :Player => "John Doe",
    :Pos => "RB",
    :TD => 2,
    :Team => "ABC",
    :Yds => "1,234",
    :"Yds/G" => 21.5
  }

  test "to_struct/1 converts a record from rushing.json to a Rush struct" do
    result = JsonImport.to_struct(@json_record)

    assert %NflRushing.Stats.Rush{} = result

    # Lng is split into two fields
    assert result.longest == 20
    assert result.longest_is_touchdown == true

    # Commas are stripped from Yds before parsing
    assert result.total_yards == 1_234

    assert result.attempts == 74
    assert result.attempts_per_game == 4.6
    assert result.avg_yards_per_attempt == 4.6
    assert result.first_down_percentage == 31.1
    assert result.first_downs == 23
    assert result.forty_plus == 0
    assert result.fumbles == 0
    assert result.player_name == "John Doe"
    assert result.position == "RB"
    assert result.team_abbr == "ABC"
    assert result.touchdowns == 2
    assert result.twenty_plus == 0
    assert result.yards_per_game == 21.5
  end
end
