defmodule ElevatorOperator do
  use Application

  def start(floors, elevators) do
    import Supervisor.Spec

    children = [
      worker(ElevatorOperator.Attendant, [[floors, elevators]])
    ]

    opts = [
      strategy: :one_for_one,
      name: ElevatorOperator.Supervisor
    ]

    Supervisor.start_link(children, opts)
    ElevatorOperator.CLI.request_floor()
  end
end
