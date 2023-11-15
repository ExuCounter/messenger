defmodule MessengerWeb.ChatsLive do
  use MessengerWeb, :live_view

  def mount(_params, session, socket) do
    user = Messenger.Repo.preload(session["current_user"], [:chats])

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
       active_chat: nil
     )}
  end

  def handle_info(:reload_chats, socket) do
    IO.inspect("reload")

    {:noreply,
     assign(socket,
       current_user:
         socket.assigns.current_user |> Messenger.Repo.reload() |> Messenger.Repo.preload(:chats)
     )}

    # else
    #   {:error, error} ->
    #     {:noreply, assign(socket, error: error)}
    # end
  end

  def handle_event("save", %{"chat" => chat} = _params, socket) do
    Messenger.Chat.create_chat(%{user_id: socket.assigns.current_user.id, title: chat["title"]})

    {:ok,
     assign(socket, current_user: Messenger.Repo.preload(socket.assigns.current_user, :chats))}

    # else
    #   {:error, error} ->
    #     {:noreply, assign(socket, error: error)}
    # end
  end

  def handle_event("logout", _params, socket) do
    {:noreply, push_event(socket, "removeSession", %{})}
  end

  def handle_event("redirect_to_login", _params, socket) do
    {:noreply, push_navigate(socket, to: "/login")}
  end

  def handle_event("open_chat", %{"chat_id" => chat_id} = _params, socket) do
    chat =
      Messenger.Chat.get_chat_by_id(chat_id) |> Messenger.Repo.preload(:messages)

    {:noreply, assign(socket, active_chat: chat)}
  end
end
