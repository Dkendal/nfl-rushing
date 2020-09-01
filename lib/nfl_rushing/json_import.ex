defmodule NflRushing.JsonImport do
  use NflRushing.Context

  alias NflRushing.Stats.Rush

  def normalize_longist(rush = %{longest: lng}) when is_integer(lng), do: rush

  def normalize_longist(rush = %{longest: lng}) when is_binary(lng) do
    case Integer.parse(lng) do
      {lng, ""} ->
        Map.put(rush, :longest, lng)

      {lng, "T"} ->
        rush
        |> Map.put(:longest, lng)
        |> Map.put(:longest_is_touchdown, true)
    end
  end

  @doc """
  Parse a comma seperated integer.

  Not defined for invalid input.

  # Examples
  iex> string_to_integer("123,345,678")
  123_345_678
  """
  def string_to_integer(s) when is_binary(s),
    do: String.replace(s, ",", "") |> String.to_integer()

  def string_to_integer(i) when is_integer(i), do: i

  @doc """
  Convert an object from rushing.json to a Rush struct.
  """
  def to_struct(record) do
    Enum.map(record, fn {k, v} -> {Rush.abbr_to_field(k), v} end)
    |> Map.new()
    |> normalize_longist()
    |> Map.update!(:total_yards, &string_to_integer/1)
    |> (&Stats.change_rush(%Rush{}, &1)).()
    |> Changeset.apply_action!(:validate)
  end

  def decode_json(json) do
    json
    |> Jason.decode!(keys: :atoms!)
    |> Enum.map(&to_struct/1)
  end

  def import_file!(filename) do
    now =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    fields = Rush.__schema__(:fields) -- [:id, :inserted_at, :updated_at]

    File.read!(filename)
    |> decode_json()
    |> Enum.map(
      &(&1
        |> Map.take(fields)
        |> Map.put(:inserted_at, now)
        |> Map.put(:updated_at, now))
    )
    |> (&Repo.insert_all(Rush, &1)).()
  end
end
