defmodule NflRushing.Stats do
  @moduledoc """
  The Stats context.
  """

  import Ecto.Query, warn: false
  alias NflRushing.Repo

  alias NflRushing.Stats.Rush

  @doc """
  Returns the list of rushes.

  ## Examples

      iex> list_rushes()
      [%Rush{}, ...]

  """
  def list_rushes do
    Repo.all(Rush)
  end

  def query_rushes(%{search: search, order_key: key, order_dir: dir}) do
    from(r in Rush,
      order_by: [{^dir, ^key}],
      where: ilike(r.player_name, ^"%#{search}%")
    )
    |> Repo.all()
  end

  @doc """
  Gets a single rush.

  Raises `Ecto.NoResultsError` if the Rush does not exist.

  ## Examples

      iex> get_rush!(123)
      %Rush{}

      iex> get_rush!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rush!(id), do: Repo.get!(Rush, id)

  @doc """
  Creates a rush.

  ## Examples

      iex> create_rush(%{field: value})
      {:ok, %Rush{}}

      iex> create_rush(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rush(attrs \\ %{}) do
    %Rush{}
    |> Rush.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rush.

  ## Examples

      iex> update_rush(rush, %{field: new_value})
      {:ok, %Rush{}}

      iex> update_rush(rush, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rush(%Rush{} = rush, attrs) do
    rush
    |> Rush.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rush.

  ## Examples

      iex> delete_rush(rush)
      {:ok, %Rush{}}

      iex> delete_rush(rush)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rush(%Rush{} = rush) do
    Repo.delete(rush)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rush changes.

  ## Examples

      iex> change_rush(rush)
      %Ecto.Changeset{data: %Rush{}}

  """
  def change_rush(%Rush{} = rush, attrs \\ %{}) do
    Rush.changeset(rush, attrs)
  end

end
