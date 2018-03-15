Day 3: More Programming & Parsing
----

In the [Day 3 video](https://www.youtube.com/watch?v=L4P98pGhpnE) video, Per
challenges us to write a stack-based virtual machine for the operators we had in
our little language, and then use our parser to compile bytecode for that
virtual machine.

To play with my compiler and VM implemented in Ruby, use the CLIs:

    $ ./compile.rb <<< '1 + 10/3' | ./run.rb
    4

To run the tests:

    gem install rspec
    rspec *spec.rb

