defmodule NflRushingWeb.RushLive.Index do
  use NflRushingWeb, :live_view

  alias NflRushing.Stats
  alias NflRushing.Stats.Rush

  #   defmodule Params do
  #     use Ecto.Schema
  #     import Ecto.Changeset

  #     embedded_schema do
  #        field :order_key, :string, default: "player_name"
  #        field :order_dir, :string, default: "asc"
  #     end

  #     def changeset(params \\ %__MODULE__{}, attrs \\ %{})

  #     def changeset(params, attrs) do
  #     end
  #   end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     assign(socket,
       loading: false,
       search: nil,
       order_key: :player_name,
       order_dir: :asc
     )
     |> put_params(params)
     |> put_rushes()}
  end

  @impl true
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
    |> put_params(params)
    |> put_rushes()
    |> assign(:page_title, "Rushing")
    |> assign(:rush, nil)
  end

  @impl true
  def handle_event("search", %{"q" => search}, socket) do
    socket =
      socket
      |> assign(:search, search)
      |> put_rushes()

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    rush = Stats.get_rush!(id)
    {:ok, _} = Stats.delete_rush(rush)

    {:noreply, assign(socket, :rushes, list_rushes())}
  end

  @valid_sort_by Rush.__schema__(:fields) |> Enum.map(&to_string/1)
  @valid_dir ["asc", "desc"]

  defp put_params(socket, params) do
    query_args =
      Enum.flat_map(params, fn
        {"dir", v} when v in @valid_dir -> [order_dir: String.to_existing_atom(v)]
        {"sort_by", v} when v in @valid_sort_by -> [order_key: String.to_existing_atom(v)]
        {"q", v} -> [search: v]
        {_k, _v} -> []
      end)

    socket
    |> assign(query_args)
  end

  use NflRushing.Context

  defp put_rushes(socket) do
    assign(socket, :rushes, list_rushes(socket.assigns))
  end

  defp list_rushes(opts) do
    Stats.query_rushes(opts)
  end

  defp list_rushes() do
    Stats.list_rushes()
  end

  def sort_link(socket, %{text: text, dir: dir, key: key, field: field}) do
    live_patch(text,
      to:
        Routes.rush_index_path(
          socket,
          :index,
          sort_by: field,
          dir: toggle_dir(field, key, dir)
        )
    )
  end

  def sort_link(socket, %{text: text, field: field, query: query}) do
    live_patch(text,
      to: Routes.rush_index_path(socket, :index, sort_by: field, dir: toggle_dir(field, query))
    )
  end

  def sort_link(socket, opts) when is_list(opts) do
    sort_link(socket, Map.new(opts))
  end

  @doc """
  Toggle the current value of `query.order.dir` if `field` is being ordered on.
  Otherwise, return :asc.
  """
  def toggle_dir(field, field, :asc), do: :desc
  def toggle_dir(_field, _key, _query), do: :asc
  def toggle_dir(_field, _query), do: :asc

  @doc """
  Return the direction of the field as an atom. Nil if the field is not
  sorted.
  """
  def sort_dir(field, field, dir), do: dir
  def sort_dir(_field, _key, _dir), do: nil

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
      {gettext("First downs"), :first_downs},
      {gettext("First down percentage"), :first_down_percentage},
      {gettext("Twenty plus"), :twenty_plus},
      {gettext("Forty plus"), :forty_plus},
      {gettext("Fumbles"), :fumbles}
    ]
  end
end
