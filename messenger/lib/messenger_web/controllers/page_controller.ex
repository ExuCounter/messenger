defmodule MessengerWeb.PageController do
  use MessengerWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def get_message(conn, %{"message_id" => message_id}) do
    render(conn, :get_message, layout: false, message_id: message_id)
  end
end
