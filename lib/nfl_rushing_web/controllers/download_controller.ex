NimbleCSV.define(NflRushing.CsvParser, seperator: "\t", escape: "\"")

defmodule NflRushingWeb.DownloadController do
  use NflRushing.Context
  use NflRushingWeb, :controller

  def index(conn, %{"mime" => "csv"} = params) do
    result = list_rushes(params) |> Rush.to_csv()
    csv(conn, 200, result)
  end

  def csv(conn, status, term) do
    conn
    |> put_status(status)
    |> send_download({:binary, NflRushing.CsvParser.dump_to_iodata(term)}, filename: "rushing.csv")
  end

  def list_rushes(opts) do
    opts |> NflRushing.Stats.RushQueryParams.parse() |> Stats.query_rushes()
  end
end
