require_relative 'spec_helper'

IntegrationTestCases = {
  "0" => 0,
  "-123456789" => -123456789,
  "~1" => -2,
  "2**4" => 16,
  "8 * 3\n" => 24,
  "(3+7)/2" => 5,
  "9 % 4" => 1,
  "2 << 2" => 8,
  "13 >> 1" => 6,
  "3 & 6" => 2,
  "1+2" => 3,
  "1-2" => -1,
  "3 | 6" => 7,
  "3 ^ 6" => 5,
}

describe 'Integration tests' do
  specify 'test cases' do
    IntegrationTestCases.each do |src, result|
      bytecode = Compiler.compile_to_bytecode(src)
      stack = VM.run(bytecode)
      expect(stack).to eq [result]
    end
  end
end
