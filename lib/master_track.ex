defmodule MasterTrack do
  use GenServer

  def start_link(bpm) do
    {:ok, _} = GenServer.start_link(MasterTrack, [bpm], name: MyMasterTrack)
  end

  @impl true
  def init([bpm]) do
    {:ok, {bpm, -1, -1}}
  end

  @impl true
  def handle_cast({:tick, t0, ts}, {bpm, _prev_bars, prev_beats}) do
    dt_ns = ts - t0
    ns_per_qn = 1000000000 * 60 / bpm
    qns = trunc(dt_ns / ns_per_qn)
    bars = div(qns, 4)
    beats = rem(qns, 4)
    if prev_beats != beats, do: IO.write(:stderr, "\a\rPos: #{bars}:#{beats + 1}")

    {:noreply, {bpm, bars, beats}}
  end



end
