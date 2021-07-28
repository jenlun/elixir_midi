defmodule Conductor do
  use GenServer

  defstruct bpm: 120,
    sequence: nil,
    playing: false,
    play_start: 0,
    last_tick: 0


  @ppqn Application.get_env(:midi, :ppqn)

  def start_link(bpm) do
    {:ok, _} = GenServer.start_link(__MODULE__, [bpm], name: __MODULE__)
  end

  def load_example_sequence() do
    length = div(@ppqn, 2)
    one_bar = @ppqn * 4
    sequence = %Sequence{
      name: "Example Sequence",
      tracks: [
        %Track{
          name: "Kick",
          midi_channel: 1,
          patterns: [
            %Pattern{
              active: true,
              length: one_bar,
              notes: [
                %Note{tick: 0, note: 36, velocity: 100, length: length},
                %Note{tick: @ppqn, note: 36, velocity: 100, length: length},
                %Note{tick: @ppqn * 2, note: 36, velocity: 100, length: length},
                %Note{tick: @ppqn * 3, note: 36, velocity: 100, length: length}
              ]
            }
          ]
        },
        %Track{
          name: "Snare",
          midi_channel: 2,
          patterns: [
            %Pattern{
              active: true,
              length: one_bar,
              notes: [
                %Note{tick: @ppqn, note: 38, velocity: 100, length: length},
                %Note{tick: @ppqn * 3, note: 38, velocity: 100, length: length}
              ]
            }
          ]
        },
        %Track{
          name: "Hihat",
          midi_channel: 1,
          patterns: [
            %Pattern{
              active: true,
              length: div(@ppqn, 2),
              notes: [
                %Note{tick: 0, note: 42, velocity: 100, length: length}
              ]
            }
          ]
         }
      ]
    }
    GenServer.call(__MODULE__, {:load_sequence, sequence})
  end

  def play() do
    GenServer.call(__MODULE__, :play)
  end

  def stop() do
    GenServer.call(__MODULE__, :stop)
  end

  @impl true
  def init([bpm]) do
    {:ok, %Conductor{bpm: bpm}}
  end

  @impl true
  def handle_call({:load_sequence, sequence}, _from, state) do
    new_state = %{state | sequence: sequence}
    {:reply, :ok, new_state}
  end

  @impl true
  def handle_call(:play, _from, state) do
    Process.send(__MODULE__, :pulse, [])

    new_state = %{state | playing: true}
    {:reply, :ok, new_state}
  end

  @impl true
  def handle_call(:stop, _from, state) do
    Device.Out.all_off()

    new_state = %{state | playing: false}
    {:reply, :ok, new_state}
  end

  @impl true
  def handle_info(:pulse, state) do
    current_tick = BPM.tick_for_timestamp(state.bpm, timestamp() - state.play_start)

    if current_tick != state.last_tick do
      if rem(current_tick, @ppqn ) == 0, do: PubSub.publish(:beat, current_tick)
      PubSub.publish(:pulse, current_tick)

      state
      |> Map.get(:sequence)
      |> Sequence.events_for_tick(current_tick)
      |> Enum.each(fn event ->
        event
        |> Event.to_portmidi()
        |> Device.Out.send_event()
      end)
    end

    if state.playing, do: Process.send(__MODULE__, :pulse, [])
    {:noreply, %{state | last_tick: current_tick}}
  end

  def timestamp() do
    :erlang.system_time()
  end

end
