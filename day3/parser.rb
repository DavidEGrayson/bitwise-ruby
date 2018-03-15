require_relative 'lexer'

class ParseError < RuntimeError
end

# EBNF grammar:
#
# expr5 = integer | "(" expr1 ")"
# expr4 = "-" expr4 | "~" expr4 | expr5
# expr3 = expr4 [ "**" expr3 ]
# expr2 = expr3 | expr2 ( "*" | "/" | "%" | "<<" | ">>" | "&" ) expr3
# expr1 = expr2 | expr1 ( "+" | "-" | "|" | "^" ) expr2
class Parser
  def self.parse(str)
    new(str).parse_expr
  end

  def initialize(str)
    @lexer = Lexer.new(str)
    @expected = []
  end

  def parse_expr
    expr = parse_expr1
    expect_end
    expr
  end

  private

  def next_token
    @expected = []
    @lexer.next_token
  end

  def peek
    @lexer.peek
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
    next_token
    token
  end

  def expect(*matchers)
    try(*matchers) or raise error
  end

  def expect_end
    return if peek == nil
    raise ParseError, "Expected end of input, got #{peek.inspect}."
  end

  def parse_expr5
    token = expect(Integer, :'(')
    case token
    when Integer
      token
    when :'('
      expr = parse_expr1
      expect :')'
      expr
    end
  end

  # Unary right associatitvity is easy.
  def parse_expr4
    if token = try(:-, :~)
      [token, parse_expr4]
    else
      parse_expr5
    end
  end

  # Binary right associativity is easy.
  def parse_expr3
    expr = parse_expr4
    if try(:**)
      [:**, expr, parse_expr3]
    else
      expr
    end
  end

  # Binary left associativity requires a little loop?
  def parse_expr2
    expr = parse_expr3
    while token = try(:*, :/, :%, :<<, :>>, :&)
      expr = [token, expr, parse_expr3]
    end
    expr
  end

  # Binary left associativity requires a little loop?
  def parse_expr1
    expr = parse_expr2
    while token = try(:+, :-, :|, :^)
      expr = [token, expr, parse_expr2]
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
