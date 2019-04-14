defmodule PimsPlayTest.PVLData do
  use ExUnit.Case

  test "initalizes with empty map" do
    {:ok, pid} = PIMSPlay.PVLData.start_link()

    assert PIMSPlay.PVLData.get_visits(pid) == %{}
  end

  test "insert visits" do
    {:ok, pid} = PIMSPlay.PVLData.start_link()

    PIMSPlay.PVLData.add_visit(pid, "visit1")
    PIMSPlay.PVLData.add_visit(pid, "visit2")

    visits = PIMSPlay.PVLData.get_visits(pid)
    assert Map.keys(visits) == ["visit1", "visit2"]

    statuses = Map.values(visits)
    assert Enum.map(statuses, & &1.status) == [:new, :new]
  end

  test "remove visits" do
    {:ok, pid} = PIMSPlay.PVLData.start_link()

    PIMSPlay.PVLData.add_visit(pid, "visit1")
    PIMSPlay.PVLData.add_visit(pid, "visit2")
    PIMSPlay.PVLData.remove_visit(pid, "visit1")

    visits = PIMSPlay.PVLData.get_visits(pid)

    assert Map.keys(visits) == ["visit2"]
  end
end
