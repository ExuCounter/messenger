defmodule MessengerWeb.Message do
  use Phoenix.LiveComponent

  def render(assigns) do
    assigns = assign(assigns, :message, assigns.message |> Messenger.Repo.preload(:user))

    ~H"""
    <div class={"pt-4 pl-4 pr-4 max-w-[70%] w-fit #{if @current_user_id == @message.user_id, do: "ml-auto"}"}>
      <div :if={@current_user_id != @message.user_id} class="text-sm pb-1">
        <%= assigns.message.user.nickname %>
      </div>
      <div class="p-4 pb-8 pr-[80px] bg-secondary-800 text-white rounded-xl relative">
        <div class="message_body">
          <%= assigns.message.body %>
        </div>
        <div class="absolute right-4 bottom-4 text-secondary-200 text-sm">
          <%= assigns.message.updated_at |> Calendar.strftime("%H:%M") %>
        </div>
      </div>
    </div>
    """
  end

  def update(assigns, socket) do
    {:ok,
     assign(socket,
       current_user_id: assigns.current_user_id,
       message: assigns.message
     )}
  end
end
