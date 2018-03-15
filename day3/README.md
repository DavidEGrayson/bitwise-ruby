Day 3: More Programming & Parsing
----

In the [Day 3 video](https://www.youtube.com/watch?v=L4P98pGhpnE) video, Per
challenges us to write a stack-based virtual machine for the operators we had in
our little language, and then use our parser to compile bytecode for that
virtual machine.

I didn't want to use the traditional Ruby project structure.  To run the tests,
just do:

    gem install rspec
    rspec *spec.rb