defmodule PIMSPlay.PVLData do
  use GenStage

  @impl true
  def init(state) do
    {:producer, state}
  end

  @impl true
  def handle_demand(demand, state) do
    {:noreply, demand, state}
  end

  @impl true
  def handle_cast({:add_visit, pims_visit_id}, %{visits: visits, api_queue: api_queue}) do
    new_visits = Map.put(visits, pims_visit_id, new_visit())
    new_api_queue = :queue.in(pims_visit_id, api_queue)
    {:noreply, [], %{visits: new_visits, api_queue: new_api_queue}}
  end

  @impl true
  def handle_cast({:remove_visit, pims_visit_id}, %{visits: visits, api_queue: api_queue}) do
    new_visits = Map.delete(visits, pims_visit_id)
    new_api_queue = :queue.filter(&(&1 != pims_visit_id), api_queue)
    {:noreply, [], %{visits: new_visits, api_queue: new_api_queue}}
  end

  @impl true
  def handle_call(:list_visits, _from, %{visits: visits} = state) do
    {:reply, visits, [], state}
  end

  @impl true
  def handle_call(:list_api_queue_jobs, _from, %{api_queue: api_queue} = state) do
    {:reply, :queue.to_list(api_queue), [], state}
  end

  defp new_visit() do
    %{status: :new, added_at: DateTime.utc_now()}
  end

  # Client API
  def start_link() do
    GenStage.start_link(__MODULE__, %{visits: %{}, api_queue: :queue.new()})
  end

  def add_visit(pid, pims_visit_id) do
    GenServer.cast(pid, {:add_visit, pims_visit_id})
  end

  def remove_visit(pid, pims_visit_id) do
    GenServer.cast(pid, {:remove_visit, pims_visit_id})
  end

  def list_visits(pid) do
    GenServer.call(pid, :list_visits)
  end

  def list_api_queue_jobs(pid) do
    GenServer.call(pid, :list_api_queue_jobs)
  end
end
