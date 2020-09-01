defmodule NflRushingWeb.DownloadControllerTest do
  use NflRushingWeb.ConnCase

  describe "get index" do
    def create_rush() do
      {:ok, rush} = NflRushing.Stats.create_rush(%{
          attempts: 2,
          attempts_per_game: 2.0,
          avg_yards_per_attempt: 3.5,
          first_down_percentage: 0.0,
          first_downs: 0,
          forty_plus: 0,
          fumbles: 0,
          id: 1,
          longest: 7,
          longest_is_touchdown: false,
          player_name: "Joe Banyard",
          position: "RB",
          team_abbr: "JAX",
          total_yards: 7,
          touchdowns: 0,
          twenty_plus: 0,
          yards_per_game: 7.0
        })
      rush
    end

    test "responds with csv", %{conn: conn} do
      create_rush()
      create_rush()

      conn = get(conn, Routes.download_path(conn, :index, "csv", page: 1, size: 1))
      assert response_content_type(conn, :csv) == "text/csv"

      assert body = response(conn, 200)

      assert NflRushing.CsvParser.parse_string(body, skip_headers: false) == [
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
               [
                 "0",
                 "0.0",
                 "0",
                 "0",
                 "2",
                 "2.0",
                 "3.5",
                 "0",
                 "7",
                 "Joe Banyard",
                 "RB",
                 "0",
                 "JAX",
                 "7",
                 "7.0"
               ]
             ]
    end
  end
end
