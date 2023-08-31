defmodule Messenger.User do
  use Ecto.Schema
  alias Messenger.Repo
  import Ecto.Changeset

  alias __MODULE__

  schema "users" do
    field :email, :string
    has_many(:messages, Messenger.Message, foreign_key: :sender_id)

    timestamps()
  end

  def validate_email(changeset, field) do
    validate_change(changeset, field, fn ^field, email ->
      if String.contains?(email, "@") do
        []
      else
        [email: "is not valid email"]
      end
    end)
  end

  def create_user_changeset(user, attrs) do
    user |> cast(attrs, [:email]) |> validate_required([:email]) |> validate_email(:email)
  end

  def create_user(user) do
    changeset = create_user_changeset(%User{}, user)
    Repo.insert(changeset)
  end

  def get_user_by_id(user_id) do
    Repo.get_by!(User, id: user_id)
  end
end
