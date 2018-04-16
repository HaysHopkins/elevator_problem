defmodule ElevatorOperator.Attendant do
  use GenServer

  # API #

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  def request_lift(request, request_destination) do
    GenServer.call(__MODULE__, {:request_lift, request, request_destination})
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

  def handle_call({:request_lift, request, request_Dest}, _from, state) do
    announce_current_statuses(state.elevators)

    elevator_data = ElevatorOperator.Optimizer.find_nearest_elevator(state.elevators, request, request_dest)

    post_enqueue_state = elevator_data
                         |> announce_nearest_elevator()
                         |> enqueue_rider(current_floor, destination, state)
                         |> create_post_enqueue_state(state)

    post_assign_state = elevator_data
                        |> assign_elevator(state.elevators, request, request_dest)
                        |> create_post_assign_state(post_enqueue_state)

    # post_move_state = move_elevators(state.elevators)
    #                   |> create_post_move_state()

    {:reply, nil, pre_move_state}
  end


  # PRIVATE HELPER METHODS #


    # Status Announcements #

    defp announce_current_statuses(elevators) do
      elevators
      |> current_statuses()
      |> IO.puts()
    end

    def announce_nearest_elevator({update_needed, steps, name}) do
      IO.puts "Current requester will be picked up by elevator #{name} in #{steps} moves"
      {update_needed, steps, name}
    end

    defp current_statuses(els) do
      Enum.reduce(els, "", fn(el, msg) ->
        msg <> current_status(el)
      end)
    end

    defp current_status(el) do
      "\nElevator #{el.name} is currently on floor #{el.current_floor} and #{current_action(el.destination)}"
    end

    defp current_action(nil), do: "ready"
    defp current_action(destination), do: "in transit to #{destination}"

    # Elevator Assignment #

    defp enqueue_rider({_, _, name}, request, request_dest, state) do
      occupant = %Occupant{request: request, request_dest: request_dest, elevator: name}
      %{request_queues | occupant.request => [occupant | request_queues[occupant.request_floor]]}
    end

    def assign_elevator({{false, false}, _, _}, elevators, _, _), do: elevators
    def assign_elevator({{false, true}, _, name}, elevators, _, destination) do
      Enum.reduce(elevators, [], fn(el, new_els)->
        if el.name == name
        end
      end)
    end
    def assign_elevator(update_data, elevators, current_floor, destination) do
      IO.inspect(update_data)
      IO.inspect(elevators)
    end

    # Elevator Movement #

    defp move_elevators(elevators) do
      Enum.map(elevators, fn(el) -> end)
    end

    # State Maintenance #

    defp create_post_enqueue_state(request_queues, state) do
      %{state | request_queues: request_queues}
    end

    defp create_post_assign_state(elevators, state) do
      %{state | elevators: elevators}
    end

    defp create_post_move_state({elevators, request_queues}, state) do
      %{state | elevators: elevators, request_queues: request_queues}
    end
end
