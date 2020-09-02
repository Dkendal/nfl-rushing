defmodule NflRushingWeb.RushLiveTest do
  use NflRushingWeb.ConnCase

  import Phoenix.LiveViewTest

  alias NflRushing.Stats

  @create_attrs %{attempts: 42, attempts_per_game: 42, avg_yards_per_attempt: 42, first_down_percentage: 42, first_downs: 42, forty_plus: 42, fumbles: 42, longest: 42, longest_is_touchdown: true, player_name: "some player_name", position: "some position", team_abbr: "some team_abbr", total_yards: 42, touchdowns: 42, twenty_plus: 42, yards_per_game: 42}

  defp fixture(:rush) do
    {:ok, rush} = Stats.create_rush(@create_attrs)
    rush
  end

  defp create_rush(_) do
    rush = fixture(:rush)
    %{rush: rush}
  end

  describe "Index" do
    setup [:create_rush]

    test "lists all rushes", %{conn: conn, rush: rush} do
      {:ok, _index_live, html} = live(conn, Routes.rush_index_path(conn, :index))

      assert html =~ "NFL Rushing"
      assert html =~ rush.player_name
    end
  end
end
