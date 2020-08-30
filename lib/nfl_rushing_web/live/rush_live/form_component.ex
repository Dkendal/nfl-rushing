defmodule NflRushingWeb.RushLive.FormComponent do
  use NflRushingWeb, :live_component

  alias NflRushing.Stats

  @impl true
  def update(%{rush: rush} = assigns, socket) do
    changeset = Stats.change_rush(rush)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"rush" => rush_params}, socket) do
    changeset =
      socket.assigns.rush
      |> Stats.change_rush(rush_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"rush" => rush_params}, socket) do
    save_rush(socket, socket.assigns.action, rush_params)
  end

  defp save_rush(socket, :edit, rush_params) do
    case Stats.update_rush(socket.assigns.rush, rush_params) do
      {:ok, _rush} ->
        {:noreply,
         socket
         |> put_flash(:info, "Rush updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_rush(socket, :new, rush_params) do
    case Stats.create_rush(rush_params) do
      {:ok, _rush} ->
        {:noreply,
         socket
         |> put_flash(:info, "Rush created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
