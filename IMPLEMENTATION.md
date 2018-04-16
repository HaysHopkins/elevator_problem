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
  It's kind of like a negamax algorithm in that I calculate a current best score and remove a possibility once it no longer matches up to that best score.
- What persistent data storage should you use?
  Genserver will handle persistence

Include a description of what your implementation would have included if you had
been given more time.

A genserver that async moves the elevators between turn.  I would also probably make directionality more of a first class citizen to make it more real life. At the moment, my elevator optimizes for number of steps an elevator must take across the board rather than continuing up with any new up requests that board the elevator.
