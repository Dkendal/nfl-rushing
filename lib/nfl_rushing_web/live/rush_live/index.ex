defmodule NflRushingWeb.RushLive.Index do
  use NflRushingWeb, :live_view

  alias NflRushing.Stats
  alias NflRushing.Stats.Rush

  defstruct []

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, :rushes, list_rushes(params))}
  end

  @impl true
  def handle_params(%{"sort_by" => _, "dir" => _} = params, _url, socket) do
    {:noreply,
     socket
     |> assign(:rushes, list_rushes(params))
     |> apply_action(socket.assigns.live_action, params)}
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

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Rushes")
    |> assign(:rush, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    rush = Stats.get_rush!(id)
    {:ok, _} = Stats.delete_rush(rush)

    {:noreply, assign(socket, :rushes, list_rushes())}
  end

  defp list_rushes(%{"sort_by" => sort_field, "dir" => dir}) do
    use NflRushing.Context

    from(r in Rush, order_by: [asc: ^String.to_existing_atom(sort_field)])
    |> Repo.all()
  end

  defp list_rushes() do
    Stats.list_rushes()
  end

  # Templating

  def sort_link(socket, text, field) do
    live_patch(text, to: Routes.rush_index_path(socket, :index, sort_by: field, dir: :asc))
  end
end
