defmodule NflRushing.Context do
  defmacro __using__(_) do
    quote do
      import Ecto, only: [assoc: 2], warn: false
      import Ecto.Query, only: [from: 1, from: 2], warn: false
      import Ecto.Changeset, warn: false

      alias Ecto.Changeset, warn: false

      alias NflRushing.{
              Repo,
              Stats.Rush,
              Stats
            },
            warn: false
    end
  end
end
