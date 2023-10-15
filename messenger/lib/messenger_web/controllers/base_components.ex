defmodule MessengerWeb.BaseComponents do
  use Phoenix.Component

  def errors(assigns) do
    if Enum.empty?(assigns.errors) do
      ~L""
    else
      {error, _} = List.first(assigns.errors)
      assigns = assign(assigns, error: error)

      ~H"""
      <div>
        <%= @error %>
      </div>
      """
    end
  end

  attr :field, Phoenix.HTML.FormField
  attr :rest, :global, include: ~w(type)

  def input(assigns) do
    ~H"""
    <div>
      <input id={@field.id} name={@field.name} value={@field.value} {@rest} />
      <.errors errors={@field.errors} />
    </div>
    """
  end

  attr :field, Phoenix.HTML.FormField
  attr :rest, :global, include: ~w(type)

  def textarea(assigns) do
    ~H"""
    <div>
      <textarea id={@field.id} name={@field.name} {@rest}><%= @field.value %></textarea>
      <.errors errors={@field.errors} />
    </div>
    """
  end
end
