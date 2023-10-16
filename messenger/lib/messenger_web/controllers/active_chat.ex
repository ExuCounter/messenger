defmodule MessengerWeb.ActiveChatLive do
  use Phoenix.LiveComponent
  import MessengerWeb.BaseComponents

  def render(assigns) do
    ~H"""
    <div>
      <div :if={assigns.chat}>
        <div :for={message <- @chat.messages}>
          <.live_component module={MessengerWeb.Message} message={message} id={message.id} />
        </div>
        <.form for={@form} phx-submit="save" phx-target={@myself}>
          <.textarea type="text" field={@form[:body]} placeholder="Chat body" />
          <button>Send</button>
        </.form>
      </div>
    </div>
    """
  end

  def update(assigns, socket) do
    form =
      Messenger.Message.send_message_changeset(%Messenger.Message{}, %{
        body: "body"
      })
      |> to_form()

    {:ok, assign(socket, form: form, chat: assigns.chat, user_id: assigns.current_user_id)}
  end

  def handle_event("save", %{"message" => message} = _params, socket) do
    Messenger.Message.send_message(
      message
      |> Map.put("chat_id", socket.assigns.chat.id)
      |> Map.put("user_id", socket.assigns.user_id)
    )

    chat =
      Messenger.Chat.get_chat_by_id(socket.assigns.chat.id) |> Messenger.Repo.preload(:messages)

    {:noreply, assign(socket, chat: chat)}
  end
end
