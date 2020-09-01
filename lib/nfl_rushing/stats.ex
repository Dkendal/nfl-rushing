defmodule NflRushing.Stats.RushQueryParams do
  alias NflRushing.Stats.Rush

  # defstruct([:order_dir, :order_key, :page, :size, :search])

  @valid_sort_by Rush.fields() |> Enum.map(&to_string/1)
  @valid_dir ["asc", "desc"]

  def parse(params) do
    Enum.flat_map(params, fn
      {"dir", v} when v in @valid_dir ->
        [order_dir: String.to_existing_atom(v)]

      {"sort_by", v} when v in @valid_sort_by ->
        [order_key: String.to_existing_atom(v)]

      {"page", v} ->
        {int, _} = Integer.parse(v)
        [page: int]

      {"size", v} ->
        {int, _} = Integer.parse(v)
        [size: int]

      {"q", v} ->
        [search: v]

      {_k, _v} ->
        []
    end)
    |> Map.new()
  end
end

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

  def count_rushes(opts) do
    rushes_query(opts)
    |> limit(nil)
    |> offset(nil)
    |> Repo.aggregate(:count)
  end

  def query_rushes(opts) when is_map(opts) do
    Repo.all(rushes_query(opts))
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

  defp paginate(query, page, size) do
    from query,
      limit: ^size,
      offset: ^((page - 1) * size)
  end

  defp rushes_query(opts) do
    query = Rush

    query =
      case opts do
        %{order_key: key, order_dir: dir} -> from(query, order_by: {^dir, ^key})
        _ -> query
      end

    query =
      case opts do
        %{page: page} -> paginate(query, page, Map.get(opts, :size, 10))
        _ -> query
      end

    case opts do
      %{search: search} -> from(r in query, where: ilike(r.player_name, ^"%#{search}%"))
      _ -> query
    end
  end
end
