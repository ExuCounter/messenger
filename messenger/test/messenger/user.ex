defmodule UserTest do
  use MessengerWeb.ConnCase, async: true

  alias Messenger.User
  alias Messenger.Repo

  test "create user" do
    user = Repo.insert!(%User{}) |> IO.inspect()
    IO.inspect(user)
    assert user = %User{}
  end
end
