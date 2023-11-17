defmodule Messenger.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :sender_id, references(:users)
      add :receiver_id, references(:users)
      add :body, :string

      timestamps()
    end
  end
end
