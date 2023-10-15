defmodule Messenger.Message do
  use Ecto.Schema
  alias Messenger.Repo
  import Ecto.Changeset

  alias __MODULE__

  schema "messages" do
    field :body, :string

    belongs_to(:chat, Messenger.Chat)
    belongs_to(:user, Messenger.User)

    timestamps()
  end

  def send_message_changeset(message, attrs) do
    message
    |> cast(attrs, [:body, :user_id, :chat_id])
    |> validate_required([:body, :user_id, :chat_id])
  end

  def edit_message_changeset(message, attrs) do
    message
    |> cast(attrs, [:body, :user_id, :chat_id])
    |> validate_required([:body, :user_id, :chat_id])
  end

  def send_message(params) do
    changeset = send_message_changeset(%Message{}, params)

    Repo.insert(changeset)
  end

  def get_message_by_id(message_id) do
    Repo.get_by!(Message, id: message_id)
  end

  def edit_message(message_id, body) do
    message = Repo.get!(Message, message_id)
    changeset = message |> Ecto.Changeset.change(body: body)

    Repo.update(changeset)
  end
end
