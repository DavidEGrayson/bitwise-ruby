class LexError < RuntimeError
end

class Lexer
  def self.tokenize(str)
    lexer = Lexer.new(str)
    tokens = []
    while token = lexer.next_token
      tokens << token
    end
    tokens
  end

  def initialize(str)
    @str = str
    @index = 0
  end

  def peek
    @token = read_next_token if !@started
    @token
  end

  def next_token
    token = peek
    @token = read_next_token
    token
  end

  private

  def read_next_token
    @started = true

    while [' ', "\n"].include?(@str[@index])
      @index += 1
    end

    if @str[@index] == nil
      return nil  # end of input
    end

    case @str[@index]
    when '0'..'9'
      value = 0
      while ('0'..'9').include?(@str[@index])
        value = value * 10 + @str[@index].to_i
        @index += 1
      end
      value
    when '*', '+', '/', '+', '~', '-', '(', ')', '%', '<', '>', '&', '|', '^'
      op = @str[@index].intern
      @index += 1
      if op == :* && @str[@index] == '*'
        op = :**
        @index += 1
      end

      if op == :<
        if @str[@index] != '<'
          raise LexError, "After '<' I need another '<' pls."
        end
        op = :<<
        @index += 1
      end

      if op == :>
        if @str[@index] != '>'
          raise LexError, "After '>' I need another '<' pls."
        end
        op = :>>
        @index += 1
      end

      op
    else
      raise LexError, "I dunno #{@str[@index].inspect}"
    end
  end
end
