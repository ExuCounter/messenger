defmodule MessengerWeb.Message do
  use Phoenix.LiveComponent

  def render(assigns) do
    IO.inspect(assigns.message)

    ~H"""
    <div>
      Message body <%= assigns.message.body %>
    </div>
    """
  end
end
