defmodule Messenger.User do
  use Ecto.Schema
  alias Messenger.Repo
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias __MODULE__

  schema "users" do
    field :email, :string
    field :nickname, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    many_to_many(:chats, Messenger.Chat, join_through: Messenger.UserChat, on_replace: :delete)

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

  def format_errors(errors) do
    Enum.map(errors, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  def create_user_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :nickname])
    |> validate_required([:email, :password, :nickname])
    |> validate_email(:email)
    |> validate_length(:password, min: 2)
    |> unique_constraint(:email)
    |> put_password_hash(:password)
    |> delete_change(:password)
  end

  def login_user_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :nickname])
    |> validate_required([:email, :password, :nickname])
    |> validate_email(:email)
  end

  def put_password_hash(changeset, _field) do
    if changeset.valid? do
      password_hash =
        Bcrypt.Base.hash_password(changeset.changes.password, Bcrypt.Base.gen_salt(12, true))

      changeset |> put_change(:password_hash, password_hash)
    else
      changeset
    end
  end

  def create_user(user) do
    changeset = create_user_changeset(%User{}, user)
    Repo.insert(changeset)
  end

  def search_users(params) do
    if String.length(params.search) < 3 do
      []
    else
      query =
        from u in User,
          where: like(u.nickname, ^"#{params.search}%"),
          where: u.id not in ^params.excluded_ids

      Repo.all(query)
    end
  end

  def get_user_by_id(user_id) do
    Repo.get_by!(User, id: user_id)
  end

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def login(%{email: email, password: password} = _params) do
    case get_user_by_email(email) do
      nil ->
        {:error, "There is no such user"}

      user ->
        IO.inspect(user.password_hash)
        verified = Bcrypt.verify_pass(password, user.password_hash)

        if verified do
          {:ok, user}
        else
          {:error, "Wrong password"}
        end
    end
  end
end
