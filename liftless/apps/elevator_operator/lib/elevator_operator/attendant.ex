defmodule ElevatorOperator.Attendant do
  use GenServer

  # API #

  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  # CALLBACKS #

  def init(args) do
    elevators = Enum.map((0..List.last(args)-1), fn(n) -> %Elevator{name: n} end)
    {:ok, %{floors: List.last(args), elevators: elevators}}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end
end
