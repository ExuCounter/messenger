defmodule MessengerWeb.Message do
  use Phoenix.LiveComponent

  def render(assigns) do
    IO.inspect(assigns.message)

    ~H"""
    <div class="message">
      <div class="message_body">
        <%= assigns.message.body %>
      </div>
    </div>
    """
  end
end
