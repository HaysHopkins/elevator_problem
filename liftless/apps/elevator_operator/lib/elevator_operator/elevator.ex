defmodule Elevator do
  defstruct name: nil, occupants: 0, destination_queues: %{}, current_floor: 0,
            destination: nil, next: [], max_floor: nil

  def add_destinations(elevator = %{destination: nil}, [h | t]) do
    struct(elevator, %{destination: h, next: elevator.next ++ t})
  end
  def add_destinations(elevator, destinations) do
    struct(elevator, %{next: elevator.next ++ destinations})
  end
end
