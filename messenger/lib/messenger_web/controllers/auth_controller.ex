defmodule MessengerWeb.AuthController do
  use MessengerWeb, :controller

  def authorize(conn, _params) do
    token = conn.body_params["token"]

    with {:ok, user, _claims} <- Messenger.Guardian.resource_from_token(token) do
      conn |> put_session(:current_user, user) |> json(%{authorized: true})
    else
      {:error, reason} -> conn |> json(%{authorized: false, reason: reason})
    end
  end

  def logout(conn, _params) do
    conn |> put_session(:current_user, nil) |> json(%{authorized: false})
  end
end
