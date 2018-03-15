require_relative 'bytecode'

class VM
  def self.run(bytecode)
    vm = new(bytecode)
    vm.run
    vm.stack
  end

  attr_reader :stack

  def initialize(bytecode)
    @code = bytecode.dup.force_encoding('BINARY')
    @index = 0
    @stack = []  # unlimited stack space
  end

  def run
    while @code[@index]
      run_one_opcode
    end
  end

  def run_one_opcode
    return if @halt
    opcode = @code[@index].ord
    return if opcode.nil?
    @index += 1
    case opcode
    when Bytecode::LITERAL
      if @index + 4 > @code.size
        raise "Expected four bytes after literal, but code ends"
      end
      num = @code[@index + 0].ord << 0 |
            @code[@index + 1].ord << 8 |
            @code[@index + 2].ord << 16 |
            @code[@index + 3].ord << 24
      @stack.push(num)
      @index += 4
    when Bytecode::ADD
      @stack.push @stack.pop + @stack.pop
    when Bytecode::HALT
      @halt = true
    else
      raise "Opcode #{opcode} not implemented in VM."
    end
  end
end
