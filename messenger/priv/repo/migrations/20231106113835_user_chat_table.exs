defmodule Messenger.Repo.Migrations.UserChatTable do
  use Ecto.Migration

  def change do
    create table("user_chat", primary_key: false) do
      add(:chat_id, references(:chats, on_delete: :delete_all), primary_key: true)
      add(:user_id, references(:users, on_delete: :delete_all), primary_key: true)
      timestamps()
    end

    create(index(:user_chat, [:chat_id]))
    create(index(:user_chat, [:user_id]))
  end
end
