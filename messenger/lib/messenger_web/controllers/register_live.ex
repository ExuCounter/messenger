defmodule MessengerWeb.RegisterLive do
  use Phoenix.LiveView
  import Phoenix.Component
  import MessengerWeb.BaseComponents

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        :form,
        to_form(Messenger.User.create_user_changeset(%Messenger.User{}, %{email: ""}))
      )
      |> assign(:user, %Messenger.User{})
      |> IO.inspect()

    {:ok, socket}
  end

  def user(assigns) do
    ~H"""
    <div>
      <%= inspect(assigns.user) %>
    </div>
    """
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
    Messenger.User.create_user(user)

    with {:ok, user} <- Messenger.User.login(user) do
      {:ok, token, _claims} = Messenger.Guardian.encode_and_sign(user)
      {:noreply, push_event(socket, "setSession", %{token: token})}
    else
      _ -> {:noreply, socket}
    end
  end
end
