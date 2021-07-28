defmodule Device.In do

  use GenServer

  def start_link(arg) do
    {:ok, _} = GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init([]) do
    {:ok, input} = PortMidi.open(:input, "Network Session 1")
    PortMidi.listen(input, self())
    {:ok, input}
  end

  @impl true
  def handle_info({_pid, events} = msg, pid) do
    IO.inspect(msg)
    IO.inspect(events)
    # dont really know how to interpret timestamp. ignoring it for now.
    Enum.each(events, fn({event, _ts}) -> Device.Out.send_event(event) end)
    {:noreply, pid}
  end


end
