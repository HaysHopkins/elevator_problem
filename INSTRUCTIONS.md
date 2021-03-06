Welcome to the ETHOS Team practical test!

The goal of this exercise is to test your general problem solving and
programming ability. You may choose any language and technology stack with which
you are comfortable.

Problem
-------

Imagine that you are tasked to design the elevator system for a building. The
building is still in the design phase and has an unlimited budget therefore you
are free to come up with any design you like. You will have a two part challenge
to design and implement this system.

### Part 1: Design

Design an efficient, secure, and scalable system. Your design should be for your
definition of a production-ready system. The minimum set of questions your
design should answer are:

- What’s the most effective way to move people?
- How will your system scale?
- What can fail? How will your system recover?
- What are the security concerns?

Describe your design in [DESIGN.md](DESIGN.md)

### Part 2: Implementation

Write a command line interface to simulate the movements of the elevator(s). The
program should track the status of each elevator and this data should persist
between program executions.

Keep these questions in mind as you are working:

- What objects and interfaces need to be built?
- What algorithms will you need?
- What persistent data storage should you use?

Tell us about your implementation in [IMPLEMENTATION.md](IMPLEMENTATION.md).

Include a description of what your implementation would have included if you had
been given more time.

#### Minimum requirements

Your implementation should prompt the user for inputs:

- Their current floor
- Desired floor

Your implementation needs the option to put an elevator in maintenance mode

After each input you should display the following:

- Current status of each elevator
- Which elevator the user should take
- The ending status of each elevator

#### Turns/Runs:

- Each elevator can take one action per turn.
- The state of each elevator must be maintained between runs
- At the beginning of a run you should assume that the elevator is in the same state as its previous run.
- At the end of each run/turn the elevator status is whatever action it is doing (i.e. Elevator A in transit to 5).
- At the end of each run you should you should clear the status for the elevators you are not working on (i.e. Elevator A is ready on 5).

#### Example Runs

**Turn #1**

1. user requests elevator from lobby to 5th floor
1. elevator A is in the lobby
1. tell user to take elevator A
1. set elevator A in transit to 5

**Turn #2**

1. elevator A is in transit to 5
1. user requests elevator from lobby to 3
1. elevator B is in the lobby
1. tell user to take elevator B
1. set elevator B in transit to 3
1. set elevator A available on 5

Additional Notes
-----------------

You may use any resource at your disposal (like the internet).

If you have questions open an issue in this repo. We'll be notified and respond
as soon as we can.

Commit early and often - it helps us understand the project’s progression.

We'll remove your username as a collaborator of this repo at [DUE DATE/TIME]
and the test will be finished.

Our team will review your code within 1-2 business days and your Adobe Talent
Partner will contact you after that.
