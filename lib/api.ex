defmodule PimsPlay.API do
  def get(service, practice_token) do
    %{period: period, count: count} = rate_limit_params(service)

    case Hammer.check_rate(practice_token, period, count) do
      {:allow, _count} ->
        {:ok, %{data: []}}

      {:deny, _limit} ->
        {:error, :rate_limit}
    end
  end

  def rate_limit_params(:visits) do
    %{period: 60_000, count: 10}
  end

  def rate_limit_params(:invoice) do
    %{period: 60_000, count: 10}
  end
end
