defmodule ElevatorOperator.Attendant do
  use GenServer

  # API #

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  def request_lift(current_floor, destination) do
    GenServer.call(__MODULE__, {:request_lift, current_floor, destination})
  end

  # CALLBACKS #

  def init(args) do
    elevators = Enum.map((0..List.last(args)-1), fn(n) -> %Elevator{name: n} end)
    {:ok, %{floors: List.last(args), elevators: elevators}}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:request_lift, current_floor, destination}, _from, state) do
    current_statuses(state.elevators) |> IO.puts()
    # %Occupant{} |> next_available_lift() |> IO.puts()
    # move_elevators
    # current_statuses |> IO.puts()
    {:reply, nil, state}
  end

  # HELPER METHODS #

    # Status
    defp current_statuses(elevators) do
      Enum.reduce(elevators, "", fn(el, msg) ->
        msg <> current_status(el)
      end)
    end
    defp current_status(el) do
      "\nElevator #{el.name} is currently on floor #{el.current_floor} and #{current_action(el.destination)}"
    end
    defp current_action(nil), do: "ready"
    defp current_action(destination), do: "in transit to #{destination}"
end
