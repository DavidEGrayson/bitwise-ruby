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

# EBNF grammar:
#
# number = "-" number | "~" number | integer
# term = number | term ( "*" | "/" | "%" | "<<" | ">>" | "&" ) number
# expr = term | expr ( "+" | "-" | "|" | "^" ) term
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
    term = parse_number
    while [:*, :/, :%, :<<, :>>, :&].include?(@lexer.token)
      op = @lexer.token
      @lexer.next_token
      term = [op, term, parse_number]
    end
    term
  end

  def parse_expr
    expr = parse_term
    while [:+, :-, :|, :^].include?(@lexer.token)
      op = @lexer.token
      @lexer.next_token
      expr = [op, expr, parse_term]
    end

    if @lexer.token
      raise "Expected expression operator or end, got #{@lexer.token.inspect}"
    end

    expr
  end
end

def format_s_expr(expr)
  case expr
  when Array
    '(' + expr.map(&method(:format_s_expr)).join(' ') + ')'
  else
    expr.to_s
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
puts format_s_expr(parser.parse_expr)
