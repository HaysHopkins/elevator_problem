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
    elevators = Enum.map((0..List.first(args)-1), fn(floor) ->
                  %Elevator{name: floor, destination_queues: Map.new(request_queues), max_floor: top_floor}
                end)

    {:ok, %{elevators: elevators, top_floor: top_floor}}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:request_lift, current_floor, destination}, _from, state) do
    announce_current_statuses(state.elevators)

    pre_move_state = %Occupant{request_floor: current_floor, destination: destination}
                      |> enqueue_rider(state.request_queues)
                      |> create_pre_move_state(state)

    post_assign_state = ElevatorOperator.Optimizer.find_nearest_elevator(state.elevators, current_floor, destination)
                        |> announce_nearest_elevator()
                        |> update_elevator(state.elevators, current_floor, destination)
                        # |> create_post_assign_state(pre_move_state)

    # post_move_state = move_elevators(state.elevators)
    #                   |> create_post_move_state()

    {:reply, nil, pre_move_state}
  end


  # PRIVATE HELPER METHODS #


    # Status Announcements #

    defp announce_current_statuses(elevators) do
      Enum.reduce(elevators, "", fn(el, msg) ->
        msg <> current_status(el)
      end)
      |> IO.puts()
    end

    defp current_status(el) do
      "\nElevator #{el.name} is currently on floor #{el.current_floor} and #{current_action(el.destination)}"
    end

    defp current_action(nil), do: "ready"
    defp current_action(destination), do: "in transit to #{destination}"

    def announce_nearest_elevator({update_needed, steps, name}) do
      IO.puts "Current requester will be picked up by elevator #{name} in #{steps} moves"
      {update_needed, steps, name}
    end

    # Elevator Request Queuing #

    defp enqueue_rider(occupant, request_queues) do
      %{request_queues | occupant.request_floor => [occupant | request_queues[occupant.request_floor]]}
    end

    # Elevator Assignment #

    def update_elevator(update_data, elevators, current_floor, destination) do
      IO.inspect(update_data)
      IO.inspect(elevators)
    end

    # Elevator Movement #

    defp move_elevators(elevators) do
      Enum.map(elevators, fn(el) -> end)
    end

    # State Maintenance #

    defp create_pre_move_state(request_queues, state) do
      %{state | request_queues: request_queues}
    end

    defp create_post_assign_state(elevators, state) do
      %{state | elevators: elevators}
    end

    defp create_post_move_state() do

    end
end
