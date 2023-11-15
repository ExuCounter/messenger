defmodule MessengerWeb.Message do
  use Phoenix.LiveComponent

  def render(assigns) do
    assigns = assign(assigns, :message, assigns.message |> Messenger.Repo.preload(:user))

    ~H"""
    <div class="pt-4 pl-4 pr-4 max-w-[70%] w-fit">
      <div class="text-sm pb-1">
        <%= assigns.message.user.email %>
      </div>
      <div class="p-4 bg-secondary-800 text-white rounded-xl relative">
        <div class="message_body">
          <%= assigns.message.body %>
        </div>
        <div class="absolute right-4 bottom-4 text-secondary-200 text-sm">
          <%= assigns.message.updated_at |> Calendar.strftime("%H:%S") %>
        </div>
      </div>
    </div>
    """
  end
end
