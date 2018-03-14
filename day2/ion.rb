class Lexer
  attr_reader :token

  def initialize(str)
    @stream = str.each_char
  end

  def next_token
    case @stream.peek
    when '0'..'9'
      value = 0
      while ('0'..'9').include?(@stream.peek)
        value = value * 10 + @stream.next.to_i
      end
      @token = { kind: :int, value: value }
    when 'a'..'z', 'A'..'Z', '_'
      id = +''
      while ('a'..'z').include?(@stream.peek) ||
            ('A'..'Z').include?(@stream.peek) ||
            ('0'..'9').include?(@stream.peek) ||
            @stream.peek == '_'
        id << @stream.next
      end
      @token = { kind: :name, value: id.intern }
    else
      @token = { kind: @stream.next }
    end
  rescue StopIteration
    @token = nil
  end
end

input = ARGF.read
lexer = Lexer.new(input)
lexer.next_token
while lexer.token
  puts "TOKEN: #{lexer.token.inspect}"
  lexer.next_token
end
