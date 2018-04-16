Elevator system design
======================
### Part 1: Design

Design an efficient, secure, and scalable system. Your design should be for your
definition of a production-ready system. The minimum set of questions your
design should answer are:

- What’s the most effective way to move people?
  Get the elevator that has the fewest number of planned steps to get to the person and move them to the next elevator

- How will your system scale?
  Since Elixir allows for many simultaneous processes without breaking a sweat, the system should scale relatively easily to any real life use case. Synchronicity between the various functions in a real setting seem like a huge challenge though.

- What can fail? How will your system recover?
  -Floor mismatch between request and actual location of elevator due to the problem that the elevator is continuously moving; the simplest solution is to move on to the next available when a mismatch is detected
  -No elevator available; need a request queue of riders (probably subdivided by floor and direction) (ADDED)

- What are the security concerns?
  -App security: Having the 'execute_turn' method on elevator publicly accessible could definitely be a problem. To go into production, I would need to remove all but access to state and request methods.
  -Within the app: Can anyone go to any floor? A more advanced design would persist individuals and those individuals would only have access to certain floors


In order to be production ready a lift must move in real time, be able to handle new incoming requests while in transit, and stop to let people out/in.  For MVP purposes, I would narrow this down slightly to fit the CLI implementation.  Any new request counts as a new action for the elevator (it moves to a new floor).  The request process in this case will be synchronous.  If I acheive that soon enough, the next step will be to move even more functionality into genservers so that asynchronous behavior better imitates the real world conditions of an elevator (an elevator can go multiple floors between requests).

UPDATE: Using a genserver to store state quickly became a necessity.  The next step would then be to create an async genserver that operates the elevators even when turns aren't being made.  This would require me to update my algorithm for a dynamic environment and would present far more challenges.  I was happy that I did make the application deal with continuous movement instead of the magic teleportation that I thought the prompt initially requested.
