defmodule ElevatorOperator.Optimizer do

  def find_nearest_elevator(elevators, request) do
    Enum.map(elevators, fn(el)->
      calculate_steps(true, request, el.current_step, [el.destination | el.next], 0)
    end)
  end



  # Continue calculating using next steps
  # defp calculate_steps(continue, request, current, next_steps, _) do
  #   case request in current..dest do
  #     true -> {false, abs(current-request)}
  #     false -> calculate_steps(continue, request, dest, next_steps, abs(current-dest))
  #   end
  # end

  # No destination, return total
  defp calculate_steps(_, request, current, [nil, _], _), do: {true, abs(current-request)}
  # Request in range of current lift movements, return total
  defp calculate_steps(false, _, _, _, total), do: {false, total}
  # No more steps, return total + steps to request
  defp calculate_steps(_, request, _, [], total), do: {true, abs(total-request)}
  # Request in later range, return total
  defp calculate_steps(continue, request, last, [next | next_steps], total) do
    case request in last..next do
      true -> calculate_steps(false, request, next, next_steps, total + abs(last-request))
      false -> calculate_steps(continue, request, next, next_steps, total + abs(last-next))
    end
  end
end
