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
    end
  end
end
