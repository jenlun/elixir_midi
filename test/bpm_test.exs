defmodule BPMTest do
  use ExUnit.Case

  @ppqn Application.get_env(:midi, :ppqn)

  test "start" do
    assert BPM.tick_for_timestamp(120, 0) == 0
  end

  test "one minute in" do
    bpm = 120
    assert BPM.tick_for_timestamp(bpm, 60_000_000_000) == bpm * @ppqn
  end
end
