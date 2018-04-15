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
  Breadth first search to find closest elevator in a directed graph
- What persistent data storage should you use?
  Genserver will handle persistence

Include a description of what your implementation would have included if you had
been given more time.
