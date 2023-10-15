defmodule Messenger.Repo.Migrations.AddTimestampsToChats do
  use Ecto.Migration

  def change do
    alter table("chats") do
      timestamps()
    end
  end
end
