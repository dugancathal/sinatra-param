require 'sinatra/base'
require 'sinatra/param/version'
require 'sinatra/param/coercer'
require 'time'
require 'date'

module Sinatra
  module Param
    class InvalidParameterError < StandardError; end

    def param(name, type, options = {})
      begin
        params[name] = coerce(params[name], type, options) || options[:default]
        params[name] = options[:transform].to_proc.call(params[name]) if options[:transform]
        validate!(params[name], options)
      rescue
        error = "Invalid parameter, #{name}"
        if content_type and content_type.match(mime_type(:json))
          error = {message: error}.to_json
        end

        halt 400, error
      end
    end

    def one_of(*names)
      count = 0
      names.each do |name|
        if params[name] and present?(params[name])
          count += 1
          next unless count > 1

          error = "Parameters #{names.join(', ')} are mutually exclusive"
          if content_type and content_type.match(mime_type(:json))
            error = {message: error}.to_json
          end

          halt 400, error
        end
      end
    end

    private

    def coerce(param, type, options = {})
      Coercer.coerce(param, type)
    end

    def validate!(param, options)
      options.each do |key, value|
        case key
        when :required
          raise InvalidParameterError if value && param.nil?
        when :blank
          raise InvalidParameterError if !value && case param
              when String
                !(/\S/ === param)
              when Array, Hash
                param.empty?
              else
                param.nil?
            end
        when :is
          raise InvalidParameterError unless value === param
        when :in, :within, :range
          raise InvalidParameterError unless param.nil? || case value
              when Range
                value.include?(param)
              else
                Array(value).include?(param)
              end
        when :min
          raise InvalidParameterError unless param.nil? || value <= param
        when :max
          raise InvalidParameterError unless param.nil? || value >= param
        when :min_length
          raise InvalidParameterError unless param.nil? || value <= param.length
        when :max_length
          raise InvalidParameterError unless param.nil? || value >= param.length
        end
      end
    end

    # ActiveSupport #present? and #blank? without patching Object
    def present?(object)
      !blank?(object)
    end

    def blank?(object)
      object.respond_to?(:empty?) ? object.empty? : !object
    end
  end

  helpers Param
end
