defmodule Messenger.Chat do
  use Ecto.Schema
  alias Messenger.Repo
  import Ecto.Changeset

  alias __MODULE__

  schema "chats" do
    field :title, :string

    has_many(:messages, Messenger.Message)
    belongs_to(:user, Messenger.User)
    has_many(:users, Messenger.User)

    timestamps()
  end

  def create_chat_changeset(chat, attrs) do
    chat |> cast(attrs, [:user_id, :title]) |> validate_required([:user_id, :title])
  end

  def create_chat(params) do
    changeset = create_chat_changeset(%Chat{}, params)
    Repo.insert(changeset)
  end

  def get_chat_by_id(chat_id) do
    Repo.get_by(Chat, id: chat_id)
  end
end
