defmodule ChatTest do
  use MessengerWeb.ConnCase, async: true

  setup_all do
    raw_user = %{email: "test@gmail.com", nickname: "test", password: "mypassword"}

    %{
      raw_user: raw_user
    }
  end

  test "create user chat", %{raw_user: raw_user} do
    {:ok, created_user} = Messenger.User.create_user(raw_user)
    {:ok, chat} = Messenger.Chat.create_chat(%{title: "My chat", user_id: created_user.id})

    preloaded_chat_from_user =
      created_user |> Messenger.Repo.preload(:chats) |> Map.get(:chats) |> List.first()

    assert preloaded_chat_from_user.id == chat.id
    assert preloaded_chat_from_user.title == "My chat"
  end

  test "add user to chat", %{raw_user: raw_user} do
    {:ok, created_user} = Messenger.User.create_user(raw_user)

    {:ok, another_created_user} =
      Messenger.User.create_user(%{
        email: "another_user@gmail.com",
        nickname: "another",
        password: "password"
      })

    {:ok, chat} = Messenger.Chat.create_chat(%{title: "My chat", user_id: created_user.id})

    {:ok, updated_chat} =
      Messenger.Chat.add_user_to_chat_by_id(%{chat_id: chat.id, user_id: another_created_user.id})

    assert updated_chat.users == [another_created_user, created_user]
  end
end
