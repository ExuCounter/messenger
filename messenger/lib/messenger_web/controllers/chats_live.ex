defmodule MessengerWeb.ChatsLive do
  use MessengerWeb, :live_view

  def mount(_params, session, socket) do
    user = Messenger.Repo.preload(session["current_user"], [:chats])

    if length(user.chats) > 0 do
      for i <- 0..(length(user.chats) - 1) do
        MessengerWeb.Endpoint.subscribe("room:#{Enum.at(user.chats, i).id}")
      end
    end

    {:ok,
     assign(socket,
       current_user: user,
       form:
         to_form(
           Messenger.Chat.create_chat_changeset(%Messenger.Chat{}, %{
             title: "",
             user_id: user.id
           })
         ),
       active_chat_id: nil
     )}
  end

  def handle_info(:reload_chats, socket) do
    {:noreply,
     assign(socket,
       active_chat_id: socket.assigns.active_chat_id
     )}
  end

  def handle_info(
        %Phoenix.Socket.Broadcast{
          event: _event,
          payload: payload,
          topic: _topic
        },
        socket
      ) do
    send_update(MessengerWeb.ActiveChatLive,
      id: "active_chat",
      active_chat_id: payload.chat_id,
      current_user_id: socket.assigns.current_user.id
    )

    {:noreply, socket}
  end

  def handle_event("logout", _params, socket) do
    {:noreply, push_event(socket, "removeSession", %{})}
  end

  def handle_event("redirect_to_login", _params, socket) do
    {:noreply, push_navigate(socket, to: "/login")}
  end

  def handle_event("open_chat", %{"chat_id" => chat_id} = _params, socket) do
    {:noreply, assign(socket, active_chat_id: chat_id)}
  end
end
