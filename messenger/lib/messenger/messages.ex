defmodule Messenger.Message do
  use Ecto.Schema
  alias Messenger.Repo
  import Ecto.Changeset

  alias __MODULE__

  schema "messages" do
    field :receiver_id, :integer
    field :sender_id, :integer
    field :body, :string

    belongs_to(:users, Messenger.User, define_field: false, foreign_key: :sender_id)

    timestamps()
  end

  def send_message_changeset(message, attrs) do
    message
    |> cast(attrs, [:sender_id, :receiver_id, :body])
    |> validate_required([:sender_id, :receiver_id, :body])
  end

  def send_message(params) do
    changeset = send_message_changeset(%Message{}, params)

    Repo.insert(changeset)
  end
end
