defmodule Note do
  defstruct note: 60,
    velocity: 100,
    tick: 0,
    length: 0,
    id: UUID.uuid4()

  def to_event_pair(
    %Note{note: note, velocity: velocity, tick: tick, length: length},channel

  ) do
    [
      %Event{
        status: 0x90,
        midi_channel: channel,
        data: {note, velocity},
        tick: tick},
      %Event{
        status: 0x80,
        midi_channel: channel,
        data: {note, 0},
        tick: tick + length
      }
    ]
  end
end
