defmodule MessengerWeb.ActiveChatLive do
  use MessengerWeb, :live_component

  def mount(socket) do
    {:ok, push_event(socket, "scroll_to_bottom", %{})}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-secondary-100 h-full">
      <div :if={@chat}>
        <div class="h-[calc(100vh-8.6rem)] overflow-y-scroll" id="scrollable-chat">
          <div :if={length(@chat.messages) > 0}>
            <%= for i <- 0..length(@chat.messages) - 1 do %>
              <div
                :if={i === 0}
                class="bg-primary-200 px-4 py-2 rounded-xl mt-5 text-center w-fit mx-auto block text-sm"
              >
                <%= Enum.at(@chat.messages, i).inserted_at |> Calendar.strftime("%d %B %Y") %>
              </div>
              <span
                :if={
                  i >= 1 &&
                    Enum.at(@chat.messages, i).inserted_at.day >
                      Enum.at(@chat.messages, i - 1).inserted_at.day
                }
                class="bg-primary-200 px-4 py-2 rounded-xl mt-5 text-center w-fit mx-auto block text-sm"
              >
                <%= Enum.at(@chat.messages, i).inserted_at |> Calendar.strftime("%d %B %Y") %>
              </span>
              <.live_component
                module={MessengerWeb.Message}
                message={Enum.at(@chat.messages, i)}
                id={Enum.at(@chat.messages, i).id}
                current_user_id={@user_id}
              />
            <% end %>
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
          class="p-4 h-[8.6rem] box-border mt-auto"
        >
          <.input type="textarea" field={@form[:body]} placeholder="Type here..." />
          <.button class="w-full mt-2" disabled={!@form.source.valid?}>Send</.button>
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

    active_chat_id = Map.get(assigns, :active_chat_id, nil)

    if active_chat_id do
      {:ok,
       push_event(
         assign(socket,
           form: form,
           chat: active_chat_id |> Messenger.Chat.get_chat_by_id(),
           user_id: assigns.current_user_id
         ),
         "scroll_to_bottom",
         %{}
       )}
    else
      {:ok,
       assign(socket,
         form: form,
         chat: nil,
         user_id: assigns.current_user_id
       )}
    end
  end

  def handle_event("save", %{"message" => message} = _params, socket) do
    {:ok, new_message} =
      Messenger.Message.send_message(
        message
        |> Map.put("chat_id", socket.assigns.chat.id)
        |> Map.put("user_id", socket.assigns.user_id)
      )

    MessengerWeb.Endpoint.broadcast!("room:#{socket.assigns.chat.id}", "new_msg", new_message)

    {:noreply,
     push_event(
       assign(socket,
         chat:
           Map.put(socket.assigns.chat, :messages, socket.assigns.chat.messages ++ [new_message])
       ),
       "scroll_to_bottom",
       %{}
     )}
  end
end
