defmodule Transform do

  @ppqn Application.get_env(:midi, :ppqn)

  def quantize(timestamp, q) do
    round_to = factor(q)
    div(timestamp + div(round_to, 2), round_to) * round_to
  end

  def factor(q) do
    div(@ppqn * 4, q)
  end


end
