defmodule PimsPlayTest.API do
  use ExUnit.Case

  test "returns valid data before rate limiting" do
    Hammer.delete_buckets("token")

    assert PimsPlay.API.get(:visits, "token") == {:ok, %{data: []}}
  end

  test "rate limit after 10 calls" do
    Hammer.delete_buckets("token")

    assert PimsPlay.API.get(:visits, "token") == {:ok, %{data: []}}
    assert PimsPlay.API.get(:visits, "token") == {:ok, %{data: []}}
    assert PimsPlay.API.get(:visits, "token") == {:ok, %{data: []}}
    assert PimsPlay.API.get(:visits, "token") == {:ok, %{data: []}}
    assert PimsPlay.API.get(:visits, "token") == {:ok, %{data: []}}
    assert PimsPlay.API.get(:visits, "token") == {:ok, %{data: []}}
    assert PimsPlay.API.get(:visits, "token") == {:ok, %{data: []}}
    assert PimsPlay.API.get(:visits, "token") == {:ok, %{data: []}}
    assert PimsPlay.API.get(:visits, "token") == {:ok, %{data: []}}
    assert PimsPlay.API.get(:visits, "token") == {:ok, %{data: []}}
    assert PimsPlay.API.get(:visits, "token") == {:error, :rate_limit}
  end
end
