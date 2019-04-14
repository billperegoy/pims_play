defmodule PMSPlay.PVLCache do
  use GenStage

  @impl true
  def init(state) do
    {:consumer, state}
  end

  @impl true
  def handle_events(events, _from, state) do
    {:noreply, events, state}
  end

  # Client API
  def start_link() do
    GenStage.start_link(__MODULE__, %{})
  end
end
