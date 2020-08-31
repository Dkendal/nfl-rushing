# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

NflRushing.JsonImport.import_file!("rushing.json")
