defmodule Device.Out do

  use GenServer

  def start_link(arg) do
    {:ok, _} = GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def send_event(event) do
    GenServer.call(__MODULE__, {:send_event, event})
  end

  def all_off() do
    GenServer.call(__MODULE__, :all_off)
  end


  @impl true
  def init([]) do
    {:ok, pid} = PortMidi.open(:output, "IAC Driver Bus 1")
    {:ok, pid}
  end

  @impl true
  def handle_call({:send_event, event}, _from, pid) do
    PortMidi.write(pid, event)
    {:reply, :ok, pid}
  end

  @impl true
  def handle_call(:all_off, _from, pid) do
    all_off_events()
    |> Enum.each(fn(x) -> PortMidi.write(pid, x) end)
    {:reply, :ok, pid}
  end

  def all_off_events() do
    for i <- 0..15, j <- 0..127, do:  {0x80 + i, j, 0}
  end
end
