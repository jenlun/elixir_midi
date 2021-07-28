defmodule Track do
  defstruct midi_channel: 1,
    name: "",
    patterns: [],
    active: true,
    id: UUID.uuid4()

  def events_for_tick(%__MODULE__{} = track, tick) do
    track
    |> Map.get(:patterns, [])
    |> Enum.flat_map(&Pattern.events_for_tick(&1, tick, track.midi_channel))
  end
end
