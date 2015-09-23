module Highbrow
  module Neuron
    # Represents base neuron, should be subclassed
    class Base
      

      def type
        fail 'Subclass must implement this method.'
      end

      def activate
        fail 'Subclass must implement this method.'
      end
    end
  end
end
