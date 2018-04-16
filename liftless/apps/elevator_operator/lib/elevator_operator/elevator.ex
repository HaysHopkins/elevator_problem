defmodule Elevator do
  defstruct name: nil, occupants: 0, destination_queues: %{}, current_floor: 0,
            destination: nil, next: [], max_floor: nil

  def execute_turn(elevator, boarding) do
    new_destination_queues = el.destination_queue
                             |> clear_arrivals(current_floor)
                             |> add_departures(boarding)

    {new_destination, new_next} = update_move_order(elevator.destination, elevator.next)

    struct(elevator, %{
      destination_queues: new_destination_queues,
      destination: new_destination,
      next: new_next
    })
  end

  def add_destinations(elevator = %{destination: nil}, [h | t]) do
    struct(elevator, %{destination: h, next: elevator.next ++ t})
  end
  def add_destinations(elevator, destinations) do
    struct(elevator, %{next: elevator.next ++ destinations})
  end

  defp changing_of_the_guard(queues, current_floor) do
    %{queues | current_floor => []}
  end

  defp update_move_order(nil, nil), do: {nil, nil}
  defp update_move_order(nil, [h | t]), do: {h, t}
  defp update_move_order(destination, next), do: {destination, next}
end
