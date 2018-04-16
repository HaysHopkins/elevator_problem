defmodule Elevator do
  defstruct name: nil, occupants: 0, destination_queues: %{}, current_floor: 0,
            destination: nil, next: [], max_floor: nil

  def execute_turn(elevator, boarding) do
    new_destination_queues = elevator.destination_queues
                             |> clear_arrivals(elevator.current_floor)
                             |> add_departures(boarding)

    {new_destination, new_next} = update_move_order(elevator.destination, elevator.next)

    current_floor = next_floor(elevator.current_floor, new_destination)

    struct(elevator, %{
      destination_queues: new_destination_queues,
      destination: new_destination,
      current_floor: current_floor,
      next: new_next
    })
  end

  def add_destinations(elevator, []), do: elevator
  def add_destinations(elevator = %{destination: nil}, [h | t]) do
    if h == elevator.current_floor do
      add_destinations(elevator, t)
    else
      struct(elevator, %{destination: h, next: elevator.next ++ t})
    end
  end
  def add_destinations(elevator, [h | t]) do
    if h == elevator.current_floor do
      add_destinations(elevator, t)
    else
      struct(elevator, %{next: elevator.next ++ [h | t]})
    end
  end


  defp clear_arrivals(queues, current_floor) do
    %{queues | current_floor => []}
  end

  defp add_departures(queues, boarding) do
    Enum.reduce(boarding, queues, fn(boardee, new_queues)->
      %{new_queues | boardee.request_dest => [boardee | new_queues[boardee.request_dest]]}
    end)
  end

  defp update_move_order(nil, nil), do: {nil, nil}
  defp update_move_order(nil, [h | t]), do: {h, t}
  defp update_move_order(destination, next), do: {destination, next}

  defp next_floor(current_floor, nil), do: current_floor
  defp next_floor(current_floor, destination) when current_floor < destination, do: current_floor + 1
  defp next_floor(current_floor, destination) when current_floor > destination, do: current_floor - 1
  defp next_floor(current_floor, _), do: current_floor
end
