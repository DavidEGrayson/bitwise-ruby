#!/usr/bin/env ruby

# Usage: echo '1+2' | ./compile.rb | ./run.rb

require_relative 'compiler'
begin
  source = ARGF.read
  print Compiler.compile_to_bytecode(source)
rescue LexError, ParseError => e
  $stderr.puts e
  exit 1
end
