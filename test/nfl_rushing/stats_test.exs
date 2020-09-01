defmodule NflRushing.StatsTest do
  use NflRushing.DataCase

  alias NflRushing.Stats

  describe "rushes" do
    alias NflRushing.Stats.Rush

    @valid_attrs %{
      attempts: 42,
      attempts_per_game: 42,
      avg_yards_per_attempt: 42,
      first_down_percentage: 42,
      first_downs: 42,
      forty_plus: 42,
      fumbles: 42,
      longest: 42,
      longest_is_touchdown: true,
      player_name: "some player_name",
      position: "some position",
      team_abbr: "some team_abbr",
      total_yards: 42,
      touchdowns: 42,
      twenty_plus: 42,
      yards_per_game: 42
    }
    @update_attrs %{
      attempts: 43,
      attempts_per_game: 43,
      avg_yards_per_attempt: 43,
      first_down_percentage: 43,
      first_downs: 43,
      forty_plus: 43,
      fumbles: 43,
      longest: 43,
      longest_is_touchdown: false,
      player_name: "some updated player_name",
      position: "some updated position",
      team_abbr: "some updated team_abbr",
      total_yards: 43,
      touchdowns: 43,
      twenty_plus: 43,
      yards_per_game: 43
    }
    @invalid_attrs %{
      attempts: nil,
      attempts_per_game: nil,
      avg_yards_per_attempt: nil,
      first_down_percentage: nil,
      first_downs: nil,
      forty_plus: nil,
      fumbles: nil,
      longest: nil,
      longest_is_touchdown: nil,
      player_name: nil,
      position: nil,
      team_abbr: nil,
      total_yards: nil,
      touchdowns: nil,
      twenty_plus: nil,
      yards_per_game: nil
    }

    def rush_fixture(attrs \\ %{}) do
      {:ok, rush} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Stats.create_rush()

      rush
    end

    test "count_rushes/1 count rushes that match the query" do
      rush_1 = rush_fixture()
      assert Stats.count_rushes(%{}) == 1

      rush_2 = rush_fixture(%{player_name: "some other player name"})
      assert Stats.count_rushes(%{}) == 2

      assert Stats.count_rushes(%{order_dir: :asc, order_key: :player_name}) == 2

      assert Stats.count_rushes(%{page: 1, size: 1}) == 1

      assert Stats.count_rushes(%{page: 2, size: 1}) == 1

      assert Stats.count_rushes(%{search: "other"}) == 1
    end

    test "query_rushes/1 returns rushes that match the query" do
      rush_1 = rush_fixture()
      assert Stats.query_rushes(%{}) == [rush_1]

      rush_2 = rush_fixture(%{player_name: "some other player name"})
      assert Stats.query_rushes(%{}) == [rush_1, rush_2]

      assert Stats.query_rushes(%{order_dir: :asc, order_key: :player_name}) == [rush_2, rush_1]

      assert Stats.query_rushes(%{page: 1, size: 1}) == [rush_1]

      assert Stats.query_rushes(%{page: 2, size: 1}) == [rush_2]

      assert Stats.query_rushes(%{search: "other"}) == [rush_2]
    end

    test "list_rushes/0 returns all rushes" do
      rush = rush_fixture()
      assert Stats.list_rushes() == [rush]
    end

    test "get_rush!/1 returns the rush with given id" do
      rush = rush_fixture()
      assert Stats.get_rush!(rush.id) == rush
    end

    test "create_rush/1 with valid data creates a rush" do
      assert {:ok, %Rush{} = rush} = Stats.create_rush(@valid_attrs)
      assert rush.attempts == 42
      assert rush.attempts_per_game == 42
      assert rush.avg_yards_per_attempt == 42
      assert rush.first_down_percentage == 42
      assert rush.first_downs == 42
      assert rush.forty_plus == 42
      assert rush.fumbles == 42
      assert rush.longest == 42
      assert rush.longest_is_touchdown == true
      assert rush.player_name == "some player_name"
      assert rush.position == "some position"
      assert rush.team_abbr == "some team_abbr"
      assert rush.total_yards == 42
      assert rush.touchdowns == 42
      assert rush.twenty_plus == 42
      assert rush.yards_per_game == 42
    end

    test "create_rush/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stats.create_rush(@invalid_attrs)
    end

    test "update_rush/2 with valid data updates the rush" do
      rush = rush_fixture()
      assert {:ok, %Rush{} = rush} = Stats.update_rush(rush, @update_attrs)
      assert rush.attempts == 43
      assert rush.attempts_per_game == 43
      assert rush.avg_yards_per_attempt == 43
      assert rush.first_down_percentage == 43
      assert rush.first_downs == 43
      assert rush.forty_plus == 43
      assert rush.fumbles == 43
      assert rush.longest == 43
      assert rush.longest_is_touchdown == false
      assert rush.player_name == "some updated player_name"
      assert rush.position == "some updated position"
      assert rush.team_abbr == "some updated team_abbr"
      assert rush.total_yards == 43
      assert rush.touchdowns == 43
      assert rush.twenty_plus == 43
      assert rush.yards_per_game == 43
    end

    test "update_rush/2 with invalid data returns error changeset" do
      rush = rush_fixture()
      assert {:error, %Ecto.Changeset{}} = Stats.update_rush(rush, @invalid_attrs)
      assert rush == Stats.get_rush!(rush.id)
    end

    test "delete_rush/1 deletes the rush" do
      rush = rush_fixture()
      assert {:ok, %Rush{}} = Stats.delete_rush(rush)
      assert_raise Ecto.NoResultsError, fn -> Stats.get_rush!(rush.id) end
    end

    test "change_rush/1 returns a rush changeset" do
      rush = rush_fixture()
      assert %Ecto.Changeset{} = Stats.change_rush(rush)
    end
  end
end
