defmodule BPM do
  @ppqn Application.get_env(:midi, :ppqn)

  def tick_for_timestamp(bpm, timestamp) do
    ns_per_tick = 1_000_000_000 * 60 / bpm / @ppqn
    tick = trunc(timestamp / ns_per_tick)
    tick
  end
end
