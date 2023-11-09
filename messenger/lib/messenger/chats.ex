defmodule Messenger.Chat do
  use Ecto.Schema
  alias Messenger.Repo
  import Ecto.Changeset

  alias __MODULE__

  schema "chats" do
    field :title, :string

    has_many(:messages, Messenger.Message)
    belongs_to(:user, Messenger.User)
    many_to_many(:users, Messenger.User, join_through: Messenger.UserChat, on_replace: :delete)

    timestamps()
  end

  def create_chat_changeset(chat, attrs) do
    user = Messenger.User.get_user_by_id(attrs.user_id)

    chat
    |> cast(attrs, [:user_id, :title])
    |> validate_required([:user_id, :title])
    |> put_assoc(:users, [user])
  end

  def add_user_to_chat_by_id(params) do
    user = Messenger.User.get_user_by_id(params.user_id)
    chat = get_chat_by_id(params.chat_id) |> Repo.preload(:users)

    chat
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:users, [user | chat.users])
    |> Repo.update()
  end

  def create_chat(params) do
    changeset = create_chat_changeset(%Chat{}, params)
    Repo.insert(changeset)
  end

  def get_chat_by_id(chat_id) do
    Repo.get_by(Chat, id: chat_id)
  end
end
