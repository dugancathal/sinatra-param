module Sinatra
  module Param
    class Transformer
      def self.transform(value, method)
        if method
          method.to_proc.call(value)
        else
          value
        end
      end
    end
  end
end
