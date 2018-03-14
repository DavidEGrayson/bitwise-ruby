# Assignment: Parse an infix expression compose of integer literls and the
# following operators, highest to lowest precedence:
#
# unary -, unary ~
# * / % << >> &
# + - | ^

class Lexer
  attr_reader :token

  def initialize(str)
    @stream = str.each_char
  end

  def next_token
    @token = read_next_token
  end

  private
  def read_next_token
    while [' ', "\n"].include?(@stream.peek)
      @stream.next
    end

    case @stream.peek
    when '0'..'9'
      value = 0
      while ('0'..'9').include?(@stream.peek)
        value = value * 10 + @stream.next.to_i
      end
      value
    when '*', '+', '/', '+', '~'
      @stream.next.intern
    else
      raise "I dunno #{@stream.peek.inspect}"
    end
  rescue StopIteration
  end
end

input = ARGF.read
lexer = Lexer.new(input)

# Test the lexer.
tokens = []
while token = lexer.next_token
  tokens << token
end
p tokens

# Test the parser.
