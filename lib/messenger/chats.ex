defmodule Messenger.Chat do
  use Ecto.Schema
  alias Messenger.Repo
  import Ecto.Changeset
  import Ecto.Query

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

  def maybe_create_direct_chat_with_user(params) do
    query =
      from u in Messenger.User,
        where: u.id == ^params.user_id,
        join: c in assoc(u, :chats),
        join: cu in assoc(c, :users),
        where: ^params.required_user_id == cu.id,
        select: %{id: c.id}

    existing_chat = Repo.one(query)

    if existing_chat do
      {:existing_chat, get_chat_by_id(existing_chat.id)}
    else
      {:ok, chat} = create_chat(params)

      {:ok, updated_chat} =
        add_user_to_chat_by_id(%{chat_id: chat.id, user_id: params.required_user_id})

      {:ok, updated_chat}
    end
  end

  def get_chat_by_id(chat_id) do
    Repo.get_by(Chat, id: chat_id) |> Repo.preload([:users, :messages])
  end
end
