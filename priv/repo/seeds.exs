# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Messenger.Repo.insert!(%Messenger.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Messenger.Seeds do
  alias Messenger.{User, Chat, Message, Repo}

  def seeds do
    clear()

    {:ok, user} = User.create_user(%{email: "test@gmail.com", password: "test"})
    {:ok, chat} = Chat.create_chat(%{user_id: user.id, title: "Test chat"})
    Message.send_message(%{user_id: user.id, chat_id: chat.id, body: "message"})
  end

  def clear do
    Repo.delete_all(Message)
    Repo.delete_all(Chat)
    Repo.delete_all(User)
  end
end

Messenger.Seeds.seeds()
