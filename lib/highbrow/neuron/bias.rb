module Highbrow
  module Neuron
    # Represents bias neuron
    class Bias < Base
      # Returns neuron type
      def type
        :bias
      end

      def activate
        @output = 1.0
      end
    end
  end
end
