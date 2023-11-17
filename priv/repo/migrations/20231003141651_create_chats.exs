defmodule Messenger.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table("chats") do
      add :title, :string
      add :user_id, references(:users)
    end
  end
end
