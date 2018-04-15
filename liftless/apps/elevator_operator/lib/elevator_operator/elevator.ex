defmodule Elevator do
  defstruct name: nil, occupants: 0, destination_queues: %{}, current_floor: 0, destination: nil, max_floor: nil

  def available?(elevator)
    elevator.destination == nil
  end

  def incoming?(elevator, request, destination) do
    case do

    end
  end
end
