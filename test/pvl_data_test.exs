defmodule PimsPlayTest.PVLData do
  use ExUnit.Case

  describe "basic genserver functionality" do
    test "initalizes with empty map" do
      {:ok, pid} = PIMSPlay.PVLData.start_link()

      assert PIMSPlay.PVLData.list_visits(pid) == %{}
    end

    test "insert visits" do
      {:ok, pid} = PIMSPlay.PVLData.start_link()

      PIMSPlay.PVLData.add_visit(pid, "visit1")
      PIMSPlay.PVLData.add_visit(pid, "visit2")

      visits = PIMSPlay.PVLData.list_visits(pid)
      assert Map.keys(visits) == ["visit1", "visit2"]

      statuses = Map.values(visits)
      assert Enum.map(statuses, & &1.status) == [:new, :new]
    end

    test "remove visits" do
      {:ok, pid} = PIMSPlay.PVLData.start_link()

      PIMSPlay.PVLData.add_visit(pid, "visit1")
      PIMSPlay.PVLData.add_visit(pid, "visit2")
      PIMSPlay.PVLData.remove_visit(pid, "visit1")

      visits = PIMSPlay.PVLData.list_visits(pid)

      assert Map.keys(visits) == ["visit2"]
    end
  end

  describe "PIMS API Queue" do
    test "initializes to empty" do
      {:ok, pid} = PIMSPlay.PVLData.start_link()

      api_queue_jobs = PIMSPlay.PVLData.list_api_queue_jobs(pid)

      assert api_queue_jobs == []
    end

    test "new visits are added to the queue" do
      {:ok, pid} = PIMSPlay.PVLData.start_link()
      PIMSPlay.PVLData.add_visit(pid, "visit1")

      api_queue_jobs = PIMSPlay.PVLData.list_api_queue_jobs(pid)

      assert api_queue_jobs == ["visit1"]
    end

    test "removed visits are removed from the queue" do
      {:ok, pid} = PIMSPlay.PVLData.start_link()
      PIMSPlay.PVLData.add_visit(pid, "visit1")
      PIMSPlay.PVLData.remove_visit(pid, "visit1")

      api_queue_jobs = PIMSPlay.PVLData.list_api_queue_jobs(pid)

      assert api_queue_jobs == []
    end
  end
end
