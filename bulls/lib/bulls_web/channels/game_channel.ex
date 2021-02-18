defmodule BullsWeb.GameChannel do
  use BullsWeb, :channel

  alias Bulls.Game
  alias Bulls.BackupAgent

  @impl true
  def join("game:" <> name, payload, socket) do
    if authorized?(payload) do
      game = BackupAgent.get(name) || Game.new
      socket = socket
      |> assign(:name, name)
      |> assign(:game, game)
      BackupAgent.put(name, game)
      get_state = Game.get_state(game)
      {:ok, get_state, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("guess", %{"number" => num}, socket0) do
    game0 = socket0.assigns[:game]
    game1 = Game.guess(game0, num)
    socket1 = assign(socket0, :game, game1)
    BackupAgent.put(socket0.assigns[:name], game1)
    get_state = Game.get_state(game1)
    {:reply, {:ok, get_state}, socket1}
  end

  @impl true
  def handle_in("reset", _, socket) do
    game = Game.new
    socket = assign(socket, :game, game)
    get_state = Game.get_state(game)
    {:reply, {:ok, get_state}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
