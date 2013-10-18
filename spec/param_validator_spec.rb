require 'spec_helper'
require 'sinatra/param/validator'

include Sinatra::Param

describe Validator do
  describe 'required => true' do
    it 'requires the presence of that param' do
      expect {
        Validator.validate!(nil, required: true)
      }.to raise_error(InvalidParameterError)
    end
  end

  describe 'required => false' do
    it 'does not require the presence of that param' do
      expect {
        Validator.validate!(nil, required: false)
      }.not_to raise_error
    end
  end

  describe 'blank' do
    it 'rejects empty strings' do
      expect {
        Validator.validate!('', blank: false)
      }.to raise_error(InvalidParameterError)
    end

    it 'rejects empty arrays' do
      expect {
        Validator.validate!([], blank: false)
      }.to raise_error(InvalidParameterError)
    end

    it 'rejects empty hashes' do
      expect {
        Validator.validate!({}, blank: false)
      }.to raise_error(InvalidParameterError)
    end
  end

  describe 'is' do
    it 'is valid when the supplied argument and param are equal' do
      expect {
        Validator.validate!(nil, is: nil)
        Validator.validate!(42, is: 42)
        Validator.validate!('Hello World', is: 'Hello World')
      }.not_to raise_error
    end

    it 'is invalid whenever the supplied argument and param are not equal' do
      expect {
        Validator.validate!(nil, is: true)
      }.to raise_error(InvalidParameterError)
      expect {
        Validator.validate!(42, is: 43)
      }.to raise_error(InvalidParameterError)
      expect {
        Validator.validate!('Hello World', is: 'Goodbye World')
      }.to raise_error(InvalidParameterError)
    end
  end

  describe 'in/within/range' do
    it 'requires the value to be included in the range/array' do
      expect {
        Validator.validate!(20, within: 15..25)
        Validator.validate!('b', range: 'a'..'d')
        Validator.validate!(42, in: [3.14159, 14, 42])
      }.not_to raise_error
    end

    it 'fails when the value is not in the range' do
      expect {
        Validator.validate!(1, within: 15..25)
      }.to raise_error(InvalidParameterError)
      expect {
        Validator.validate!('z', range: 'a'..'d')
      }.to raise_error(InvalidParameterError)
      expect {
        Validator.validate!(19, in: [3.14159, 14, 42])
      }.to raise_error(InvalidParameterError)
    end
  end

  describe 'min' do
    it 'requires that the value be greater than the specified amount' do
      expect {
        Validator.validate!(20, min: 15)
        Validator.validate!('c', min: 'b')
      }.not_to raise_error
    end

    it 'fails when the value is less than the specified amount' do
      expect {
        Validator.validate!(5, min: 15)
      }.to raise_error(InvalidParameterError)
      expect {
        Validator.validate!('a', min: 'b')
      }.to raise_error(InvalidParameterError)
    end
  end

  describe 'max' do
    it 'requires that the value be less than the specified amount' do
      expect {
        Validator.validate!(5, max: 15)
        Validator.validate!('a', max: 'b')
      }.not_to raise_error
    end

    it 'fails when the value is greater than the specified amount' do
      expect {
        Validator.validate!(20, max: 15)
      }.to raise_error(InvalidParameterError)
      expect {
        Validator.validate!('c', max: 'b')
      }.to raise_error(InvalidParameterError)
    end
  end

  describe 'min_length' do
    it 'requires that the value be longer than the specified amount' do
      expect {
        Validator.validate!('long', min_length: 3)
        Validator.validate!('really flippin long string', min_length: 15)
      }.not_to raise_error
    end

    it 'fails when the value is shorter than the specified amount' do
      expect {
        Validator.validate!('long', min_length: 5)
      }.to raise_error(InvalidParameterError)
      expect {
        Validator.validate!('really flippin long string', min_length: 100)
      }.to raise_error(InvalidParameterError)
    end
  end

  describe 'min_length' do
    it 'requires that the value be shorter than the specified amount' do
      expect {
        Validator.validate!('long', max_length: 5)
        Validator.validate!('really flippin long string', max_length: 50)
      }.not_to raise_error
    end

    it 'fails when the value is longer than the specified amount' do
      expect {
        Validator.validate!('longer', max_length: 5)
      }.to raise_error(InvalidParameterError)
      expect {
        Validator.validate!('really flippin long string', max_length: 15)
      }.to raise_error(InvalidParameterError)
    end
  end
end
