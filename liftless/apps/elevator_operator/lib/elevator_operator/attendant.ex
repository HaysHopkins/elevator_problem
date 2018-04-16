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
    GenServer.call(__MODULE__, {:request_lift, request-1, request_destination-1})
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

    {:ok, %{elevators: elevators, request_queues: request_queues, top_floor: top_floor}}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:request_lift, request, request_dest}, _from, state) do
    announce_current_statuses(state.elevators)

    elevator_data = ElevatorOperator.Optimizer.find_nearest_elevator(state.elevators, request, request_dest)

    post_enqueue_state = elevator_data
                         |> announce_nearest_elevator()
                         |> enqueue_rider(request, request_dest, state.request_queues)
                         |> create_post_enqueue_state(state)

    post_assign_state = elevator_data
                        |> assign_elevator(state.elevators, request, request_dest)
                        |> create_post_assign_state(post_enqueue_state)

    post_move_state = post_assign_state
                      |> operate_elevators()
                      # |> IO.inspect()
                      # |> create_post_move_state(post_assign_state)

    {:reply, nil, post_enqueue_state}
  end


  # PRIVATE HELPER METHODS #


    # Status Announcements #

    defp announce_current_statuses(elevators) do
      elevators
      |> current_statuses()
      |> IO.puts()
    end

    def announce_nearest_elevator({update_needed, _, name}) do
      IO.puts "Current requester will be picked up by elevator #{name}"
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

    defp enqueue_rider({_, _, name}, request, request_dest, request_queues) do
      occupant = %Occupant{request: request, request_dest: request_dest, elevator: name}
      %{request_queues | occupant.request => [occupant | request_queues[occupant.request]]} # CUTTER!
    end

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

        boarding = Enum.filter(new_request_queues[el.current_floor], fn(next)->
                      next.elevator == el.name
                   end)

        IO.inspect boarding
        # updated_request_queue = update_request_queue(new_request_queues, boarding, current_floor)

        # new_el = Elevator.execute_turn(el, boarding)

        # {[new_el | new_els], updated_request_queue}
      end)
    end

    # State Maintenance #

    defp create_post_enqueue_state(request_queues, state) do
      %{state | request_queues: request_queues}
    end

    defp create_post_assign_state(elevators, state) do
      %{state | elevators: elevators}
    end

    defp update_request_queue() do

    end

    defp create_post_move_state({elevators, request_queues}, state) do
      %{state | elevators: elevators, request_queues: request_queues}
    end
end
