defmodule NflRushingWeb.RushLiveTest do
  use NflRushingWeb.ConnCase

  import Phoenix.LiveViewTest

  alias NflRushing.Stats

  @create_attrs %{attempts: 42, attempts_per_game: 42, avg_yards_per_attempt: 42, first_down_percentage: 42, first_downs: 42, forty_plus: 42, fumbles: 42, longest: 42, longest_is_touchdown: true, player_name: "some player_name", position: "some position", team_abbr: "some team_abbr", total_yards: 42, touchdowns: 42, twenty_plus: 42, yards_per_game: 42}
  @update_attrs %{attempts: 43, attempts_per_game: 43, avg_yards_per_attempt: 43, first_down_percentage: 43, first_downs: 43, forty_plus: 43, fumbles: 43, longest: 43, longest_is_touchdown: false, player_name: "some updated player_name", position: "some updated position", team_abbr: "some updated team_abbr", total_yards: 43, touchdowns: 43, twenty_plus: 43, yards_per_game: 43}
  @invalid_attrs %{attempts: nil, attempts_per_game: nil, avg_yards_per_attempt: nil, first_down_percentage: nil, first_downs: nil, forty_plus: nil, fumbles: nil, longest: nil, longest_is_touchdown: nil, player_name: nil, position: nil, team_abbr: nil, total_yards: nil, touchdowns: nil, twenty_plus: nil, yards_per_game: nil}

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

    test "lists all rushes with sorting options", %{conn: conn, rush: rush} do
      {:ok, _index_live, html} = live(conn, Routes.rush_index_path(conn, :index, %{"order_by" => "player_name"}))

      assert html =~ "Listing Rushes"
      assert html =~ rush.player_name
    end

    test "lists all rushes", %{conn: conn, rush: rush} do
      {:ok, _index_live, html} = live(conn, Routes.rush_index_path(conn, :index))

      assert html =~ "Listing Rushes"
      assert html =~ rush.player_name
    end

    test "saves new rush", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.rush_index_path(conn, :index))

      assert index_live |> element("a", "New Rush") |> render_click() =~
               "New Rush"

      assert_patch(index_live, Routes.rush_index_path(conn, :new))

      assert index_live
             |> form("#rush-form", rush: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#rush-form", rush: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.rush_index_path(conn, :index))

      assert html =~ "Rush created successfully"
      assert html =~ "some player_name"
    end

    test "updates rush in listing", %{conn: conn, rush: rush} do
      {:ok, index_live, _html} = live(conn, Routes.rush_index_path(conn, :index))

      assert index_live |> element("#rush-#{rush.id} a", "Edit") |> render_click() =~
               "Edit Rush"

      assert_patch(index_live, Routes.rush_index_path(conn, :edit, rush))

      assert index_live
             |> form("#rush-form", rush: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#rush-form", rush: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.rush_index_path(conn, :index))

      assert html =~ "Rush updated successfully"
      assert html =~ "some updated player_name"
    end

    test "deletes rush in listing", %{conn: conn, rush: rush} do
      {:ok, index_live, _html} = live(conn, Routes.rush_index_path(conn, :index))

      assert index_live |> element("#rush-#{rush.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#rush-#{rush.id}")
    end
  end

  describe "Show" do
    setup [:create_rush]

    test "displays rush", %{conn: conn, rush: rush} do
      {:ok, _show_live, html} = live(conn, Routes.rush_show_path(conn, :show, rush))

      assert html =~ "Show Rush"
      assert html =~ rush.player_name
    end

    test "updates rush within modal", %{conn: conn, rush: rush} do
      {:ok, show_live, _html} = live(conn, Routes.rush_show_path(conn, :show, rush))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Rush"

      assert_patch(show_live, Routes.rush_show_path(conn, :edit, rush))

      assert show_live
             |> form("#rush-form", rush: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#rush-form", rush: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.rush_show_path(conn, :show, rush))

      assert html =~ "Rush updated successfully"
      assert html =~ "some updated player_name"
    end
  end
end
