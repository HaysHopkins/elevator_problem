defmodule Elevator do
  defstruct name: nil, destination_queues: %{}, current_floor: 0, destination: nil, max_floor: nil
end
