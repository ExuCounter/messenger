defmodule MessengerWeb.RegisterLive do
  use Phoenix.LiveView
  import Phoenix.Component
  import MessengerWeb.BaseComponents

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
    with {:ok, user} <- Messenger.User.create_user(user),
         {:ok, _logged_user} <-
           Messenger.User.login(user),
         {:ok, token, _claims} <- Messenger.Guardian.encode_and_sign(user) do
      {:noreply, push_event(socket, "setSession", %{token: token})}
    else
      _ -> {:noreply, assign(socket, error: "User is not created")}
    end
  end
end
