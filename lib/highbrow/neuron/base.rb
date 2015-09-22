module Highbrow
  module Neuron
    # Represents base neuron, should be subclassed
    class Base
      attr_accessor :function
      attr_accessor :outputs
      attr_reader :output

      def initialize
        @outputs = []
        @output = 0.0
      end

      def type
        fail 'Subclass must implement this method.'
      end

      def activate
        fail 'Subclass must implement this method.'
      end
    end
  end
end
