module Highbrow
  module Neuron
    # Implements input neuron
    class Input < Base
      attr_accessor :input

      def type
        :input
      end

      def activate
        # nothing here
      end

      def output
        # just pass input to output
        @input
      end
    end
  end
end
