require_relative 'spec_helper'

IntegrationTestCases = {
  "0" => [0],
  "1+2" => [3],
  "(3+7)/2" => [5],
}

describe 'Integration tests' do
  specify 'test cases' do
    IntegrationTestCases.each do |src, final_stack|
      bytecode = Compiler.compile_to_bytecode(src)
      stack = VM.run(bytecode)
      expect(stack).to eq final_stack
    end
  end
end
