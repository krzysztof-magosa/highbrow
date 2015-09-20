module Highbrow
  module Function
    # Represents hyperbolic tangent function
    # https://en.wikipedia.org/wiki/Hyperbolic_function
    class Tanh
      def primary(input)
        Math.tanh(input)
      end

      def derivative(output)
        1.0 - (output * output)
      end

      def upper_limit
        1.0
      end

      def lower_limit
        -1.0
      end

      def flat_spot?
        false
      end
    end
  end
end
