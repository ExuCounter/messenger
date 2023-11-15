defmodule MessengerWeb.SearchLive do
  use MessengerWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="search pb-4">
      <.form for={@form} phx-submit="on_submit" phx-target={@myself}>
        <.field
          type="search"
          field={@form[:search]}
          phx-change="on_search"
          label="Search users"
          label_class="font-bold text-base text-secondary-100"
          placeholder="Type here..."
        />
      </.form>
      <.button
        :for={user <- @users}
        class="w-full mb-4"
        phx-click="on_create_direct_chat"
        phx-value-user_id={user.id}
        phx-target={@myself}
      >
        <%= user.email %>
      </.button>
    </div>
    """
  end

  def handle_event("on_search", %{"search" => search}, socket) do
    users = Messenger.User.search_users(%{search: search})

    {:noreply, assign(socket, users: users)}
  end

  def handle_event("on_create_direct_chat", %{"user_id" => user_id} = _params, socket) do
    case Messenger.Chat.maybe_create_direct_chat_with_user(%{
           user_id: socket.assigns.current_user_id,
           required_user_id: user_id,
           title: "Chat with this user"
         })
         |> IO.inspect() do
      {:ok, chat} ->
        send_update(MessengerWeb.ActiveChatLive,
          id: "active_chat",
          chat: chat,
          current_user_id: socket.assigns.current_user_id
        )

        send(self(), :reload_chats)

        {:noreply, socket}

      {:existing_chat, chat} ->
        send_update(MessengerWeb.ActiveChatLive,
          id: "active_chat",
          chat: chat,
          current_user_id: socket.assigns.current_user_id
        )

        send(self(), :reload_chats)

        {:noreply, socket}
    end
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(
        form: to_form(%{"search" => ""}),
        users: [],
        current_user_id: assigns.current_user_id
      )

    {:ok, socket}
  end
end
