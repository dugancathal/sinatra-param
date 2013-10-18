module Sinatra
  module Param
    class Validator
      VALIDATIONS = {
        :required => lambda {|validator, value| !(validator && value.nil?) },
        :blank    => lambda {|validator, value| (!validator && !blank?(value)) || validator },
        :is       => lambda {|validator, value| value == validator },
        :in       => lambda {|validator, value| Array(validator).include? value },
        :within   => lambda {|validator, value| Array(validator).include? value },
        :range    => lambda {|validator, value| Array(validator).include? value },
        :min      => lambda {|validator, value| value >= validator },
        :max      => lambda {|validator, value| value <= validator }, 
        :min_length => lambda {|validator, value| value.length >= validator },
        :max_length => lambda {|validator, value| value.length <= validator },
      }

      def self.validate!(value, options={})
        self.new(value, options).validate
      end

      def initialize(value, options)
        @value = value
        @options = options
      end

      def validate
        options.each do |validation, validator|
          next unless VALIDATIONS.has_key? validation
          raise InvalidParameterError if !VALIDATIONS[validation].call(validator, value)
        end
      end
      
      private

      attr_reader :value, :options

      def blank?(object)
        object.respond_to?(:empty?) ? object.empty? : !object
      end
    end
  end
end
