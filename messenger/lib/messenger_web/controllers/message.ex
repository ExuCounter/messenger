defmodule MessengerWeb.Message do
  use Phoenix.LiveComponent

  def render(assigns) do
    assigns = assign(assigns, :message, assigns.message |> Messenger.Repo.preload(:user))

    ~H"""
    <div class="message">
      <%= assigns.message.user.email %>
      <div class="message_body">
        <%= assigns.message.body %>
      </div>
    </div>
    """
  end
end
