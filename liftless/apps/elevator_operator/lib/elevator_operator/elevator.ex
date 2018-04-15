defmodule Elevator do
  defstruct name: nil, occupants: 0, destination_queues: %{}, current_floor: 0,
            destination: nil, next: [], max_floor: nil
end
