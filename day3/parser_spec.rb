require_relative 'spec_helper'

describe Parser do
  it 'can do a little of everything' do
    str = "12*34 + 45/56 + ~(25**2)**3**4"
    sexp = "(+ (+ (* 12 34) (/ 45 56)) (** (~ (** 25 2)) (** 3 4)))"
    expect(format_s_expr(Parser.parse(str))).to eq sexp
  end
end
