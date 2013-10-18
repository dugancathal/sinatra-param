require 'spec_helper'
require 'sinatra/param/transformer'

describe Sinatra::Param::Transformer do
  it 'takes a symbol, converts it into a proc, and transforms the input' do
    transformed = Sinatra::Param::Transformer.transform('hello world', :upcase)
    transformed.should eq('HELLO WORLD')
  end

  it 'takes a block/lambda/proc and transforms the input' do
    transformed = Sinatra::Param::Transformer.transform(5, ->(num) { num.to_f })
    transformed.should eq(5.0)
  end

  it 'returns the original value if no transformer is defined' do
    transformed = Sinatra::Param::Transformer.transform(5, nil)
    transformed.should eq(5)
  end
end
