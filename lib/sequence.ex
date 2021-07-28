defmodule Sequence do

  defstruct tracks: [],
    bpm: 120,
    name: "Example",
    id: UUID.uuid4()

  def events_for_tick(%__MODULE__{} = sequence, tick) do
    sequence
    |> Map.get(:tracks, [])
    |> Enum.flat_map(&Track.events_for_tick(&1, tick))
  end

end
