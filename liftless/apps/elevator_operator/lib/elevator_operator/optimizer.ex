defmodule ElevatorOperator.Optimizer do

  def find_nearest_elevator(elevators, request_floor, _) do
    Enum.map(elevators, fn(el)->
      calculate_steps(true, request_floor, el.current_floor, [el.destination | el.next], 0)
      |> Tuple.append(el.name)
    end)
    |> Enum.min_by(fn({_, steps, _})-> steps end)
    #FOR FALSE TUPLES I NEED TO CALCULATE POTENTIAL POST MOVE AFTER PICK UP
    #SO DIFF OF ALL REMAINING STEPS + DIFF TO DESTINATION FROM END
    #THEN COMPARE THAT TO TRUE STEPS STEP COUNTS + DIFF TO DESTINATION
  end

  # No destination, return total
  defp calculate_steps(_, request_floor, current, [nil | _], _), do: {true, abs(current-request_floor)}
  # request_floor in range of current lift movements, return total
  defp calculate_steps(false, _, _, _, total), do: {false, total}
  # No more steps, return total + steps to request_floor
  defp calculate_steps(_, request_floor, _, [], total), do: {true, abs(total-request_floor)}
  # request_floor in later range, return total
  defp calculate_steps(continue, request_floor, last, [next | next_steps], total) do
    case request_floor in last..next do
      true -> calculate_steps(false, request_floor, next, next_steps, total + abs(last-request_floor))
      false -> calculate_steps(continue, request_floor, next, next_steps, total + abs(last-next))
    end
  end
end
