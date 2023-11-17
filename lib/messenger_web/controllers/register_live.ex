defmodule MessengerWeb.RegisterLive do
  use MessengerWeb, :live_view
  import MessengerWeb.Header

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        form: to_form(Messenger.User.create_user_changeset(%Messenger.User{}, %{email: ""})),
        error: nil
      )

    {:ok, socket}
  end

  def handle_event("validate", %{"user" => user} = _params, socket) do
    form =
      %Messenger.User{}
      |> Messenger.User.create_user_changeset(user)
      |> Map.put(:action, :insert)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("login", _params, socket) do
    {:noreply, push_navigate(socket, to: "/login")}
  end

  def handle_event("redirect_to_chats", _params, socket) do
    {:noreply, push_navigate(socket, to: "/chats")}
  end

  def handle_event("save", %{"user" => user} = _params, socket) do
    with {:ok, created_user} <- Messenger.User.create_user(user),
         {:ok, _logged_user} <-
           Messenger.User.login(%{email: user["email"], password: user["password"]}),
         {:ok, token, _claims} <- Messenger.Guardian.encode_and_sign(created_user) do
      {:noreply, push_event(socket, "setSession", %{token: token})}
    else
      {:error, _changeset} ->
        {:noreply, assign(socket, error: "Email already taken")}

      _ ->
        {:noreply, "Something goes wrong"}
    end
  end
end
