defmodule ElevatorOperator.Optimizer do

  def find_nearest_elevator(elevators, request, request_dest) do
    Enum.map(elevators, fn(el)->
      calculate_steps({true, true}, request, request_dest, el.current_floor, [el.destination | el.next], 0)
      |> Tuple.append(el.name)
    end)
    |> Enum.min_by(fn({_, steps, _})-> steps end)
    #FOR FALSE TUPLES I NEED TO CALCULATE POTENTIAL POST MOVE AFTER PICK UP
    #SO DIFF OF ALL REMAINING STEPS + DIFF TO DESTINATION FROM END
    #THEN COMPARE THAT TO TRUE STEPS STEP COUNTS + DIFF TO DESTINATION
  end

  # Requests in range of current lift movements, return total
  defp calculate_steps({false, false}, _, _, _, total), do: {{false, false}, total}
  # Request in range, need to add destination because no more are in list
  defp calculate_steps({false, true}, req_dest, last, [], total), do: {{false, true}, total + abs(last-req_dest)}
  # Start calculating from destination once start is determined to be within range
  # ONCE I PICK UP MIGHT WANT TO ESTABLISH BASE DIFFERENCE BASED ON BUILDING HEIGHT
  # ON WHEN TO CONTINUE IN SAME DIRECTION, EVEN IF IT MEANS ALTERING SCHEDULE MIDWAY
  defp calculate_steps({false, true}, request_dest, last, [next | next_steps], total) do
    case request_dest in last..next do
      true -> calculate_steps({false, false}, request_dest, next, next_steps, total + abs(last-request_dest))
      false -> calculate_steps({false, true}, request_dest, next, next_steps, total + abs(last-next))
    end
  end

  # No destination, return total
  defp calculate_steps(_, request, request_dest, current, [nil | _], _),
        do: {{true, true}, abs(current-request) + abs(request-request_dest)}
  # Need to add both request and destination because netiher are in list
  defp calculate_steps(_, req, req_dest, last, [], total), do: {{true, true}, total + abs(req-last) + abs(req-req_dest)}
  # request in later range, return total
  defp calculate_steps({add_start, add_end}, request, request_dest, last, [next | next_steps], total) do
    case request in last..next do
      true -> calculate_steps({false, true}, request_dest, next, next_steps, total + abs(last-request))
      false -> calculate_steps({add_start, add_end}, request, request_dest, next, next_steps, total + abs(last-next))
    end
  end
end
