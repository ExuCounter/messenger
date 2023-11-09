defmodule MessageTest do
  use MessengerWeb.ConnCase, async: true

  setup_all do
    raw_user = %{email: "test@gmail.com", password: "mypassword"}

    %{
      raw_user: raw_user
    }
  end

  test "send message", %{raw_user: raw_user} do
    {:ok, created_user} = Messenger.User.create_user(raw_user)
    {:ok, chat} = Messenger.Chat.create_chat(%{title: "My chat", user_id: created_user.id})

    {:ok, message} =
      Messenger.Message.send_message(%{
        body: "New message",
        user_id: created_user.id,
        chat_id: chat.id
      })

    message_from_chat =
      chat |> Messenger.Repo.preload(:messages) |> Map.get(:messages) |> List.first()

    assert message.body == "New message"
    assert message_from_chat.id == message.id
  end
end
