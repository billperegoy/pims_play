defmodule PIMSPlay.PVLData do
  use GenServer

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:add_visit, pims_visit_id}, state) do
    {:noreply, Map.put(state, pims_visit_id, new_visit())}
  end

  @impl true
  def handle_cast({:remove_visit, pims_visit_id}, state) do
    {:noreply, Map.delete(state, pims_visit_id)}
  end

  @impl true
  def handle_call(:get_visits, _from, state) do
    {:reply, state, state}
  end

  defp new_visit() do
    %{status: :new, added_at: DateTime.utc_now()}
  end

  # Client API
  def start_link() do
    GenServer.start_link(__MODULE__, %{})
  end

  def add_visit(pid, pims_visit_id) do
    GenServer.cast(pid, {:add_visit, pims_visit_id})
  end

  def remove_visit(pid, pims_visit_id) do
    GenServer.cast(pid, {:remove_visit, pims_visit_id})
  end

  def get_visits(pid) do
    GenServer.call(pid, :get_visits)
  end
end
