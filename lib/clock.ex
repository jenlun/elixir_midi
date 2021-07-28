defmodule Clock do

  use GenServer

  def start_link() do
    {:ok, _} = GenServer.start_link(Clock, [], name: MyClock)
  end

  def start() do
    GenServer.call(MyClock, :start)
  end

  def stop() do
    GenServer.call(MyClock, :stop)
  end

  def shutdown() do
    GenServer.call(MyClock, :shutdown)
  end

  @impl true
  def init(_state) do
    {:ok, {:stopped, 0}}
  end

  @impl true
  def handle_info({:tick, _ts}, state = {:stopped, 0}) do
    {:noreply, state}
  end

  @impl true
  def handle_info({:tick, ts}, state = {:running, t0}) do
   # IO.puts(ts / 1000000)
    send_tick(t0)
    {:noreply, state}
  end

  @impl true
  def handle_call(:start, _from, {:stopped, 0}) do
    t0 = :erlang.system_time()
    send_tick(t0)
    {:reply, :ok, {:running, t0}}
  end


  @impl true
  def handle_call(:stop, _from, {:running, t0}) do
    {:reply, :ok, {:stopped, 0}}
  end

  @impl true
  def handle_call(:shutdown, _from, state) do
    {:stop, :normal, state}
  end

  defp send_tick(t0) do
    ts = :erlang.system_time()
    GenServer.cast(MyMasterTrack, {:tick, t0, ts})
    Process.send_after(MyClock, {:tick, ts}, 10)
  end

end
