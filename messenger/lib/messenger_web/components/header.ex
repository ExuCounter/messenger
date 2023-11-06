defmodule MessengerWeb.Header do
  use Phoenix.Component

  def get_auth_header_title(type) do
    case type do
      "login" -> "Login"
      "register" -> "Sign up"
      _ -> "Default"
    end
  end

  slot :inner_block, required: true

  def header(assigns) do
    ~H"""
    <div class="header header_public">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :type, :string, required: true

  def auth_header(%{type: "login"} = assigns) do
    ~H"""
    <.header>
      <h3 class="header__title">
        Login
      </h3>
      <button phx-click="sign_up" class="header__button">
        Sign up
      </button>
    </.header>
    """
  end

  def auth_header(%{type: "register"} = assigns) do
    ~H"""
    <.header>
      <h3 class="header__title">
        Register
      </h3>
      <button phx-click="login" class="header__button">
        Login
      </button>
    </.header>
    """
  end
end
