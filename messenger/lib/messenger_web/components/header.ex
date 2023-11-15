defmodule MessengerWeb.Header do
  use MessengerWeb, :html

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
    <div class="bg-primary-600 flex justify-between py-3 px-4 items-center">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :type, :string, required: true

  def auth_header(%{type: "login"} = assigns) do
    ~H"""
    <.header>
      <h3 class="text-secondary-100 font-bold">
        Login
      </h3>
      <.button phx-click="sign_up" color="secondary">
        Sign up
      </.button>
    </.header>
    """
  end

  def auth_header(%{type: "register"} = assigns) do
    ~H"""
    <.header>
      <h3 class="text-secondary-100 font-bold">
        Register
      </h3>
      <.button phx-click="login" color="secondary">
        Login
      </.button>
    </.header>
    """
  end
end
