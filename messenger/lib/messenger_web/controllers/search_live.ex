defmodule MessengerWeb.SearchLive do
  use Phoenix.LiveComponent
  import MessengerWeb.BaseComponents

  def render(assigns) do
    ~H"""
    <div class="search">
      Search users <button phx-click="add_user_to_chat">kek</button>
    </div>
    """
  end

  def handle_event("add_user_to_chat", _params, socket) do
    IO.inspect(true)
    {:noreply, socket}
  end
end
