require 'spec_helper'
require 'sinatra/param/coercer'

describe Sinatra::Param::Coercer do
  describe 'String' do
    it 'coerces strings' do
	    Sinatra::Param::Coercer.coerce(0, String).should eq('0')
	    Sinatra::Param::Coercer.coerce(42, String).should eq('42')
    end
  end

  describe 'Integer' do
	  it 'coerces integers' do
		  Sinatra::Param::Coercer.coerce(0, Integer).should eq(0)
		  Sinatra::Param::Coercer.coerce('42', Integer).should eq(42)
	  end
  end

  describe 'Float' do
	  it 'coerces floats' do
		  Sinatra::Param::Coercer.coerce(0.0, Float).should eq(0.0)
		  Sinatra::Param::Coercer.coerce('42', Float).should eq(42.0)
		  Sinatra::Param::Coercer.coerce('42.5', Float).should eq(42.5)
	  end
  end

  describe 'Time' do
	  it 'coerces times' do
		  Sinatra::Param::Coercer.coerce('20131017T00:00:00.000000Z', Time).should eq(Time.parse('20131017T00:00:00.000000Z'))
		  Sinatra::Param::Coercer.coerce('19930314T00:00:00.000000Z', Time).should eq(Time.parse('19930314T00:00:00.000000Z'))
	  end
  end

  describe 'Date' do
	  it 'coerces dates' do
		  Sinatra::Param::Coercer.coerce('20131017', Date).should eq(Date.parse('20131017'))
		  Sinatra::Param::Coercer.coerce('19930314', Date).should eq(Date.parse('19930314'))
	  end
  end

  describe 'DateTime' do
	  it 'coerces datetimes' do
		  Sinatra::Param::Coercer.coerce('20131017T00:00:00.000000Z', DateTime).should eq(DateTime.parse('20131017T00:00:00.000000Z'))
		  Sinatra::Param::Coercer.coerce('19930314T00:00:00.000000Z', DateTime).should eq(DateTime.parse('19930314T00:00:00.000000Z'))
	  end
  end

  describe 'Array' do
	  it 'coerces arrays' do
      Sinatra::Param::Coercer.coerce('1,2,3,4,5', Array).should eq(%w(1 2 3 4 5))
      Sinatra::Param::Coercer.coerce('val1,val2,val3,val4', Array).should eq(%w(val1 val2 val3 val4))
	  end
  end

  describe 'Hash' do
    it 'coerces hashes' do
      Sinatra::Param::Coercer.coerce('a:b,c:d', Hash).should eq('a' => 'b', 'c' => 'd')
      Sinatra::Param::Coercer.coerce('', Hash).should eq({})
    end
  end

  describe 'Boolean' do
    it 'coerces truthy booleans' do
      %w(1 true t yes y).each do |bool|
        Sinatra::Param::Coercer.coerce(bool, Boolean).should be
      end
    end

    it 'coerces falsy booleans' do
      %w(0 false f no n).each do |bool|
        Sinatra::Param::Coercer.coerce(bool, Boolean).should_not be
      end
    end
  end
end
