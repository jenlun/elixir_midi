defmodule TransformTest do
  use ExUnit.Case

  @ppqn Application.get_env(:midi, :ppqn)

  test "quantize_close_to_zero_16" do
    event = {128, 60, 100}
    assert Transform.quantize(event, 3, 16) == 0
  end

  test "close_to_zero" do
    event = {128, 60, 100}
    assert Transform.quantize(event, 1, 1) == 0
    assert Transform.quantize(event, 1, 2) == 0
    assert Transform.quantize(event, 1, 4) == 0
    assert Transform.quantize(event, 1, 8) == 0
    assert Transform.quantize(event, 1, 16) == 0
    assert Transform.quantize(event, 1, 32) == 0
  end

  test "close_to_ppqn" do
    event = {128, 60, 100}
    assert Transform.quantize(event, @ppqn - 1, 1) == 0
    assert Transform.quantize(event, @ppqn - 1, 2) == 0
    assert Transform.quantize(event, @ppqn - 1, 4) == @ppqn
    assert Transform.quantize(event, @ppqn - 1, 8) == @ppqn
    assert Transform.quantize(event, @ppqn - 1, 16) == @ppqn
    assert Transform.quantize(event, @ppqn - 1, 32) == @ppqn
  end

  test "close_to_bar" do
    event = {128, 60, 100}
    ts = 4 * @ppqn - 1
    assert Transform.quantize(event, ts, 1) == 4 * @ppqn
    assert Transform.quantize(event, ts, 2) == 4 * @ppqn
    assert Transform.quantize(event, ts, 4) == 4 * @ppqn
    assert Transform.quantize(event, ts, 8) == 4 * @ppqn
    assert Transform.quantize(event, ts, 16) == 4 * @ppqn
    assert Transform.quantize(event, ts, 32) == 4 * @ppqn
  end


end
