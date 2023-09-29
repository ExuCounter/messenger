defmodule Messenger.User do
  use Ecto.Schema
  alias Messenger.Repo
  import Ecto.Changeset

  alias __MODULE__

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
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
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_email(:email)
    |> validate_length(:password, min: 2)
    |> put_password_hash(:password)
  end

  def put_password_hash(changeset, field) do
    if changeset.valid? do
      password_hash = Bcrypt.Base.hash_password("hard to guess", Bcrypt.Base.gen_salt(12, true))
      changeset |> put_change(:password_hash, password_hash)
    else
      changeset
    end
  end

  def create_user(user) do
    changeset = create_user_changeset(%User{}, user)
    Repo.insert(changeset)
  end

  def get_user_by_id(user_id) do
    Repo.get_by!(User, id: user_id)
  end

  def get_messages_by_user_id(user_id) do
    get_user_by_id(user_id) |> Repo.preload(:messages) |> Map.get(:messages)
  end
end
