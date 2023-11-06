defmodule MessengerWeb.LoginLive do
  use Phoenix.LiveView
  import MessengerWeb.BaseComponents
  import MessengerWeb.Header

  def mount(_params, _session, socket) do
    {:ok,
     assign(
       socket,
       form: to_form(Messenger.User.create_user_changeset(%Messenger.User{}, %{})),
       error: nil
     )}
  end

  def handle_event("validate", %{"user" => user} = _params, socket) do
    form =
      %Messenger.User{}
      |> Messenger.User.login_user_changeset(user)
      |> Map.put(:action, :insert)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", %{"user" => user} = _params, socket) do
    with {:ok, user} <- Messenger.User.login(user),
         {:ok, token, _claims} <- Messenger.Guardian.encode_and_sign(user) do
      {:noreply, push_event(socket, "setSession", %{token: token})}
    else
      {:error, error} ->
        {:noreply, assign(socket, error: error)}
    end
  end

  def handle_event("sign_up", _params, socket) do
    {:noreply, push_navigate(socket, to: "/register")}
  end

  def handle_event("redirect_to_chats", _params, socket) do
    IO.inspect(~c"redirect")
    {:noreply, push_navigate(socket, to: "/chats")}
  end
end
