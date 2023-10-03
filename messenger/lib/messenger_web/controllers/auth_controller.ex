defmodule MessengerWeb.AuthController do
  use MessengerWeb, :controller
  import Phoenix.Component

  def authorize(conn, _params) do
    token = conn.body_params["token"]
    {:ok, user, _claims} = Messenger.Guardian.resource_from_token(token)

    conn |> put_session(:current_user, user) |> json("OK")
  end
end
