defmodule MessengerWeb.RegisterLive do
  use Phoenix.LiveView
  import Phoenix.Component

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        :form,
        to_form(Messenger.User.create_user_changeset(%Messenger.User{}, %{email: ""}))
      )
      |> assign(:user, %Messenger.User{})
      |> IO.inspect()

    {:ok, socket}
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

  def user(assigns) do
    ~H"""
    <div>
      <%= inspect(assigns.user) %>
    </div>
    """
  end

  def errors(assigns) do
    if Enum.empty?(assigns.errors) do
      ~L""
    else
      {error, _} = List.first(assigns.errors)

      ~H"""
      <div>
        <%= error %>
      </div>
      """
    end
  end

  def handle_event("validate", %{"user" => user} = params, socket) do
    form =
      %Messenger.User{}
      |> Messenger.User.create_user_changeset(user)
      |> Map.put(:action, :insert)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", %{"user" => user} = _params, socket) do
    Messenger.User.create_user(user)

    with {:ok, user} <- Messenger.User.login(user) do
      {:ok, token, _claims} = Messenger.Guardian.encode_and_sign(user)
      IO.inspect(token)
      {:noreply, push_event(socket, "setSession", %{token: token})}
    else
      _ -> {:noreply, socket}
    end
  end
end
