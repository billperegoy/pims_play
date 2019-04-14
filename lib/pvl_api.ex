defmodule PMSPlay.PVLAPI do
  use GenStage

  @impl true
  def init(state) do
    {:producer_consumer, state}
  end

  @impl true
  def handle_events(events, _from, state) do
    {:noreply, events, state}
  end

  @impl true
  def handle_demand(demand, state) do
    {:noreply, demand, state}
  end

  # Client API
  def start_link() do
    GenStage.start_link(__MODULE__, %{})
  end
end
