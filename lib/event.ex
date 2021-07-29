defmodule Event do
  defstruct status: 0x0,
            midi_channel: 1,
            data: nil,
            tick: 0

  def to_portmidi(%Event{status: status, midi_channel: midi_channel, data: {note, velocity}}) do
    {status + midi_channel - 1, note, velocity}
  end
end
