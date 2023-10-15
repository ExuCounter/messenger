defmodule Messenger.Repo.Migrations.RemoveUsersTableFields do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      remove_if_exists :sender_id, references(:users)
      remove_if_exists :receiver_id, references(:users)
      add :user_id, references(:users)
    end
  end
end
