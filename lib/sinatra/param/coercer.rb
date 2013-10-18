class Boolean
end

module Sinatra
  module Param
    class Coercer
      def self.coerce(initial_value, klass)
        return nil if initial_value.nil?
	      send klass.to_s, initial_value
      end

      %w(Time Date DateTime).each do |klass|
        define_singleton_method klass do |value|
          const_get(klass).parse(value)
        end
      end

      def self.Array(value)
	      value.to_s.split(',')
      end

      def self.Boolean(value)
        !value.to_s.match(/^(0|false|f|no|n)$/i)
      end

      def self.Hash(value)
        Hash[value.split(',').map {|item| item.split(':') }]
      end

      class << self
        alias_method :boolean, :Boolean
        alias_method :FalseClass, :Boolean
        alias_method :TrueClass, :Boolean
      end
    end
  end
end
