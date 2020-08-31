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
    |> put_rushes()
    |> assign(:page_title, "Listing Rushes")
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

  def parse_query(socket, %{"sort_by" => key, "dir" => dir} = params)
      when dir in @valid_dir and key in @valid_sort_by do
    key = String.to_existing_atom(key)
    dir = String.to_existing_atom(dir)

    socket
    |> assign(:order, %{by: key, dir: dir})
    |> parse_query(Map.drop(params, ["sort_by", "dir"]))
  end

  def parse_query(socket, _) do
    # Base case and default sorting options
    socket
    |> assign_new(:order, fn -> %{by: :name, dir: :asc} end)
  end

  def put_rushes(socket) do
    assign(socket, :rushes, list_rushes(socket.assigns))
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

  def toggle_dir(:asc), do: :desc
  def toggle_dir(:desc), do: :asc
  def toggle_dir(%{order: %{dir: dir}}), do: toggle_dir(dir)

  # Templating

  def sort_link(socket, assigns, text, field) do
    live_patch(text,
      to: Routes.rush_index_path(socket, :index, sort_by: field, dir: toggle_dir(assigns))
    )
  end
end
