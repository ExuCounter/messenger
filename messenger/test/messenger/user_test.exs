defmodule UserTest do
  use MessengerWeb.ConnCase, async: true

  setup_all do
    raw_user = %{email: "test@gmail.com", nickname: "test", password: "mypassword"}

    %{
      raw_user: raw_user
    }
  end

  test "login user", %{raw_user: raw_user} do
    {:ok, _created_user} = Messenger.User.create_user(raw_user)

    {:ok, _logged_user} =
      Messenger.User.login(raw_user)
  end

  test "user login with wrong password", %{raw_user: raw_user} do
    {:ok, _created_user} = Messenger.User.create_user(raw_user)

    {:error, reason} =
      Messenger.User.login(%{email: raw_user.email, password: "wrong password"})

    assert reason == "Wrong password"
  end

  test "user login with non-existing email", %{raw_user: raw_user} do
    {:ok, _created_user} = Messenger.User.create_user(raw_user)

    {:error, reason} =
      Messenger.User.login(%{email: "wrong_email@gmail.com", password: raw_user.password})

    assert reason == "There is no such user"
  end
end
