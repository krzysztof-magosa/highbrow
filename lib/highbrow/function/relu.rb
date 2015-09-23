module Highbrow
  module Function
    # Represents rectifier activation function
    # https://en.wikipedia.org/wiki/Rectifier_(neural_networks)
    class ReLU
      def primary(input)
        [0, input].max
      end

      def derivative(output)
        output <= 0.0 ? 0.0 : 1.0
      end

      def upper_limit
        Float::INFINITY
      end

      def lower_limit
        -Float::INFINITY
      end
    end
  end
end
