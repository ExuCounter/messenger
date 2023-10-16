defmodule MessengerWeb.Auth do
  import Phoenix.LiveView

  @moduledoc """
  Ensures common `assigns` are applied to all LiveViews attaching this hook.
  """

  def on_mount(:check_auth, _params, session, socket) do
    if session["current_user"] do
      {:halt, redirect(socket, to: "/chats")}
    else
      {:cont, socket}
    end
  end

  def on_mount(:verify_auth, _params, session, socket) do
    if session["current_user"] do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/login")}
    end
  end
end

defmodule MessengerWeb.Router do
  use MessengerWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {MessengerWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", MessengerWeb do
    pipe_through(:browser)

    post("/auth", AuthController, :authorize)
    post("/logout", AuthController, :logout)

    live_session :auth, on_mount: {MessengerWeb.Auth, :check_auth} do
      live("/login", LoginLive)
      live("/register", RegisterLive)
    end

    live_session :user, on_mount: {MessengerWeb.Auth, :verify_auth} do
      live("/chats", ChatsLive)
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", MessengerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:messenger, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: MessengerWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
