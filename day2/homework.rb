class ParseError < RuntimeError
end

class Lexer
  attr_reader :expected

  def initialize(str)
    @stream = str.each_char
    @expected = []
  end

  def peek
    @token = read_next_token if !@started
    @token
  end

  def next
    @expected = []
    token = peek
    @token = read_next_token
    token
  end

  def error
    msg = "Expected any of #{@expected.inspect}, " \
          "got #{peek.inspect}."
    ParseError.new(msg)
  end

  def try(*matchers)
    @expected.concat matchers
    token = peek
    return nil if !matchers.any? { |m| m === token }
    self.next
    token
  end

  def require(*matchers)
    try(*matchers) or raise error
  end

  def require_end
    return if peek == nil
    raise ParseError, "Expected end of input, got #{peek.inspect}."
  end

  private

  def read_next_token
    @started = true

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
    when '*', '+', '/', '+', '~', '-', '(', ')'
      op = @stream.next.intern
      if op == :* && @stream.peek == '*'
        op = :**
        @stream.next
      end
      op
    else
      raise ParseError, "I dunno #{@stream.peek.inspect}"
    end
  rescue StopIteration
  end
end

# EBNF grammar:
#
# expr5 = integer | "(" expr1 ")"
# expr4 = "-" expr4 | "~" expr4 | expr5
# expr3 = expr4 [ "**" expr3 ]
# expr2 = expr3 | expr2 ( "*" | "/" | "%" | "<<" | ">>" | "&" ) expr3
# expr1 = expr2 | expr1 ( "+" | "-" | "|" | "^" ) expr2
class Parser
  def initialize(str)
    @lexer = Lexer.new(str)
  end

  def parse_expr5
    token = @lexer.require(Integer, :'(')
    case token
    when Integer
      token
    when :'('
      expr = parse_expr1
      @lexer.require :')'
      expr
    end
  end

  # Unary right associatitvity is easy.
  def parse_expr4
    if token = @lexer.try(:-, :~)
      [token, parse_expr4]
    else
      parse_expr5
    end
  end

  # Binary right associativity is easy.
  def parse_expr3
    expr = parse_expr4
    if @lexer.try(:**)
      [:**, expr, parse_expr3]
    else
      expr
    end
  end

  # Binary left associativity requires a little loop?
  def parse_expr2
    expr = parse_expr3
    while token = @lexer.try(:*, :/, :%, :<<, :>>, :&)
      expr = [token, expr, parse_expr3]
    end
    expr
  end

  # Binary left associativity requires a little loop?
  def parse_expr1
    expr = parse_expr2
    while token = @lexer.try(:+, :-, :|, :^)
      expr = [token, expr, parse_expr2]
    end
    expr
  end

  def parse_expr
    expr = parse_expr1
    @lexer.require_end
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
while token = lexer.next
  tokens << token
end
p tokens

# Test the parser.
begin
  parser = Parser.new(input)
  puts format_s_expr(parser.parse_expr)
rescue ParseError => e
  $stderr.puts e
  exit 1
end
