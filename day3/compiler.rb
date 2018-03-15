require_relative 'parser'
require_relative 'bytecode'

module Compiler
  BinaryOps = {
    :** => Bytecode::EXPONENT,
    :* => Bytecode::MULTIPLY,
    :/ => Bytecode::DIVIDE,
    :% => Bytecode::MODULO,
    :<< => Bytecode::LEFT_SHIFT,
    :>> => Bytecode::RIGHT_SHIFT,
    :& => Bytecode::AND,
    :+ => Bytecode::ADD,
    :- => Bytecode::SUBTRACT,
    :| => Bytecode::OR,
    :^ => Bytecode::XOR,
  }

  UnaryOps = {
    :~ => Bytecode::COMPLEMENT,
    :- => Bytecode::NEGATE,
  }

  def self.compile_to_bytecode(str)
    sexp = Parser.parse(str)
    buffer = (+'').force_encoding('BINARY')
    sexp_to_bytecode(buffer, sexp)
    buffer.concat(Bytecode::HALT)
    buffer
  end

  def self.sexp_to_bytecode(buffer, sexp)
    if sexp.is_a?(Integer)
      int = sexp
      if int < -0x8000_0000 || int > 0x7FFF_FFFF
        raise "Integer #{int} too big to fit in bytecode."
      end
      buffer.concat(Bytecode::LITERAL)

      if int < 0
        int += 0x10000_0000
      end
      buffer.concat(int >> 0 & 0xFF)
      buffer.concat(int >> 8 & 0xFF)
      buffer.concat(int >> 16 & 0xFF)
      buffer.concat(int >> 24 & 0xFF)
    elsif sexp.is_a?(Array)
      # We check the sexp.size because we don't trust the parser to emit correct
      # stuff every time and simple checks like this will help us catch issues
      # earlier.

      if opcode = BinaryOps[sexp.first]
        if sexp.size != 3
          raise "Expected #{sexp.first} sexp to have 3 elements, got #{sexp.size}."
        end
        sexp_to_bytecode(buffer, sexp[1])
        sexp_to_bytecode(buffer, sexp[2])
        buffer.concat(opcode)
      end

      if opcode = UnaryOps[sexp.first]
        if sexp.size != 2
          raise "Expected #{sexp.first} sexp to have 2 elements, got #{sexp.size}."
        end
        sexp_to_bytecode(buffer, sexp[1])
        buffer.concat(opcode)
      end
    end
  end
end
