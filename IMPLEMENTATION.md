Elevator system implementation
==============================

### Part 2: Implementation

Write a command line interface to simulate the movements of the elevator(s). The
program should track the status of each elevator and this data should persist
between program executions.

Keep these questions in mind as you are working:

- What objects and interfaces need to be built?
  Basic: Elevator, Person, ElevatorOperator, Queue
- What algorithms will you need?
  It's kind of like a negamax algorithm in that I calculate a current best score and remove a possibility once it no longer matches up to that best score. Once I have a 'winner' I prevent myself from doing any uneeded calculation.  Additionally, the tail call optimized version I'm using is ideally suited for Elixir.
- What persistent data storage should you use?
  Genserver will handle persistence

Include a description of what your implementation would have included if you had
been given more time.

A genserver that async moves the elevators between turn.  I would also probably make directionality more of a first class citizen to make it more real life. At the moment, my elevator optimizes for number of steps an elevator must take across the board rather than continuing up with any new up requests that board the elevator.

User feedback is another problem with the app.  If a destination is in range of an elevator, I keep the current destination as the feedback that the user sees and then there is no alert that the person gets off.  For this reason. Running 'iex -S mix', 'ElevatorOperator.start(floors, elevators)', and 'ElevatorOperator.Attendant.request_floor(request, request_dest)' might be a better way to test.  Additionally 'ElevatorOperator.Attendant.get_state' allows you to analyze the current state of the genserver.

Better supervision behavior would also be great so that in the case of an error I can make sure I pass the previous state onto the next server and that would increase my error handling.

I'd break the CLI out into another application so that there is no dependence between the elevator operator and it's CLI.
