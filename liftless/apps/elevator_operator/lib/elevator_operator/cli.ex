defmodule ElevatorOperator.CLI do
  alias ElevatorOperator.{Attendant}

  def request_floor(floor) do
    IO.puts "Which floor are you on?"
    request = IO.gets "Make a selection: "
    {sanitized_request, _} = request |> sanitize_selection() |> Integer.parse()

    IO.puts "Which floor would you like to go to?"
    request_dest = IO.gets "Make a selection: "
    {sanitized_request_dest, _} = request_dest |> sanitize_selection() |> Integer.parse()

    if requests_not_in_range?(floor, sanitized_request, sanitized_request_dest) do
      IO.puts "Choice must be greater or equal to 0 and less than or equal to #{floor-1}"
      request_floor(floor)
    end

    Attendant.request_lift(sanitized_request, sanitized_request_dest)

    request_floor(floor)
  end

  defp sanitize_selection(selection), do: selection |> String.trim_trailing

  defp requests_not_in_range?(floor, r1, r2) do
    !(r1 in 0..floor-1 && r2 in 0..floor-1)
  end
end
