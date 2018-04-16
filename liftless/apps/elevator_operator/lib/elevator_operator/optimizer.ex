defmodule ElevatorOperator.Optimizer do
  @initial_min 999999999999999999999999999999999999999999999999999999999999999999999999999999999999

  def find_nearest_elevator(elevators, request, request_dest) do
    Enum.reduce(elevators, {nil, @initial_min, nil}, fn(el, min)->
      calculate_steps({true, true}, request, request_dest, el.current_floor, [el.destination | el.next], 0, min)
      |> Tuple.append(el.name)
      |> take_min(min)
    end)
  end

  # Stop calculating if total is greater than the current min
  defp calculate_steps(_, _, _, _, _, total, min) when total > min, do: {{false, false}, :infinity}
  # No destination, return total
  defp calculate_steps(_, request, request_dest, current, [nil | _], _, _),
        do: {{true, true}, abs(current-request) + abs(request-request_dest)}
  # Need to add both request and destination because netiher are in list
  defp calculate_steps(_, req, req_dest, last, [], total, _), do: {{true, true}, total + abs(req-last) + abs(req-req_dest)}
  # request in later range, return total
  defp calculate_steps({add_start, add_end}, request, request_dest, last, [next | next_steps], total, min) do
    case request in last..next do
      true -> calculate_steps({false, true}, request_dest, next, next_steps, total + abs(last-request), min)
      false -> calculate_steps({add_start, add_end}, request, request_dest, next, next_steps, total + abs(last-next), min)
    end
  end

  # Stop calculating if total is greater than the current min
  defp calculate_steps(_, _, _, _, total, min) when total > min, do: {{false, false}, :infinity}
  # Requests in range of current lift movements, return total
  defp calculate_steps({false, false}, _, _, _, total, _), do: {{false, false}, total}
  # Request in range, need to add destination because no more are in list
  defp calculate_steps({false, true}, req_dest, last, [], total, _), do: {{false, true}, total + abs(last-req_dest)}
  # Start calculating from destination once start is determined to be within range
  # POTENTIAL OPTIMIZATION: MIGHT WANT TO ESTABLISH BASE DIFFERENCE BASED ON BUILDING HEIGHT
  # ON WHEN TO CONTINUE IN SAME DIRECTION, EVEN IF IT MEANS ALTERING SCHEDULE MIDWAY
  defp calculate_steps({false, true}, request_dest, last, [next | next_steps], total, min) do
    case request_dest in last..next do
      true -> calculate_steps({false, false}, request_dest, next, next_steps, total + abs(last-request_dest), min)
      false -> calculate_steps({false, true}, request_dest, next, next_steps, total + abs(last-next), min)
    end
  end

  defp take_min({x, val1, y}, {_, val2, _}) when val1 < val2, do: {x, val1, y}
  defp take_min({_, val1, _}, {i, val2, j}) when val2 <= val1, do: {i, val2, j}
end
