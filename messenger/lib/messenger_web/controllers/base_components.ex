defmodule MessengerWeb.BaseComponents do
  use Phoenix.Component

  def errors(assigns) do
    if Enum.empty?(assigns.errors) do
      ~L""
    else
      error = Messenger.User.format_errors(assigns.errors)
      assigns = assign(assigns, error: error)

      ~H"""
      <span class="form-binding-error">
        <%= @error %>
      </span>
      """
    end
  end

  attr :field, Phoenix.HTML.FormField
  attr :rest, :global, include: ~w(type)

  def input(assigns) do
    ~H"""
    <div class="form-binding-wrapper">
      <input class="input" id={@field.id} name={@field.name} value={@field.value} {@rest} />
      <.errors errors={@field.errors} />
    </div>
    """
  end

  attr :field, Phoenix.HTML.FormField
  attr :rest, :global, include: ~w(type)

  def textarea(assigns) do
    ~H"""
    <div class="form-binding-wrapper">
      <textarea id={@field.id} name={@field.name} {@rest}><%= @field.value %></textarea>
      <.errors errors={@field.errors} />
    </div>
    """
  end
end
