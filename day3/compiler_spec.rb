# encoding: ASCII-8BIT

require_relative 'spec_helper'

CompilerTestCases = {
  '1+2' => "\x01\x01\x00\x00\x00" "\x01\x02\x00\x00\x00" "\x0B" "\x00",
  '12*34 + 45/56 + ~(25**2)**3**4' =>
    "\x01\x0C\x00\x00\x00" "\x01\x22\x00\x00\x00" "\x05" \
    "\x01\x2D\x00\x00\x00" "\x01\x38\x00\x00\x00" "\x06" \
    "\x0B" \
    "\x01\x19\x00\x00\x00" "\x01\x02\x00\x00\x00" "\x04" "\x03" \
    "\x01\x03\x00\x00\x00" "\x01\x04\x00\x00\x00" "\x04" "\x04" "\x0B" "\x00",
}

describe Compiler do
  it 'can do the test cases' do
    CompilerTestCases.each do |str, bytecode|
      expect(Compiler.compile_to_bytecode(str)).to eq bytecode
    end
  end
end
