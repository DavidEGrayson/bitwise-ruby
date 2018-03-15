module Bytecode
  HALT = 0
  LITERAL = 1   # push int32_t onto stack from bytecode
  NEGATE = 2
  COMPLEMENT = 3
  EXPONENT = 4    # (1 below TOS) raised to the power of (TOS)
  MULTIPLY = 5
  DIVIDE = 6
  MODULO = 7
  LEFT_SHIFT = 8   # (1 below TOS) << (TOS)
  RIGHT_SHIFT = 9  # (1 below TOW) >> (TOS)
  AND = 10
  ADD = 11
  SUBTRACT = 12    # (1 below TOS) - (TOS), like Per's example
  OR = 13
  XOR = 14
end
