defmodule Messenger.UserChat do
  @moduledoc """
  ChatProject module
  """

  use Ecto.Schema

  @primary_key false
  schema "user_chat" do
    belongs_to(:user, Messenger.User, primary_key: true)
    belongs_to(:chat, Messenger.Chat, primary_key: true)

    timestamps()
  end
end
