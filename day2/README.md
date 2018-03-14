Day 2: C Programming and Parsing
----

In this video, Per showed how to write a lexer in C, and I wrote it in Ruby.

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
