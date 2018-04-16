defmodule ElevatorOperator.CLI do
  alias ElevatorOperator.{Attendant}

  def request_floor("y"), do: System.stop(0)
  def request_floor("Y"), do: System.stop(0)
  def request_floor("yes"), do: System.stop(0)
  def request_floor("Yes"), do: System.stop(0)

  def request_floor(_) do
    IO.puts "Which floor are you on?"
    request = IO.gets "Make a selection: "
    {sanitized_request, _} = request |> sanitize_selection() |> Integer.parse()

    IO.puts "Which floor would you like to go to?"
    request_dest = IO.gets "Make a selection: "
    {sanitized_request_dest, _} = request_dest |> sanitize_selection() |> Integer.parse()

    Attendant.request_lift(sanitized_request, sanitized_request_dest)

    # Just forcing command c seems more user friendly here for larger # of inputs
    request_floor(sanitized_resp)
  end

  defp sanitize_selection(selection), do: selection |> String.trim_trailing
end
