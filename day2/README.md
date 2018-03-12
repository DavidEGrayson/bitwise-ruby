Day 2: C Programming and Parsing
----

In the [Day 2 video](https://www.youtube.com/channel/UCguWV1bZg1QiWbY32vGnOLw), Per showed how to write a lexer in C, and I wrote it in Ruby.

Demo:

```text
$ ruby ion.rb <<< '+()_HELLO1,234+FOO!994'
TOKEN: {:kind=>"+"}
TOKEN: {:kind=>"("}
TOKEN: {:kind=>")"}
TOKEN: {:kind=>:name, :value=>:_HELLO1}
TOKEN: {:kind=>","}
TOKEN: {:kind=>:int, :value=>234}
TOKEN: {:kind=>"+"}
TOKEN: {:kind=>:name, :value=>:FOO}
TOKEN: {:kind=>"!"}
TOKEN: {:kind=>:int, :value=>994}
TOKEN: {:kind=>"\n"}
```

Homework
--

Assignment: Parse an infix expression composed of integer literals and the
following operators, highest to lowest precedence:

    unary -, unary ~ (right associative)
    * / % << >> &    (left associative)
    + - | ^          (left associative)

I also did the first two extra credit objectives:

- Add right-associative exponentiation operator `**`.
- Add parenthesis support.

Demo:

```text
$ ruby homework.rb <<< '12*34 + 45/56 + ~(25**2)**3**4'
[12, :*, 34, :+, 45, :/, 56, :+, :~, :"(", 25, :**, 2, :")", :**, 3, :**, 4]
(+ (+ (* 12 34) (/ 45 56)) (** (~ (** 25 2)) (** 3 4)))
```

I also made the parser have nicer error messages than you usually see:

```text
$ ruby homework.rb <<< '(12'
[:"(", 12]
Expected any of [:**, :*, :/, :%, :<<, :>>, :&, :+, :-, :|, :^, :")"], got nil.
```