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
    top_floor = List.last(args)-1
    request_queues = Map.new((0..top_floor), fn(floor) ->
                    {floor, []}
                  end)
    elevators = Enum.map((0..top_floor), fn(floor) ->
                  %Elevator{name: floor, destination_queues: Map.new(request_queues), max_floor: top_floor}
                end)

    {:ok, %{elevators: elevators, request_queues: request_queues}}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:request_lift, current_floor, destination}, _from, state) do
    current_statuses(state.elevators) |> IO.puts()
    %Occupant{request_floor: current_floor, destination: destination} |> enqueue_rider() |> IO.puts()
    # move_elevators
    # current_statuses |> IO.puts()
    {:reply, nil, state}
  end


  # PRIVATE HELPER METHODS #

    # Status #
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

    # Elevator Assignment #
    defp enqueue_rider(occupant) do

    end

    # Elevator Movement #
    defp move_elevators do

    end

end
