require_relative 'spec_helper'

LexerTestCases = {
  '1+2' => [1, :+, 2],
  "1+2\n" => [1, :+, 2],
  '12*34 + 45/56 + ~(25**2)**3**4' =>
    [12, :*, 34, :+, 45, :/, 56, :+, :~,
     :'(', 25, :**, 2, :')', :**, 3, :**, 4]
}

describe Lexer do
  it 'can do the test cases' do
    LexerTestCases.each do |str, tokens|
      expect(Lexer.tokenize(str)).to eq tokens
    end
  end
end
