Elevator system implementation
==============================

### Part 2: Implementation

Write a command line interface to simulate the movements of the elevator(s). The
program should track the status of each elevator and this data should persist
between program executions.

Keep these questions in mind as you are working:

- What objects and interfaces need to be built?
  Basic: Elevator, Person, ElevatorOperator, Queue
  I created an Optimizer class for making decisions.  As I built more and more, I began to move things out of my ElevatorOperator::Attendant class.  It's to much of a 'master class' and I knew that would become a problem from the beginning.  I would definitely continue to break things out and leave that as just public API and gen server call backs.

- What algorithms will you need?
  It's kind of like a negamax algorithm in that I calculate a current best score and remove a possibility once it no longer matches up to that best score. Once I have a 'winner' I prevent myself from doing any uneeded calculation.  Additionally, the tail call optimized version I'm using is ideally suited for Elixir.

- What persistent data storage should you use?
  Genserver will handle persistence

Include a description of what your implementation would have included if you had
been given more time.

-First thing would definitely be TESTS.  I would want to test not only for accuracy of my algorithm, but also stress test it for different edge cases.  Given that my algo doesn't too strongly consider direction, I think there is some definite fine tuning that further testing would allow me to do.  I hope there are no bugs, but I can't guarantee that without tests.  Manual testing is so inadequate to the task. So, with more time I would definitely focus on tests to shore up what I've built so far.

-MAINTENANCE MODE: I put this one on the back burner because it felt simple like a simple 'if' statement problem.  Now that the deadline is approaching, I'm deciding I don't actually have enough time to touch it (don't want to break what I have!).

-One optimization I put in the Optimizer file would be to go out of my way in the same direction of elevator travel if that travel only puts me off by X steps (where X is some percent of overall building size). I would want to implement that or find some other way to make this behave more like a real elevator.  If you get on an elevator traveling up and request to go up higher than the current request, the elevator continues.  Mine might take the passenger down because going out of its way would mean potentially altering the calculations made for a number of other passengers (and I certainly don't want to calculate all passenger movements every time this happens).  I would need some sort of blanket rule here

-A genserver that async moves the elevators between turn.  I would also probably make directionality more of a first class citizen to make it more real life. At the moment, my elevator optimizes for number of steps an elevator must take across the board rather than continuing up with any new up requests that board the elevator.

-User feedback is another problem with the app.  If a destination is in range of an elevator, I keep the current destination as the feedback that the user sees and then there is no alert that the person gets off.  For this reason. Running 'iex -S mix', 'ElevatorOperator.start(floors, elevators)', and 'ElevatorOperator.Attendant.request_floor(request, request_dest)' might be a better way to test.  Additionally 'ElevatorOperator.Attendant.get_state' allows you to analyze the current state of the genserver.

-Better supervision behavior would also be great so that in the case of an error I can make sure I pass the previous state onto the next server and that would increase my error handling.

-I'd break the CLI out into another application so that there is no dependence between the elevator operator and it's CLI.

-Create a web interface replete with analytics views!
