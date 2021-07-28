defmodule Pattern do
  @ppqn Application.get_env(:midi, :ppqn)
  defstruct active: true,
    type: :step,
    events: [],
    notes: [],
    id: UUID.uuid4(),
    length: @ppqn * 4

  def events_for_tick(pattern, tick, channel) do
    pattern
    |> all_events(channel)
    |> Enum.filter(fn event -> event.tick == rem(tick, pattern.length) end)
  end

  def all_events(pattern, channel) do
    pattern
    |> Map.get(:notes, [])
    |> Enum.flat_map(&Note.to_event_pair(&1, channel))
    |> Enum.concat(pattern.events)
  end
end
