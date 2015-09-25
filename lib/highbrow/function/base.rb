module Highbrow
  module Function
    # Represents base class for function
    class Base
      def primary(input)
        fail 'Subclass must implement this method.'
      end

      def derivative(output)
        fail 'Subclass must implement this method.'
      end

      def self.from_parameters(parameters)
        instance = allocate
        instance
      end
    end
  end
end
