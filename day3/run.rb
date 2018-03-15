#!/usr/bin/env ruby

require_relative 'vm'

bytecode = ARGF.read
stack = VM.run(bytecode)
stack.each do |n|
  puts n
end
