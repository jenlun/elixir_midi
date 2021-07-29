defmodule TransformTest do
  use ExUnit.Case

  @ppqn Application.get_env(:midi, :ppqn)

  test "quantize_close_to_zero_16" do
    assert Transform.quantize(3, 16) == 0
  end

  test "close_to_zero" do
    assert Transform.quantize(1, 1) == 0
    assert Transform.quantize(1, 2) == 0
    assert Transform.quantize(1, 4) == 0
    assert Transform.quantize(1, 8) == 0
    assert Transform.quantize(1, 16) == 0
    assert Transform.quantize(1, 32) == 0
  end

  test "close_to_ppqn" do
    assert Transform.quantize(@ppqn - 1, 1) == 0
    assert Transform.quantize(@ppqn - 1, 2) == 0
    assert Transform.quantize(@ppqn - 1, 4) == @ppqn
    assert Transform.quantize(@ppqn - 1, 8) == @ppqn
    assert Transform.quantize(@ppqn - 1, 16) == @ppqn
    assert Transform.quantize(@ppqn - 1, 32) == @ppqn
  end

  test "close_to_bar" do
    ts = 4 * @ppqn - 1
    assert Transform.quantize(ts, 1) == 4 * @ppqn
    assert Transform.quantize(ts, 2) == 4 * @ppqn
    assert Transform.quantize(ts, 4) == 4 * @ppqn
    assert Transform.quantize(ts, 8) == 4 * @ppqn
    assert Transform.quantize(ts, 16) == 4 * @ppqn
    assert Transform.quantize(ts, 32) == 4 * @ppqn
  end


end
