class Lexer
  def initialize(str)
    @stream = str.each_char
  end

  def peek
    @token = read_next_token if !@started
    @token
  end

  def next
    token = peek
    @token = read_next_token
    token
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
    when '*', '+', '/', '+', '~', '(', ')'
      op = @stream.next.intern
      if op == :* && @stream.peek == '*'
        op = :**
        @stream.next
      end
      op
    else
      raise "I dunno #{@stream.peek.inspect}"
    end
  rescue StopIteration
  end
end

# EBNF grammar:
#
# expr5 = integer | "(" expr1 ")"
# expr4 = "-" expr4 | "~" expr4 | expr5
# expr3 = expr4
# expr2 = expr3 | expr2 ( "*" | "/" | "%" | "<<" | ">>" | "&" ) expr3
# expr1 = expr2 | expr1 ( "+" | "-" | "|" | "^" ) expr2
class Parser
  def initialize(str)
    @lexer = Lexer.new(str)
  end

  def parse_expr5
    case @lexer.peek
    when Integer
      @lexer.next
    when :"("
      @lexer.next
      expr = parse_expr1
      ending = @lexer.next
      if ending != :")"
        raise "Expected closing paren, got #{ending.inspect}."
      end
      expr
    end
  end

  # Unary right associatitvity is easy.
  def parse_expr4
    case @lexer.peek
    when :-, :~
      [@lexer.next, parse_expr4]
    else
      parse_expr5
    end
  end

  # Binary right associativity is easy.
  def parse_expr3
    expr = parse_expr4
    case @lexer.peek
    when :**
      [@lexer.next, expr, parse_expr3]
    else
      expr
    end
  end

  # Binary left associativity requires a little loop?
  def parse_expr2
    expr = parse_expr3
    while [:*, :/, :%, :<<, :>>, :&].include?(@lexer.peek)
      expr = [@lexer.next, expr, parse_expr3]
    end
    expr
  end

  # Binary left associativity requires a little loop?
  def parse_expr1
    expr = parse_expr2
    while [:+, :-, :|, :^].include?(@lexer.peek)
      expr = [@lexer.next, expr, parse_expr2]
    end
    expr
  end

  def parse_expr
    expr = parse_expr1
    if @lexer.peek
      raise "Expected end of input, got #{@lexer.peek.inspect}."
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
while token = lexer.next
  tokens << token
end
p tokens

# Test the parser.
parser = Parser.new(input)
puts format_s_expr(parser.parse_expr)
