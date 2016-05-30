ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Aspirin.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Aspirin.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Aspirin.Repo)

