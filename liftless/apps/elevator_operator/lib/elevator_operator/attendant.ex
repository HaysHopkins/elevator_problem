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
    top_floor = List.first(args)-1
    request_queues = Map.new((0..top_floor), fn(floor) ->
                      {floor, []}
                     end)
    elevators = Enum.map((0..List.last(args)-1), fn(floor) ->
                  %Elevator{name: floor, destination_queues: Map.new(request_queues), max_floor: top_floor}
                end)

    {:ok, %{elevators: elevators, request_queues: request_queues, top_floor: top_floor}}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:request_lift, request, request_dest}, _from, state) do
    announce_current_statuses(state.elevators)

    elevator_data = ElevatorOperator.Optimizer.find_nearest_elevator(state.elevators, request, request_dest)

    post_enqueue_state = enqueue(elevator_data, request, request_dest, state)

    post_assign_state = assign(elevator_data, request, request_dest, post_enqueue_state)

    post_move_state = post_assign_state
                      |> operate_elevators()
                      |> create_post_move_state(post_assign_state)

    announce_current_statuses(post_move_state.elevators)

    {:reply, nil, post_move_state}
  end


  # PRIVATE HELPER METHODS #

    def enqueue(elevator_data, request, request_dest, state) when request != request_dest do
      elevator_data
      |> announce_nearest_elevator()
      |> enqueue_rider(request, request_dest, state.request_queues)
      |> create_post_enqueue_state(state)
    end
    def enqueue(_, _, _, state), do: state

    def assign(elevator_data, request, request_dest, post_enqueue_state) when request != request_dest do
      elevator_data
      |> assign_elevator(post_enqueue_state.elevators, request, request_dest)
      |> create_post_assign_state(post_enqueue_state)
    end
    def assign(_, _, _, post_enqueue_state), do: post_enqueue_state

    # Elevator Assignment #

    defp assign_elevator({{false, false}, _, _}, elevators, _, _), do: elevators
    defp assign_elevator({{false, true}, _, name}, elevators, _, request_dest) do
      Enum.reduce(elevators, [], fn(el, new_els)->
        new_el = if (el.name == name), do: Elevator.add_destinations(el, [request_dest]), else: el
        [new_el | new_els]
      end)
      |> Enum.reverse()
    end
    defp assign_elevator({_, _, name}, elevators, request, request_dest) do
      Enum.reduce(elevators, [], fn(el, new_els)->
        new_el = if (el.name == name), do: Elevator.add_destinations(el, [request, request_dest]), else: el
        [new_el | new_els]
      end)
      |> Enum.reverse()
    end

    # Elevator Movement #

    defp operate_elevators(state) do
      Enum.reduce(state.elevators, {[], state.request_queues}, fn(el, {new_els, new_request_queues})->

        {boarding, waiting} = Enum.reduce(new_request_queues[el.current_floor], {[], []}, fn(next, {boarding, waiting})->
                  if (next.elevator == el.name), do: {[next | boarding], waiting}, else: {boarding, [next | waiting]}
                end)

        updated_request_queue = dequeue_riders(new_request_queues, el.current_floor, waiting)

        new_el = Elevator.execute_turn(el, boarding)

        {[new_el | new_els], updated_request_queue}
      end)
      |> reorder_elevators()
    end
    defp reorder_elevators({elevators, request_queues}), do: {Enum.reverse(elevators), request_queues}


    # State Maintenance #

    defp enqueue_rider({_, _, name}, request, request_dest, request_queues) do
      occupant = %Occupant{request: request, request_dest: request_dest, elevator: name}
      %{request_queues | occupant.request => [occupant | request_queues[occupant.request]]} # CUTTER!
    end

    defp dequeue_riders(request_queues, current_floor, waiting) do
      %{request_queues | current_floor => waiting}
    end

    defp create_post_enqueue_state(request_queues, state) do
      %{state | request_queues: request_queues}
    end

    defp create_post_assign_state(elevators, state) do
      %{state | elevators: elevators}
    end

    defp create_post_move_state({elevators, request_queues}, state) do
      %{state | elevators: elevators, request_queues: request_queues}
    end

    # Status Announcements #

    defp announce_current_statuses(elevators) do
      elevators
      |> current_statuses()
      |> IO.puts()
    end

    def announce_nearest_elevator({update_needed, steps, name}) do
      IO.puts "Current requester will be picked up by elevator #{name}"
      {update_needed, steps, name}
    end

    defp current_statuses(els) do
      Enum.reduce(els, "", fn(el, msg) ->
        msg <> current_status(el)
      end)
    end

    defp current_status(el) do
      "\nElevator #{el.name} is currently on floor #{el.current_floor} and #{current_action(el.destination, el.next, el.current_floor)}"
    end

    defp current_action(nil, [], _), do: "ready"
    defp current_action(destination, current_floor, []) when destination == current_floor do
     "ready"
    end
    defp current_action(nil, current_floor, [h | t]), do: current_action(h, current_floor, t)
    defp current_action(destination, [h | t], current_floor) when destination == current_floor do
      current_action(h, current_floor, t)
    end
    defp current_action(destination, _, _), do: "in transit to #{destination}"
end
