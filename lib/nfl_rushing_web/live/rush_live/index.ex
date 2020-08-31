defmodule NflRushingWeb.RushLive.Index do
  use NflRushingWeb, :live_view

  alias NflRushing.Stats
  alias NflRushing.Stats.Rush

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, rushes: list_rushes())}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Rush")
    |> assign(:rush, Stats.get_rush!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Rush")
    |> assign(:rush, %Rush{})
  end

  defp apply_action(socket, :index, params) do
    socket
    |> parse_query(params)
    |> (&assign(&1, :rushes, list_rushes(&1.assigns.query))).()
    |> assign(:page_title, "Rushing")
    |> assign(:rush, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    rush = Stats.get_rush!(id)
    {:ok, _} = Stats.delete_rush(rush)

    {:noreply, assign(socket, :rushes, list_rushes())}
  end

  @valid_sort_by Rush.__schema__(:fields) |> Enum.map(&to_string/1)
  @valid_dir ["asc", "desc"]

  @default_query %{
    order: %{by: :player_name, dir: :asc}
  }

  def parse_query(socket, params, query \\ @default_query)

  def parse_query(socket, %{"sort_by" => key, "dir" => dir} = params, query)
      when dir in @valid_dir and key in @valid_sort_by do
    query =
      Map.put(query, :order, %{
        by: String.to_existing_atom(key),
        dir: String.to_existing_atom(dir)
      })

    params = Map.drop(params, ["sort_by", "dir"])

    parse_query(socket, params, query)
  end

  def parse_query(socket, _params, query) do
    # Base case and default sorting options
    assign(socket, :query, query)
  end

  # All of this could be moved to a Stats or another module
  use NflRushing.Context

  defp build_query(query, opts) when is_map(opts) do
    build_query(query, Map.to_list(opts))
  end

  defp build_query(query, [{:order, %{dir: dir, by: by}} | opts]) do
    query
    |> from(order_by: [{^dir, ^by}])
    |> build_query(opts)
  end

  defp build_query(query, [_h | t]), do: build_query(query, t)

  defp build_query(query, []), do: query

  defp list_rushes(assigns) do
    Rush
    |> build_query(assigns)
    |> Repo.all()
  end

  defp list_rushes() do
    Stats.list_rushes()
  end

  @doc """
  Toggle the current value of `query.order.dir` if `field` is being ordered on.
  Otherwise, return :asc.
  """
  def toggle_dir(field, %{order: %{by: field, dir: :asc}}), do: :desc
  def toggle_dir(field, %{order: %{by: field, dir: :desc}}), do: :asc
  def toggle_dir(_field, _query), do: :asc

  def sort_link(socket, %{text: text, field: field, query: query}) do
    live_patch(text,
      to: Routes.rush_index_path(socket, :index, sort_by: field, dir: toggle_dir(field, query))
    )
  end

  def sort_link(socket, opts) when is_list(opts) do
    sort_link(socket, Map.new(opts))
  end

  @doc """
  Return the direction of the field as an atom. Nil if the field is not
  sorted.
  """
  def sort_dir(field, %{order: %{by: field, dir: dir}}), do: dir
  def sort_dir(_field, _query), do: nil

  def table_headers() do
    [
      {gettext("Player name"), :player_name},
      {gettext("Team abbr"), :team_abbr},
      {gettext("Position"), :position},
      {gettext("Attempts per game"), :attempts_per_game},
      {gettext("Attempts"), :attempts},
      {gettext("Total yards"), :total_yards},
      {gettext("Avg yards per attempt"), :avg_yards_per_attempt},
      {gettext("Yards per game"), :yards_per_game},
      {gettext("Touchdowns"), :touchdowns},
      {gettext("Longest"), :longest},
      {gettext("Longest is touchdown"), :longest_is_touchdown},
      {gettext("First downs"), :first_downs},
      {gettext("First down percentage"), :first_down_percentage},
      {gettext("Twenty plus"), :twenty_plus},
      {gettext("Forty plus"), :forty_plus},
      {gettext("Fumbles"), :fumbles}
    ]
  end
end
