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

# Assignment: Parse an infix expression composed of integer literals and the
# following operators, highest to lowest precedence:
#
# unary -, unary ~ (right associative)
# * / % << >> &    (left associative)
# + - | ^          (left associative)
#
# EBNF grammar:
#
# number = "-" number | "~" number | integer
# term = number { ( "*" | "/" | "%" | "<<" | ">>" | "&" ) term }
# expr = term { ( "+" | "-" | "|" | "^" ) expr }
class Parser
  def initialize(str)
    @lexer = Lexer.new(str)
    @lexer.next_token
  end

  def parse_number
    case @lexer.token
    when :-, :~
      op = @lexer.token
      @lexer.next_token
      [op, parse_number]
    when Integer
      num = @lexer.token
      @lexer.next_token
      num
    else
      raise "Expected a number or unary operator, got #{@lexer.token}."
    end
  end

  def parse_term
    number = parse_number
    case @lexer.token
    when :*, :/, :%, :<<, :>>, :&
      op = @lexer.token
      @lexer.next_token
      [op, number, parse_term]
    else
      number
    end
  end

  def parse_expression
    term = parse_term
    case @lexer.token
    when nil
      term
    when :+, :-, :|, :^
      op = @lexer.token
      @lexer.next_token
      [op, term, parse_expression]
    else
      raise "Expected expression operator, got #{@lexer.token.inspect}"
    end
  end
end

input = ARGF.read

# Test the lexer.
lexer = Lexer.new(input)
tokens = []
while token = lexer.next_token
  tokens << token
end
p tokens

# Test the parser.
parser = Parser.new(input)
p parser.parse_expression
