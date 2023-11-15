defmodule MessengerWeb.ActiveChatLive do
  use MessengerWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="bg-secondary-100 h-full">
      <div :if={@chat}>
        <div class="h-[calc(100vh-88px)] overflow-y-scroll">
          <div :for={message <- @chat.messages} :if={length(@chat.messages) > 0}>
            <.live_component module={MessengerWeb.Message} message={message} id={message.id} />
          </div>
          <div
            :if={length(@chat.messages) === 0}
            class="w-full h-full flex justify-center items-center"
          >
            There is no messages yet
          </div>
        </div>
        <.form
          for={@form}
          phx-submit="save"
          phx-target={@myself}
          class="p-4 h-88px box-border mt-auto"
        >
          <.input type="textarea" field={@form[:body]} placeholder="Type here..." />
          <.button class="w-full mt-2">Send</.button>
        </.form>
      </div>
      <div :if={!@chat} class="w-full h-full flex items-center justify-center">
        <span>
          Select chat to start messaging
        </span>
      </div>
    </div>
    """
  end

  def update(assigns, socket) do
    form =
      Messenger.Message.send_message_changeset(%Messenger.Message{}, %{
        body: ""
      })
      |> to_form()

    {:ok,
     assign(socket,
       form: form,
       chat: assigns.chat,
       user_id: assigns.current_user_id
     )}
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
