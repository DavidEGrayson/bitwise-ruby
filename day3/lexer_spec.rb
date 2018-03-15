require_relative 'spec_helper'

describe Lexer do
  it 'can do a little of everything' do
    str = "12*34 + 45/56 + ~(25**2)**3**4"
    tokens = [12, :*, 34, :+, 45, :/, 56, :+, :~,
              :'(', 25, :**, 2, :')', :**, 3, :**, 4]
    expect(Lexer.tokenize(str)).to eq tokens
  end
end
